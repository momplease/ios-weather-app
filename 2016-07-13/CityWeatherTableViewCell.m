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

-(NSString *)reuseIdentifier {
    return [CityWeatherTableViewCell identifier];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect originalTextLabelRect = self.textLabel.frame;
    CGRect newTextLabelRect;
    newTextLabelRect.origin = originalTextLabelRect.origin;
    newTextLabelRect.size = CGSizeMake(originalTextLabelRect.size.width + 30, originalTextLabelRect.size.height);
    self.textLabel.frame = newTextLabelRect;
    
    
    CGRect originalDetailTextLabelRect = self.detailTextLabel.frame;
    CGRect newDetailTextLabelRect;
    newDetailTextLabelRect.size = originalDetailTextLabelRect.size;
    newDetailTextLabelRect.origin.x = originalDetailTextLabelRect.origin.x + 30;
    newDetailTextLabelRect.origin.y = originalDetailTextLabelRect.origin.y;
    self.detailTextLabel.frame = newDetailTextLabelRect;
}

@end
