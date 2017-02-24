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

@interface CityWeatherViewController()
@property (weak, nonatomic) IBOutlet UITableView *cityWeatherTableView;
@end

@implementation CityWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.delegate cityName];
    
    // No need, creating my own cells
    //[self.cityWeatherTableView registerClass:[CityWeatherTableViewCell class]
    //               forCellReuseIdentifier:[CityWeatherTableViewCell identifier]];
    
    self.cityWeatherTableView.tableFooterView = [[UIView alloc] init];
    
    NSString *cityName = [NSString stringWithString:[self.delegate cityName]];
    NSURLRequest *weatherRequest = [super createRequestForCity:cityName];
    NSURLSessionDataTaskCompletionHandler completion = [super createHandlerSettingWeatherInfoReloadingTableView:
                                                        self.cityWeatherTableView];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:weatherRequest
                                     completionHandler:completion] resume];
    
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [[NSURLSession sharedSession] invalidateAndCancel];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super.weatherInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CityWeatherTableViewCell identifier]];
    
    if (cell == nil) {
        cell = [[CityWeatherTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                               reuseIdentifier:[CityWeatherTableViewCell identifier]];
    }
    
    
    NSDictionary *weatherInfo = [super.weatherInfo weatherInfoAsDictionary];
    NSArray *keys = [weatherInfo allKeys];
        
        
    cell.textLabel.text = keys[indexPath.row];
        
        
    id object = [weatherInfo objectForKey:keys[indexPath.row]];
        
    if ([object isKindOfClass:[NSNumber class]]) {
        cell.detailTextLabel.text = [(NSNumber *)object stringValue];
    } else if ([object isKindOfClass:[AZWeatherDesc class]]) {
            
        cell.detailTextLabel.text = ((AZWeatherDesc *)object).weatherDescription;
            
        if ([[AZImageCache sharedCache] objectForKey:self.weatherInfo.weatherDesc.weatherDescription] == nil) {
            __weak typeof(self) weakSelf = self;

            UIActivityIndicatorView *indicator;
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
            [indicator startAnimating];
            cell.accessoryView = indicator;
            indicator.hidesWhenStopped = YES;
                
            //kostyl to imitate async download
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[[NSURLSession sharedSession] dataTaskWithURL:weakSelf.hourlyImageUrl
                                         completionHandler:[weakSelf imageDidDownloadWithCompletion: ^(UIImage *downloadedImage) {
                                                                                                [weakSelf setImageAsync:downloadedImage
                                                                                                    toCellAccessoryView:cell];
                                                                                                [[AZImageCache sharedCache] addObject:downloadedImage
                                                                                                                               forKey:weakSelf.weatherInfo.weatherDesc.weatherDescription];
                                                                                                }]] resume];
            });
        } else {
            UIImage *image = [[AZImageCache sharedCache] objectForKey:self.weatherInfo.weatherDesc.weatherDescription];
            cell.accessoryView = [[UIImageView alloc] initWithImage:image];
        }
    } else {
        cell.detailTextLabel.text = object;
    }
        
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat rowHeight = tableView.rowHeight;
    
    NSArray *keys = [[self.weatherInfo weatherInfoAsDictionary] allKeys];
    if (indexPath.row == [keys indexOfObject:@"weatherDesc"]) {
        rowHeight = kWeatherDescCellHeight;
    }
    return rowHeight;
    
}

@end
