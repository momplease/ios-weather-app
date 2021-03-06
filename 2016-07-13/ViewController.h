//
//  ViewController.h
//  2016-07-13
//
//  Created by Andrii Zaitsev on 11/20/16.
//  Copyright © 2016 Andrii Zaitsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitiesAddingController.h"
#import "CityWeatherViewController.h"
#import "MapViewController.h"
#import "WorldLocationWeatherViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate,
                                            UITableViewDataSource,
                                            CitiesAddingControllerDelegate,
                                            MapViewControllerDelegate,
                                            CityWeatherViewControllerDelegate,
                                            WorldLocationWeatherViewControllerDelegate>

@end

