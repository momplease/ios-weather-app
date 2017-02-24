//
//  AZWeatherDesc.m
//  ios-weather-app
//
//  Created by Andrii Zaitsev on 2/24/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import "AZWeatherDesc.h"

@implementation AZWeatherDesc

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.weatherDescription = @"";
        self.image = [[UIImage alloc] init];
    }
    return self;
}

- (instancetype)initWithDescription:(NSString *)description andImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.weatherDescription = description;
        self.image = image;
    }
    return self;
}

@end
