//
//  CityWeatherController.h
//  2016-07-13
//
//  Created by Andrii Zaitsev on 1/8/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AZWeatherInfo.h"
#import <CoreLocation/CoreLocation.h>

@interface CityWeatherController : UIViewController
            <UITableViewDelegate,
            UITableViewDataSource>

@property NSString* city;
@property CLLocationCoordinate2D worldCoord;

@end
