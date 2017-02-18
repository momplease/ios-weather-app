//
//  ViewController.m
//  2016-07-13
//
//  Created by Andrii Zaitsev on 11/20/16.
//  Copyright © 2016 Andrii Zaitsev. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+ByClassFinder.h"
#import "MapViewController.h"

@interface ViewController ()
    @property NSString *selectedCity;
    @property CLLocationCoordinate2D selectedCoords;

    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property (strong, nonatomic) CitiesAddingController* cac;
    //@property (strong, nonatomic) CityWeatherController* cwc;
    @property (strong, nonatomic) NSMutableArray* addedCities;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"AddedCities.plist"];
    if ([fileManager fileExistsAtPath:path]) {
        self.addedCities = [NSMutableArray arrayWithContentsOfFile:path];
    } else {
        self.addedCities = [[NSMutableArray alloc] init];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [self saveData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)addCity:(NSString*)city {
    [self.addedCities addObject:city];
    [self.tableView setNeedsLayout];
}

#pragma mark - MapViewControllerDelegate

- (void)showWeatherInfoForCoords:(CGPoint)coords {
    //self.cwc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
    //            instantiateViewControllerWithIdentifier:@"CityWeatherController"];
    //self.cwc.navigationItem.title = [NSString stringWithFormat:@"%f %f", coords.x, coords.y];
    //self.cwc.city = nil;
    //self.cwc.worldCoord = CLLocationCoordinate2DMake(coords.x, coords.y);
    //[self.navigationController pushViewController:self.cwc animated:YES];
}

- (void)showWeatherInfoForLocationCoords:(CLLocationCoordinate2D)coords {
    //self.cwc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
    //            instantiateViewControllerWithIdentifier:@"CityWeatherController"];
    //self.cwc.navigationItem.title = [NSString stringWithFormat:@"%f %f", coords.latitude, coords.longitude];
    //self.cwc.city = nil;
    //self.cwc.worldCoord = coords;
    //[self.navigationController pushViewController:self.cwc animated:YES];
}

    
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.addedCities count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.addedCities objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //self.cwc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
    //            instantiateViewControllerWithIdentifier:@"CityWeatherController"];
    //self.cwc.navigationItem.title = [self.addedCities objectAtIndex:indexPath.row];
    //self.cwc.city = [self.addedCities objectAtIndex:indexPath.row];
    //self.cwc.worldCoord = CLLocationCoordinate2DMake(-1, -1);
    //[self.navigationController pushViewController:self.cwc animated:YES];
    
    self.selectedCity = [self.addedCities objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SegueToCityWeatherController" sender:self];
    
}


- (IBAction)onAddButtonTap:(UIBarButtonItem *)sender {
    //self.cac = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Cities"];
    //self.cac.delegate = self;
    //self.cac.existingCities = self.addedCities;
    //UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.cac];
    //[self presentViewController:nc animated:YES completion:nil];
    [self performSegueWithIdentifier:@"SegueToAddingCityController" sender:self];
}

    
- (void) saveData {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"AddedCities.plist"];
    
    if ([fileManager fileExistsAtPath:path]) {
        [self.addedCities writeToFile:path atomically:YES];
    } else {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        [self.addedCities writeToFile:path atomically:YES];
    }
}

- (IBAction)onMapButtonTap:(UIBarButtonItem *)sender {
    MapViewController *map = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Map"];
    map.navigationItem.title = @"World Map";
    map.delegate = self;
    [self.navigationController pushViewController: map
                                            animated: YES
                                          ];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"CityWeatherController"]) {
        CityWeatherController *cwc = (CityWeatherController*)segue.destinationViewController;
        cwc.navigationItem.title = self.selectedCity;
        cwc.city = self.selectedCity;
        cwc.worldCoord = CLLocationCoordinate2DMake(-1, -1);
    } else if ([segue.identifier isEqualToString:@"CitiesAddingController"]) {
        CitiesAddingController *cac = (CitiesAddingController*)segue.destinationViewController;
        cac.delegate = self;
        cac.existingCities = self.addedCities;
    }
}


    
@end
