//
//  CityWeatherController.m
//  2016-07-13
//
//  Created by Andrii Zaitsev on 1/8/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import "CityWeatherViewController.h"
#import "CityWeatherTableViewCell.h"
#import "AZCache.h"
#import "WeatherViewController.h"

@interface CityWeatherViewController()
@property (weak, nonatomic) IBOutlet UITableView *cityInfoTableView;
@property AZWeatherInfo* cityWeatherInfo;
@property NSURL *hourlyImageUrl;
@end

@implementation CityWeatherController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.cityInfoTableView registerClass:[CityWeatherTableViewCell class]
                   forCellReuseIdentifier:[CityWeatherTableViewCell identifier]];
    
    self.cityInfoTableView.tableFooterView = [[UIView alloc] init];
    
    // Do any additional setup after loading the view.
    
    //if (self.city != nil) {
    
    [[[NSURLSession sharedSession]
      dataTaskWithRequest: [self createRequestForCity:[NSString stringWithString:self.city]]
        completionHandler: self.createHandlerSettingWeatherInfoOnResponse] resume];
        
    //} else if (self.worldCoord.latitude != -1 && self.worldCoord.latitude != -1) {
        
    //    [[[NSURLSession sharedSession]
    //      dataTaskWithRequest: [self createRequestForWorldLocation:self.worldCoord]
    //      completionHandler: self.setWeatherInfoOnResponse] resume];
        
    //}
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSURLSession sharedSession] invalidateAndCancel];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSURLRequest*)createRequestForCity:(NSString*)cityName {
    NSMutableString *requestString = [NSMutableString stringWithString:@"https://api.worldweatheronline.com/premium/v1/weather.ashx?"];
    [requestString appendString:@"key=ac954610b0da4fa7bb615919172101&"];
    
    cityName = [cityName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [requestString appendString:[NSString stringWithFormat:@"%@=%@&", @"q", cityName]];
    [requestString appendString:[NSString stringWithFormat:@"%@=%@&", @"num_of_days", @"1"]];
    [requestString appendString:@"format=json"];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"GET"];
    
    return request;
}

/*- (NSURLRequest*)createRequestForWorldLocation:(CLLocationCoordinate2D)worldCoords {
    NSMutableString *requestString = [NSMutableString stringWithString:@"https://api.worldweatheronline.com/premium/v1/weather.ashx?"];
    [requestString appendString:@"key=ac954610b0da4fa7bb615919172101&"];
    
    [requestString appendString:[NSString stringWithFormat:@"%@=%f,%f&", @"q", worldCoords.latitude, worldCoords.longitude]];
    [requestString appendString:[NSString stringWithFormat:@"%@=%@&", @"num_of_days", @"1"]];
    [requestString appendString:@"format=json"];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"GET"];
    
    return request;
}*/

#pragma mark - Block wrappers

- (NSURLSessionDataTaskCompletionHandler)createHandlerSettingWeatherInfoOnResponse {
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTaskCompletionHandler completion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"ERROR: %@", error);
        NSLog(@"RESPONSE: %@", response);
        
        if (data && ![error code]) {
            
            NSMutableDictionary* responseInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:nil];
            
            NSLog(@"DATA: %@", responseInfo);
            
            id weatherInfo = [[responseInfo objectForKey:@"data"] objectForKey:@"weather"];
            id hourlyInfo = [[[weatherInfo objectAtIndex:0] objectForKey:@"hourly"] objectAtIndex:0];
            id astronomyInfo = [[[weatherInfo objectAtIndex:0] objectForKey:@"astronomy"] objectAtIndex:0];
            weakSelf.hourlyImageUrl = [NSURL URLWithString:[[[hourlyInfo objectForKey:@"weatherIconUrl"]
                                                           objectAtIndex:0] objectForKey:@"value"]];
            
            weakSelf.cityWeatherInfo = [[AZWeatherInfo alloc] initWithDate:[[weatherInfo objectAtIndex:0] objectForKey:@"date"]
                                                           weatherDesc:[[[hourlyInfo objectForKey:@"weatherDesc"]
                                                                         objectAtIndex:0]
                                                                        objectForKey:@"value"]
                                                      weatherDescImage: [[AZCache<UIImage *> sharedCache] objectForKey:weakSelf.city]
                                                            maxtempByC:[[weatherInfo objectAtIndex:0]
                                                                        objectForKey:@"maxtempC"]
                                                            mintempByC:[[weatherInfo objectAtIndex:0]
                                                                        objectForKey:@"mintempC"]
                                                               sunrise:[astronomyInfo objectForKey:@"sunrise"]
                                                                sunset:[astronomyInfo objectForKey:@"sunset"]
                                                         windspeedKmph:[hourlyInfo objectForKey:@"windspeedKmph"] ];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [weakSelf.cityInfoTableView reloadData];
            });
            
        }
        
        
    };
    
    return completion;
}


