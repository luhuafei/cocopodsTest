//
//  NSDictionary+Safe.m
//  ElinkLaw
//
//  Created by DengTianran on 2017/12/6.
//  Copyright © 2017年 LHF. All rights reserved.
//
#import "NSObject+Swizzling.h"
#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
 
       
        Class classP = NSClassFromString(@"__NSPlaceholderDictionary");
        [classP hf_swizzleMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(hf_initWithObjects:forKeys:count:)];
     
        
        [self hf_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(hf_dictionaryWithObjects:forKeys:count:)];
    });
}
- (instancetype)hf_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger safeCnt = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            // nothing to do
            continue;
        }
        if (!obj) {
            NSAssert(NO, @"添加字典的对象不能为空");
            obj = [NSNull null];
        }
        safeKeys[safeCnt] = key;
        safeObjects[safeCnt] = obj;
        safeCnt++;
    }
    return [self hf_initWithObjects:safeObjects forKeys:safeKeys count:safeCnt];
}


+ (instancetype)hf_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
        id safeObjects[cnt];
        id safeKeys[cnt];
        NSUInteger safeCnt = 0;
        for (NSUInteger i = 0; i < cnt; i ++) {
            id key = keys[i];
            id obj = objects[i];
            if (!key) {
                // nothing to do
                continue;
            }
            if (!obj) {                NSAssert(NO, @"添加字典的对象不能为空");
                obj = [NSNull null];
            }
            safeKeys[safeCnt]    = key;
            safeObjects[safeCnt] = obj;
            safeCnt ++;
        }
        return [self hf_dictionaryWithObjects:safeObjects forKeys:safeKeys count:safeCnt];
}


@end
