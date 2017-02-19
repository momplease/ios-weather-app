//
//  MapViewController.m
//  2016-07-13
//
//  Created by Andrii Zaitsev on 2/6/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import "MapViewController.h"
#import "CityWeatherController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = YES;
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(onMapPanAction:)];
    [self.mapView addGestureRecognizer:gr];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onMapPanAction:(UIGestureRecognizer*)gestureRecognizer {
    CGPoint panPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:panPoint toCoordinateFromView:self.mapView];
    [self.delegate showWeatherInfoForLocationCoords:location];
}

#pragma mark - MKMapViewDelegate


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = locations.lastObject;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(1, 1));
    [self.mapView setRegion:region animated:YES];
    [manager stopUpdatingLocation];
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
