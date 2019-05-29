//
//  NSMutableDictionary+Safe.h
//  iPhoneX
//
//  Created by DengTianran on 2017/8/21.
//  Copyright © 2017年 LHF. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Swizzling.h"
#import "NSMutableDictionary+Safe.h"

@implementation NSMutableDictionary (Safe)
#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        Class classDic = NSClassFromString(@"__NSDictionaryM");
        [classDic hf_swizzleMethod:@selector(removeObjectForKey:) withMethod:@selector(safeMutable_removeObjectForKey:)];
        
        [classDic hf_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(safeMutable_setObject:forKey:)];
        
    });
    
}

#pragma mark --- implement method

/**
 根据akey 移除 对应的 键值对
 
 @param aKey key
 */
- (void)safeMutable_removeObjectForKey:(id<NSCopying>)aKey {
    if (!aKey) {
        NSAssert(NO, @"字典key不能为空");
        return;
    }
    [self safeMutable_removeObjectForKey:aKey];
}

/**
 将键值对 添加 到 NSMutableDictionary 内
 
 @param anObject 值
 @param aKey 键
 */
- (void)safeMutable_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject) {
        NSAssert(NO, @"字典value不能为空");
        return;
    }
    if (!aKey) {
        NSAssert(NO, @"字典key不能为空");
        return;
    }
    return [self safeMutable_setObject:anObject forKey:aKey];
}

@end

