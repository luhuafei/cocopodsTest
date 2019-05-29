//
//  NSMutableArray+Safe.h
//  iPhoneX
//
//  Created by DengTianran on 2017/8/21.
//  Copyright © 2017年 LHF. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Swizzling.h"
#import "NSMutableArray+Safe.h"


@implementation NSMutableArray (Safe)

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class classM = NSClassFromString(@"__NSArrayM");
        
        [classM hf_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safeMutable_objectAtIndex:)];
        
        
        [classM hf_swizzleMethod:@selector(removeObjectsInRange:) withMethod:@selector(safeMutable_removeObjectsInRange:)];
     
        
        [classM hf_swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(safeMutable_insertObject:atIndex:)];
   
        
        [classM hf_swizzleMethod:@selector(removeObject:inRange:) withMethod:@selector(safeMutable_removeObject:inRange:)];
       
        [classM hf_swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(safeMutable_objectAtIndexedSubscript:)];
        
    });
    
}

#pragma mark --- implement method

/**
 取出NSArray 第index个 值
 
 @param index 索引 index
 @return 返回值
 */
- (id)safeMutable_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        NSAssert(NO, @"数组越界");
        return nil;
    }
    return [self safeMutable_objectAtIndex:index];
}

/**
 NSMutableArray 移除 索引 index 对应的 值
 
 @param range 移除 范围
 */
- (void)safeMutable_removeObjectsInRange:(NSRange)range {

    if (range.location > self.count) {
        NSAssert(NO, @"数组越界");
        return;
    }
    
    if (range.length > self.count) {
        NSAssert(NO, @"数组越界");
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        NSAssert(NO, @"数组越界");
        return;
    }
    
     return [self safeMutable_removeObjectsInRange:range];
}


/**
 在range范围内， 移除掉anObject

 @param anObject 移除的anObject
 @param range 范围
 */
- (void)safeMutable_removeObject:(id)anObject inRange:(NSRange)range {
    if (range.location > self.count) {
        NSAssert(NO, @"数组越界");
        return;
    }
    
    if (range.length > self.count) {
        NSAssert(NO, @"数组越界");
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        NSAssert(NO, @"数组越界");
        return;
    }
    
    if (!anObject){
        NSAssert(NO, @"向数组添加一个空对象");
        return;
    }

    
    return [self safeMutable_removeObject:anObject inRange:range];

}

/**
 NSMutableArray 插入 新值 到 索引index 指定位置
 
 @param anObject 新值
 @param index 索引 index
 */
- (void)safeMutable_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count) {
        NSAssert(NO, @"数组越界");
        return;
    }
    
    if (!anObject){
         NSAssert(NO, @"向数组添加一个空对象");
        return;
    }
    [self safeMutable_insertObject:anObject atIndex:index];
}


/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param idx 索引 idx
 @return 返回值
 */
- (id)safeMutable_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
         NSAssert(NO, @"数组越界");
        return nil;
    }
    return [self safeMutable_objectAtIndexedSubscript:idx];
}
@end