- (NSURLSessionDataTaskCompletionHandler)weatherImageDidDownloadUpdateCell:(UITableViewCell*)cell {
    __weak UITableViewCell *inCell = cell;
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTaskCompletionHandler completion = ^(NSData *data, NSURLResponse *response, NSError *error) {
                                        if (data && ![error code]) {
                                            UIImage *downloadedWeatherImage = [UIImage imageWithData:data];
                                            [weakSelf setImageAsync:downloadedWeatherImage toCellAccessoryView:inCell];
                                            
                                            
                                            
                                            if (weakSelf.city != nil) {
                                                [[AZCache<UIImage *> sharedCache] addObject:downloadedWeatherImage
                                                                                     forKey:weakSelf.city];
                                            }
                                            weakSelf.cityWeatherInfo.weatherDescImage = downloadedWeatherImage;
                                        }
                                    };
    return completion;
}

- (void)setImageAsync:(UIImage*)image toCellAccessoryView:(UITableViewCell*)cell {
    __weak UITableViewCell *inCell = cell;
    dispatch_async(dispatch_get_main_queue(), ^(){
        inCell.accessoryView = [[UIImageView alloc] initWithImage:image];
        [inCell setNeedsLayout];
    });
}



#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cityWeatherInfo count] - 1; //temporary
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:
                              [CityWeatherTableViewCell identifier] forIndexPath:indexPath];
    
    //as tableView always return cell when using storyboard
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:[CityWeatherTableViewCell identifier]];
    }
    
    if (self.cityWeatherInfo != nil) {
        
        NSArray *keys = [[self.cityWeatherInfo weatherInfoAsDictionary] allKeys];
    
        cell.detailTextLabel.text = keys[indexPath.row];
        //cell.textLabel.text = [[self.cityWeatherInfo weatherInfoAsDictionary] objectForKey:keys[indexPath.row]];
    
        id textValue = [[self.cityWeatherInfo weatherInfoAsDictionary] objectForKey:keys[indexPath.row]];
        if ([textValue isKindOfClass:[NSNumber class]]) {
            cell.textLabel.text = [(NSNumber*)textValue stringValue];
        } else {
            cell.textLabel.text = textValue;
        }
        
        NSInteger indexOfWeatherDesc = [keys indexOfObject:@"weatherDesc"];
        if (indexOfWeatherDesc == indexPath.row) {
            
            UIActivityIndicatorView *indicator;
            indicator = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
            [indicator startAnimating];
            cell.accessoryView = indicator;
            indicator.hidesWhenStopped = YES;
            
            __weak typeof(self) weakSelf = self;
        
            if ([[AZCache<UIImage *> sharedCache] objectForKey:weakSelf.city] == nil) {
                //kostyl to imitate async download
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[[NSURLSession sharedSession] dataTaskWithURL: weakSelf.hourlyImageUrl
                                                 completionHandler: [weakSelf weatherImageDidDownloadUpdateCell:cell]] resume];
                });
            } else {
                [self setImageAsync:[[AZCache<UIImage *> sharedCache]
                                     objectForKey:weakSelf.city] toCellAccessoryView:cell];
            }
        
        
            
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat rowHeight = tableView.rowHeight;
    
    NSArray *keys = [[self.cityWeatherInfo weatherInfoAsDictionary] allKeys];
    if (indexPath.row == [keys indexOfObject:@"weatherDesc"]) {
        rowHeight = tableView.rowHeight + 100;
    }
    return rowHeight;
    
}



@end
