//
//  NSMutableArray+Custom.m
//  GlobalNovel
//
//  Created by ruihao on 2017/7/3.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "NSMutableArray+Custom.h"

@implementation NSMutableArray (Custom)

- (void)addInteger:(NSInteger)integer
{
    NSNumber *number = [NSNumber numberWithInteger:integer];
    [self safelyAddObject:number];
}

- (id)safelyObjectAtIndex:(NSUInteger)index {
    if (self &&[self isKindOfClass:[NSArray class]] && self.count > index) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (void)safelyAddObject:(id)object {
    if (self &&[self isKindOfClass:[NSArray class]] && object) {
        [self addObject:object];
    }
}

- (void)safelyAddObjectsFromArray:(NSArray *)array{
    if (self &&[self isKindOfClass:[NSArray class]] &&
        [array isKindOfClass:[NSArray class]] && array.count>0){
        [self addObjectsFromArray:array];
    }
}

- (void)safelyRemoveAtIndex:(NSUInteger)index {
    if (self &&[self isKindOfClass:[NSMutableArray class]] && self.count > index) {
        [self removeObjectAtIndex:index];
    }
}

@end
