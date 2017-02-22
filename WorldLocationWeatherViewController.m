//
//  WorldLocationWeatherViewController.m
//  ios-weather-app
//
//  Created by Andrii Zaitsev on 2/19/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import "WorldLocationWeatherViewController.h"

NSString *const kWoorldLocationCellIdentifier = @"WoorldLocationCellIdentifier";

@interface WorldLocationWeatherViewController ()
@property (weak, nonatomic) IBOutlet UITableView *worldLocationWeatherTableView;
@end

@implementation WorldLocationWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CLLocationCoordinate2D coords = [self.delegate worldLocation];
    NSString *title = [NSString stringWithFormat:@"%f %f", coords.latitude, coords.longitude];
    self.navigationItem.title = title;
    
    self.worldLocationWeatherTableView.tableFooterView = [[UIView alloc] init];
    
    
    NSURLRequest *weatherRequest = [super createRequestForWorldLocation:coords];
    NSURLSessionDataTaskCompletionHandler completion = [super createHandlerSettingWeatherInfoReloadingTableView:
                                                        self.worldLocationWeatherTableView];
    [[[NSURLSession sharedSession] dataTaskWithRequest:weatherRequest
                                     completionHandler:completion] resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSURLSession sharedSession] invalidateAndCancel];
    //[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //typeof(super.weatherInfo) s = super.weatherInfo;
    //NSLog(@"%f", [s.windspeedKmph floatValue]);
    return [super.weatherInfo count] - 1; //temporary
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWoorldLocationCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                               reuseIdentifier:kWoorldLocationCellIdentifier];
    }
    if (super.weatherInfo != nil) {
        
        NSDictionary *weatherInfo = [super.weatherInfo weatherInfoAsDictionary];
        NSArray *keys = [weatherInfo allKeys];
        
        cell.textLabel.text = keys[indexPath.row];
        
        id textValue = [weatherInfo objectForKey:keys[indexPath.row]];
        
        if ([textValue isKindOfClass:[NSNumber class]]) {
            cell.detailTextLabel.text = [(NSNumber*)textValue stringValue];
        } else {
            cell.detailTextLabel.text = textValue;
        }
        
        NSInteger indexOfWeatherDesc = [keys indexOfObject:@"weatherDesc"];
        if (indexOfWeatherDesc == indexPath.row) {
            
            UIActivityIndicatorView *indicator;
            indicator = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
            [indicator startAnimating];
            cell.accessoryView = indicator;
            indicator.hidesWhenStopped = YES;
            
            __weak typeof(self) weakSelf = self;
            //if ([[AZCache<UIImage *> sharedCache] objectForKey:weakSelf.city] == nil) {
            //kostyl to imitate async download
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[[NSURLSession sharedSession] dataTaskWithURL: weakSelf.hourlyImageUrl
                                             completionHandler: [weakSelf createHandlerUpdatingWeatherImageInCell:cell]] resume];
            });
            
            
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    return rowHeight;
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
