//
//  NSArray+Safety.m
//  GlobalNovel
//
//  Created by ruihao on 2017/7/3.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "NSArray+Safety.h"

@implementation NSArray (Safety)

- (id)objectSafetyAtIndex:(NSUInteger)index{
    
    if (index >= [self count]) {
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

@end
