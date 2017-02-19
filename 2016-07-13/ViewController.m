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
#import "Segues.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* addedCities;
@property NSString *selectedCity;
@property CLLocationCoordinate2D selectedCoords;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.addedCities = [self loadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self saveData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load data

-(NSMutableArray * _Nonnull)loadData {
    NSMutableArray *cities = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"AddedCities.plist"];
    if ([fileManager fileExistsAtPath:path]) {
        cities = [NSMutableArray arrayWithContentsOfFile:path];
    } else {
        cities = [[NSMutableArray alloc] init];
    }
    return cities;
}

#pragma mark - CitiesAddingControllerDelegate
- (void)addCity:(NSString *)city {
    [self.addedCities addObject:city];
    [self.tableView reloadData];
}

-(NSArray *)existingCities {
    NSArray *existingCities = [NSArray arrayWithArray:self.addedCities];
    return existingCities;
}

#pragma mark - MapViewControllerDelegate

- (void)showWeatherInfoForLocationCoords:(CLLocationCoordinate2D)coords {
    //self.cwc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
    //            instantiateViewControllerWithIdentifier:@"CityWeatherController"];
    //self.cwc.navigationItem.title = [NSString stringWithFormat:@"%f %f", coords.latitude, coords.longitude];
    //self.cwc.city = nil;
    //self.cwc.worldCoord = coords;
    //[self.navigationController pushViewController:self.cwc animated:YES];
    self.selectedCoords = coords;
    //self.selectedCity = nil;
    [self performSegueWithIdentifier:kSegueToCityWeatherViewController sender:self];
}

    
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.addedCities count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.addedCities objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCity = [self.addedCities objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:kSegueToCityWeatherViewController sender:self];
}


#pragma mark - IBActions
- (IBAction)onAddButtonTap:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:kSegueToAddingCityController sender:self];
}


- (IBAction)onMapButtonTap:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:kSegueToMapViewController sender:self];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueToCityWeatherViewController]) {
        CityWeatherViewController *cwc = (CityWeatherViewController*)segue.destinationViewController;
        cwc.navigationItem.title = self.selectedCity;
        cwc.worldCoord = self.selectedCoords;
        cwc.city = nil;
        //cwc.worldCoord = CLLocationCoordinate2DMake(-1, -1);
    } else if ([segue.identifier isEqualToString:kSegueToAddingCityController]) {
        CitiesAddingController *cac = (CitiesAddingController*)segue.destinationViewController;
        cac.delegate = self;
    } else if ([segue.identifier isEqualToString:kSegueToMapViewController]) {
        MapViewController *map = (MapViewController*)segue.destinationViewController;
        map.navigationItem.title = @"World Map";
        map.delegate = self;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

#pragma mark - Saving data
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

    
@end
