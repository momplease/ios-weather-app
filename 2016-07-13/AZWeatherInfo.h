//
//  AZWeatherInfo.h
//  2016-07-13
//
//  Created by Andrii Zaitsev on 1/13/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AZWeatherDesc.h"

@interface AZWeatherInfo : NSObject

    @property NSString* date;
    @property AZWeatherDesc* weatherDesc;
    @property NSNumber* maxtempByC;
    @property NSNumber* mintempByC;
    @property NSString* sunset;
    @property NSString* sunrise;
    @property NSNumber* windspeedKmph;

- (instancetype)initWithDate:(NSString*)date
                 weatherDesc:(AZWeatherDesc*)weatherDesc
                  maxtempByC:(NSNumber*)maxTemp
                  mintempByC:(NSNumber*)minTemp
                     sunrise:(NSString*)sunrise
                      sunset:(NSString*)sunset
               windspeedKmph:(NSNumber*)speed;

- (NSDictionary*)weatherInfoAsDictionary;
- (NSArray*)weatherInfoAsArray;
- (NSInteger)count;


@end
