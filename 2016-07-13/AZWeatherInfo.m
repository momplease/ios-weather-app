//
//  AZWeatherInfo.m
//  2016-07-13
//
//  Created by Andrii Zaitsev on 1/13/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import "AZWeatherInfo.h"
#import <objc/runtime.h>

@interface AZWeatherInfo(){
@private unsigned int _propertiesCount;
}
@end

@implementation AZWeatherInfo

- (instancetype)initWithDate:(NSString*)date
                 weatherDesc:(AZWeatherDesc*)weatherDesc
                  maxtempByC:(NSNumber*)maxTemp
                  mintempByC:(NSNumber*)minTemp
                     sunrise:(NSString*)sunrise
                      sunset:(NSString*)sunset
               windspeedKmph:(NSNumber*)speed
{
    self = [super init];
    if (self) {
        self.date = date;
        self.weatherDesc = weatherDesc;
        self.maxtempByC = maxTemp;
        self.mintempByC = minTemp;
        self.sunrise = sunrise;
        self.sunset = sunset;
        self.windspeedKmph = speed;
        
        
        class_copyPropertyList([self class], &_propertiesCount);
        
    }
    return self;
}


- (NSDictionary*)weatherInfoAsDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    const char * propertyName;
    id propertyValue;
    for (int i = 0; i < outCount; ++i) {
        propertyName = property_getName(properties[i]);
        
        propertyValue = [self valueForKey:[NSString stringWithUTF8String:propertyName]];
        if (propertyValue == nil) {
            propertyValue = [[NSNull alloc] init];
        } else {
            [dictionary setObject:propertyValue forKey:[NSString stringWithUTF8String:propertyName]];
        }
    }
    return dictionary;
    
}

- (NSArray*)weatherInfoAsArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    const char *propertyName;
    id propertyValue;
    for (int i = 0; i < outCount; ++i) {
        propertyName = property_getName(properties[i]);
        propertyValue = [self valueForKey:[NSString stringWithUTF8String:propertyName]];
        if (propertyValue == nil) {
            propertyValue = [[NSNull alloc] init];
        } else {
            [array addObject: propertyValue];
        }
    }
    return array;
}

- (NSInteger)count {
    NSLog(@"PROP COUNT %ld", (long)_propertiesCount);
    return (NSInteger)_propertiesCount;
}


@end
