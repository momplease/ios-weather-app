//
//  AZCache.m
//  2016-07-13
//
//  Created by Andrii Zaitsev on 2/11/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import "AZCache.h"
#import <Foundation/Foundation.h>

@interface AZCache()
@property (strong, nonatomic) NSMutableDictionary* holder;
@end

@implementation AZCache

+ (AZCache*)sharedCache {
    static AZCache *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AZCache alloc] init];
    });
    return sharedInstance;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.holder = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addObject:(id)object forKey:(NSString*)key {
    [self.holder setObject:object forKey:key];
}

- (id)objectForKey:(NSString*)key {
    return [self.holder objectForKey:key];
}

@end
