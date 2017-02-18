//
//  AZWeatherInfo.h
//  2016-07-13
//
//  Created by Andrii Zaitsev on 1/13/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AZWeatherInfo : NSObject

    @property NSString* date;
    @property NSString* weatherDesc;
    @property UIImage* weatherDescImage;
    @property NSNumber* maxtempByC;
    @property NSNumber* mintempByC;
    @property NSString* sunset;
    @property NSString* sunrise;
    @property NSNumber* windspeedKmph;

- (instancetype)initWithDate:(NSString*)date
                 weatherDesc:(NSString*)weatherDesc
            weatherDescImage:(UIImage*)image
                  maxtempByC:(NSNumber*)maxTemp
                  mintempByC:(NSNumber*)minTemp
                     sunrise:(NSString*)sunrise
                      sunset:(NSString*)sunset
               windspeedKmph:(NSNumber*)speed;

- (NSDictionary*)weatherInfoAsDictionary;
- (NSArray*)weatherInfoAsArray;
- (NSInteger)count;


@end
