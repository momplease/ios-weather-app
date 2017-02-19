//
//  CitiesAddingController.m
//  2016-07-13
//
//  Created by Andrii Zaitsev on 11/20/16.
//  Copyright © 2016 Andrii Zaitsev. All rights reserved.
//

#import "CitiesAddingController.h"

@interface CitiesAddingController ()
    @property (strong, nonatomic) NSArray* cities;
@end

@implementation CitiesAddingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"DefaultCities" ofType:@"plist"];
    NSArray *allCities = [[NSArray alloc] initWithContentsOfFile:path];
    NSArray *existingCities = [self.delegate existingCities];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"not SELF IN %@", existingCities];
    self.cities = [allCities filteredArrayUsingPredicate:filter];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

    
#pragma mark - UITableViewDataSource
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.cities objectAtIndex:indexPath.row];
    return cell;
}
    
    
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate addCity:[self.cities objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
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
