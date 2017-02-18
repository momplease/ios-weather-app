//
//  CityWeatherTableViewCell.m
//  2016-07-13
//
//  Created by Andrii Zaitsev on 2/9/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import "CityWeatherTableViewCell.h"

@implementation CityWeatherTableViewCell

+ (NSString *const)identifier {
    static NSString *const identifier = @"CityWeatherTableViewCell";
    return identifier;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
