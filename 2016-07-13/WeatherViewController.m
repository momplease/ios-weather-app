//
//  WeatherViewController.m
//  ios-weather-app
//
//  Created by Andrii Zaitsev on 2/19/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import "WeatherViewController.h"

NSInteger const kWeatherDescCellHeight = 150;

@interface WeatherViewController ()

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setWeatherInfoWithResponseData:(NSData *)data {
    NSMutableDictionary* responseInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:nil];
    
    id weatherInfo = [[responseInfo objectForKey:@"data"] objectForKey:@"weather"];
    id hourlyInfo = [[[weatherInfo objectAtIndex:0] objectForKey:@"hourly"] objectAtIndex:0];
    id astronomyInfo = [[[weatherInfo objectAtIndex:0] objectForKey:@"astronomy"] objectAtIndex:0];
    self.hourlyImageUrl = [NSURL URLWithString:[[[hourlyInfo objectForKey:@"weatherIconUrl"]
                                                     objectAtIndex:0] objectForKey:@"value"]];
    
    NSString *strdesc = [[[hourlyInfo objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"];
    AZWeatherDesc *weatherDescription = [[AZWeatherDesc alloc] initWithDescription:strdesc
                                                                   andImage:[[UIImage alloc] init]];
    
    self.weatherInfo = [[AZWeatherInfo alloc] initWithDate:[[weatherInfo objectAtIndex:0] objectForKey:@"date"]
                                               weatherDesc:weatherDescription
                                                maxtempByC:[[weatherInfo objectAtIndex:0]
                                                                 objectForKey:@"maxtempC"]
                                                mintempByC:[[weatherInfo objectAtIndex:0]
                                                                 objectForKey:@"mintempC"]
                                                   sunrise:[astronomyInfo objectForKey:@"sunrise"]
                                                    sunset:[astronomyInfo objectForKey:@"sunset"]
                                             windspeedKmph:[hourlyInfo objectForKey:@"windspeedKmph"] ];
}


- (void)setImageAsync:(UIImage*)image toCellAccessoryView:(UITableViewCell*)cell {
    __weak UITableViewCell *inCell = cell;
    dispatch_async(dispatch_get_main_queue(), ^(){
        inCell.accessoryView = [[UIImageView alloc] initWithImage:image];
        [inCell setNeedsLayout];
    });
}

#pragma mark - Creating requests

- (NSURLRequest*)createRequestForCity:(NSString *)_ {
    NSMutableString *requestString = [NSMutableString stringWithString:@"https://api.worldweatheronline.com/premium/v1/weather.ashx?"];
    [requestString appendString:@"key=ac954610b0da4fa7bb615919172101&"];
    
    _ = [_ stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [requestString appendString:[NSString stringWithFormat:@"%@=%@&", @"q", _]];
    [requestString appendString:[NSString stringWithFormat:@"%@=%@&", @"num_of_days", @"1"]];
    [requestString appendString:@"format=json"];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"GET"];
    
    return request;
}


- (NSURLRequest*)createRequestForWorldLocation:(CLLocationCoordinate2D)_ {
    NSMutableString *requestString = [NSMutableString stringWithString:@"https://api.worldweatheronline.com/premium/v1/weather.ashx?"];
    [requestString appendString:@"key=ac954610b0da4fa7bb615919172101&"];
    
    [requestString appendString:[NSString stringWithFormat:@"%@=%f,%f&", @"q", _.latitude, _.longitude]];
    [requestString appendString:[NSString stringWithFormat:@"%@=%@&", @"num_of_days", @"1"]];
    [requestString appendString:@"format=json"];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"GET"];
    
    return request;
}

#pragma mark - Blocks wrappers

- (NSURLSessionDataTaskCompletionHandler)createHandlerSettingWeatherInfoReloadingTableView:(UITableView *)tableView {
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTaskCompletionHandler completion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data && ![error code]) {
            
            [weakSelf setWeatherInfoWithResponseData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [tableView reloadData];
            });
            
        }
    };
    
    return completion;
}


- (NSURLSessionDataTaskCompletionHandler)createHandlerUpdatingWeatherImageInCell:(UITableViewCell *)cell {
    __weak UITableViewCell *inCell = cell;
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTaskCompletionHandler completion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data && ![error code]) {
            UIImage *downloadedWeatherImage = [UIImage imageWithData:data];
            weakSelf.weatherInfo.weatherDesc.image = downloadedWeatherImage;
            [weakSelf setImageAsync:downloadedWeatherImage
             toCellAccessoryView:inCell];
            //if (weakSelf.city != nil) {
            //    [[AZCache<UIImage *> sharedCache] addObject:downloadedWeatherImage
            //                                         forKey:weakSelf.city];
            //}
            
        }
    };
    return completion;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

