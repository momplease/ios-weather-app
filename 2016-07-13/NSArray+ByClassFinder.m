//
//  NSArray+ByClassFinder.m
//  2016-07-13
//
//  Created by Andrii Zaitsev on 11/24/16.
//  Copyright © 2016 Andrii Zaitsev. All rights reserved.
//

#import "NSArray+ByClassFinder.h"

@implementation NSArray (ByClassFinder)
    
-(id)findByClass:(Class)anyClass {
    id foundClass;
    for (NSInteger i = 0; i < self.count; ++i) {
        if([[self objectAtIndex:i] isKindOfClass:anyClass]) {
            foundClass = [self objectAtIndex:i];
            break;
        }
    }
    return foundClass;
}
    
@end
