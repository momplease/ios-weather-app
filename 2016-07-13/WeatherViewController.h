//
//  WeatherViewController.h
//  ios-weather-app
//
//  Created by Andrii Zaitsev on 2/19/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZWeatherInfo.h"
#import <CoreLocation/CLLocation.h>

typedef void(^NSURLSessionDataTaskCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);

@interface WeatherViewController : UIViewController

@property (strong) AZWeatherInfo *weatherInfo;
@property NSURL *hourlyImageUrl;
-(void)setWeatherInfoWithResponseData:(NSData *)data;
-(void)setImageAsync:(UIImage *)image toCellAccessoryView:(UITableViewCell *)cell;
- (NSURLSessionDataTaskCompletionHandler)createHandlerSettingWeatherInfoReloadingTableView:(UITableView *)tableView;
- (NSURLSessionDataTaskCompletionHandler)createHandlerUpdatingWeatherImageInCell:(UITableViewCell*)cell;
- (NSURLRequest*)createRequestForWorldLocation:(CLLocationCoordinate2D)_;
- (NSURLRequest*)createRequestForCity:(NSString*)_;
@end
