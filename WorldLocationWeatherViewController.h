//
//  WorldLocationWeatherViewController.h
//  ios-weather-app
//
//  Created by Andrii Zaitsev on 2/19/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherViewController.h"

@protocol WorldLocationWeatherViewControllerDelegate <NSObject>
@required
-(CLLocationCoordinate2D)worldLocation;
@end

@interface WorldLocationWeatherViewController : WeatherViewController
            <UITableViewDelegate,
            UITableViewDataSource>
@property (strong) id<WorldLocationWeatherViewControllerDelegate> delegate;
@end
