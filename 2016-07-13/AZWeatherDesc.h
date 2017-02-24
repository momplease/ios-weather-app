//
//  AZWeatherDesc.h
//  ios-weather-app
//
//  Created by Andrii Zaitsev on 2/24/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AZWeatherDesc : NSObject
@property NSString* weatherDescription;
@property UIImage* image;

- (instancetype)init;
- (instancetype)initWithDescription:(NSString *)description
                           andImage:(UIImage *)image;
@end
