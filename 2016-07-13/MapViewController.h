//
//  MapViewController.h
//  2016-07-13
//
//  Created by Andrii Zaitsev on 2/6/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapViewControllerDelegate <NSObject>
@required
- (void)showWeatherInfoForLocationCoords:(CLLocationCoordinate2D)coords;
@end

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic) id<MapViewControllerDelegate> delegate;
@end
