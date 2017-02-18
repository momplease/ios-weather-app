//
//  CitiesAddingController.h
//  2016-07-13
//
//  Created by Andrii Zaitsev on 11/20/16.
//  Copyright © 2016 Andrii Zaitsev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CitiesAddingControllerDelegate <NSObject>
    @required
    -(void)addCity:(NSString*) city;
@end


@interface CitiesAddingController : UIViewController <UITableViewDelegate, UITableViewDataSource>
    @property (nonatomic) id<CitiesAddingControllerDelegate> delegate;
    @property (strong, nonatomic) NSArray* existingCities;
#pragma mark - UITableViewDataSource
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark - UITableViewDelegate
    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
