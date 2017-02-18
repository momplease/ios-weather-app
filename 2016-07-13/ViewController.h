//
//  ViewController.h
//  2016-07-13
//
//  Created by Andrii Zaitsev on 11/20/16.
//  Copyright © 2016 Andrii Zaitsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitiesAddingController.h"
#import "CityWeatherController.h"
#import "MapViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate,
                                            UITableViewDataSource,
                                            CitiesAddingControllerDelegate,
                                            MapViewControllerDelegate>

- (void) saveData;

#pragma mark - UITableViewDataSource
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark - CitiesAddingControllerDelegate
    -(void)addCity:(NSString*)city;
#pragma mark - MapViewControllerDelegate
    -(void)showWeatherInfoForCoords:(CGPoint)coords;
@end

