//
//  CityWeatherController.m
//  2016-07-13
//
//  Created by Andrii Zaitsev on 1/8/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import "CityWeatherViewController.h"
#import "CityWeatherTableViewCell.h"
#import "AZCache.h"

const NSInteger kWeatherDescCellHeight = 150;

@interface CityWeatherViewController()
@property (weak, nonatomic) IBOutlet UITableView *cityWeatherTableView;
@end

@implementation CityWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.delegate cityName];
    
    // No need, creating my own cells
    //[self.cityWeatherTableView registerClass:[CityWeatherTableViewCell class]
    //               forCellReuseIdentifier:[CityWeatherTableViewCell identifier]];
    
    self.cityWeatherTableView.tableFooterView = [[UIView alloc] init];
    
    NSString *cityName = [NSString stringWithString:[self.delegate cityName]];
    NSURLRequest *weatherRequest = [super createRequestForCity:cityName];
    NSURLSessionDataTaskCompletionHandler completion = [super createHandlerSettingWeatherInfoReloadingTableView:
                                                        self.cityWeatherTableView];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:weatherRequest
                                     completionHandler:completion] resume];
    
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [[NSURLSession sharedSession] invalidateAndCancel];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super.weatherInfo count] - 1; //temporary
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [CityWeatherTableViewCell identifier]];
    
    if (cell == nil) {
        cell = [[CityWeatherTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                               reuseIdentifier:[CityWeatherTableViewCell identifier]];
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
                [[[NSURLSession sharedSession] dataTaskWithURL: super.hourlyImageUrl
                                             completionHandler: [super createHandlerUpdatingWeatherImageInCell:cell]] resume];
            });
            
            
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat rowHeight = tableView.rowHeight;
    
    NSArray *keys = [[self.weatherInfo weatherInfoAsDictionary] allKeys];
    if (indexPath.row == [keys indexOfObject:@"weatherDesc"]) {
        rowHeight = kWeatherDescCellHeight;
    }
    return rowHeight;
    
}



@end
