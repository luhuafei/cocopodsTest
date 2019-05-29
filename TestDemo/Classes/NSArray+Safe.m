//
//  NSArray+Safe.h
//  iPhoneX
//
//  Created by DengTianran on 2017/8/21.
//  Copyright © 2017年 LHF. All rights reserved.
//

#import <objc/runtime.h>
#import "NSArray+Safe.h"
#import "NSObject+Swizzling.h"

@implementation NSArray (Safe)

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        
        Class class0 = NSClassFromString(@"__NSArray0");
        [class0 hf_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safe_ZeroObjectAtIndex:)];

        
        Class classSI = NSClassFromString(@"__NSSingleObjectArrayI");
        [classSI hf_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safe_singleObjectAtIndex:)];
        

        
        Class classI = NSClassFromString(@"__NSArrayI");
        [classI hf_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex:)];
        

        [classI hf_swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(safe_objectAtIndexedSubscript:)];


         Class classP = NSClassFromString(@"__NSPlaceholderArray");
         [classP hf_swizzleMethod:@selector(initWithObjects:count:) withMethod:@selector(hf_initWithObjects:count:)];
    });
    
}


#pragma mark --- implement method

/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        NSAssert(NO, @"数组越界");
        return nil;
    }
    return [self safe_objectAtIndex:index];
}


/**
 取出NSArray 第index个 值 对应 __NSSingleObjectArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_singleObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        NSAssert(NO, @"数组越界");
        return nil;
    }
    return [self safe_singleObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArray0
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_ZeroObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        NSAssert(NO, @"数组越界");
        return nil;
    }
    return [self safe_ZeroObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param idx 索引 idx
 @return 返回值
 */
- (id)safe_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        NSAssert(NO, @"数组越界");
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:idx];
}

- (instancetype)hf_initWithObjects:(const id [])objects count:(NSUInteger)cnt {
        id safeObjects[cnt];
        int safeCnt = 0;
        for (int i = 0; i < cnt; i ++) {
            id obj = objects[i];
            if (obj) {
                safeObjects[safeCnt] = obj;
                safeCnt ++;
            }else
            {
              NSAssert(NO, @"数组不能添加空对象");
            }
        }
        return [self hf_initWithObjects:safeObjects count:safeCnt];
}

@end

