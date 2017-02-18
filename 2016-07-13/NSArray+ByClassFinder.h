//
//  NSArray+ByClassFinder.h
//  2016-07-13
//
//  Created by Andrii Zaitsev on 11/24/16.
//  Copyright © 2016 Andrii Zaitsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ByClassFinder)
-(id)findByClass:(Class)anyClass;
@end
