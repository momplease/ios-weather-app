//
//  AZCache.h
//  2016-07-13
//
//  Created by Andrii Zaitsev on 2/11/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AZCache<__covariant ObjectType> : NSObject

typedef AZCache<UIImage *> AZImageCache;

+ (AZCache<ObjectType>*)sharedCache;

- (void)addObject:(ObjectType)object forKey:(NSString*)key;
- (ObjectType)objectForKey:(NSString*)key;
@end
