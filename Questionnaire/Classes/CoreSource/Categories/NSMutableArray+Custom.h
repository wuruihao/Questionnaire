//
//  NSMutableArray+Custom.h
//  GlobalNovel
//
//  Created by ruihao on 2017/7/3.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Custom)

- (void)addInteger:(NSInteger)integer;
- (id)safelyObjectAtIndex:(NSUInteger)index;
- (void)safelyAddObject:(id)object;
- (void)safelyAddObjectsFromArray:(NSArray *)array;
- (void)safelyRemoveAtIndex:(NSUInteger)index;

@end
