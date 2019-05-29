//
//  NSString+Safe.h
//  iPhoneX
//
//  Created by DengTianran on 2017/8/21.
//  Copyright © 2017年 LHF. All rights reserved.
//

#import <objc/runtime.h>
#import "NSString+Safe.h"
#import "NSObject+Swizzling.h"

@implementation NSString (Safe)

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class classCFConstantStr = NSClassFromString(@"__NSCFConstantString");
        
        [classCFConstantStr hf_swizzleMethod:@selector(substringFromIndex:) withMethod:@selector(safe_substringFromIndex:)];
        
        [classCFConstantStr hf_swizzleMethod:@selector(substringToIndex:) withMethod:@selector(safe_substringToIndex:)];
        
        [classCFConstantStr hf_swizzleMethod:@selector(substringWithRange:) withMethod:@selector(safe_substringWithRange:)];
        
        [classCFConstantStr hf_swizzleMethod:@selector(rangeOfString:options:range:locale:) withMethod:@selector(safe_rangeOfString:options:range:locale:)];
        
        
        //
        Class classTaggedPointerStr = NSClassFromString(@"NSTaggedPointerString");
        
        [classTaggedPointerStr hf_swizzleMethod:@selector(substringFromIndex:) withMethod:@selector(safePoint_substringFromIndex:)];
        
        [classTaggedPointerStr hf_swizzleMethod:@selector(substringToIndex:) withMethod:@selector(safePoint_substringToIndex:)];
        
        [classTaggedPointerStr hf_swizzleMethod:@selector(substringWithRange:) withMethod:@selector(safePoint_substringWithRange:)];
        
        [classTaggedPointerStr hf_swizzleMethod:@selector(rangeOfString:options:range:locale:) withMethod:@selector(safePoint_rangeOfString:options:range:locale:)];
    });
}

#pragma mark --- implement method

/****************************************  substringFromIndex:  ***********************************/
/**
 从from位置截取字符串 对应 __NSCFConstantString
 
 @param from 截取起始位置
 @return 截取的子字符串
 */
- (NSString *)safe_substringFromIndex:(NSUInteger)from {
    if (from > self.length ) {
        NSAssert(NO, @"开始位置超过字符串的长度");
        return nil;
    }
    return [self safe_substringFromIndex:from];
}
/**
 从from位置截取字符串 对应  NSTaggedPointerString
 
 @param from 截取起始位置
 @return 截取的子字符串
 */
- (NSString *)safePoint_substringFromIndex:(NSUInteger)from {
    if (from > self.length ) {
        NSAssert(NO, @"开始位置超过字符串的长度");
        return nil;
    }
    return [self safePoint_substringFromIndex:from];
}

/****************************************  substringFromIndex:  ***********************************/
/**
 从开始截取到to位置的字符串  对应  __NSCFConstantString
 
 @param to 截取终点位置
 @return 返回截取的字符串
 */
- (NSString *)safe_substringToIndex:(NSUInteger)to {
    if (to > self.length ) {
        NSAssert(NO, @"TOIndex超过字符串的长度");
        return nil;
    }
    return [self safe_substringToIndex:to];
}

/**
 从开始截取到to位置的字符串  对应  NSTaggedPointerString
 
 @param to 截取终点位置
 @return 返回截取的字符串
 */
- (NSString *)safePoint_substringToIndex:(NSUInteger)to {
    if (to > self.length ) {
        NSAssert(NO, @"TOIndex超过字符串的长度");
        return nil;
    }
    return [self safePoint_substringToIndex:to];
}



/*********************************** rangeOfString:options:range:locale:  ***************************/
/**
 搜索指定 字符串  对应  __NSCFConstantString
 
 @param searchString 指定 字符串
 @param mask 比较模式
 @param rangeOfReceiverToSearch 搜索 范围
 @param locale 本地化
 @return 返回搜索到的字符串 范围
 */
- (NSRange)safe_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale {
    if (!searchString) {
        searchString = self;
    }
    
    if (rangeOfReceiverToSearch.location > self.length) {
        NSAssert(NO, @"NSRange.location超过字符串的长度");
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if (rangeOfReceiverToSearch.length > self.length) {
        NSAssert(NO, @"NSRange.length超过字符串的长度");
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
        NSAssert(NO, @"(NSRange.location + NSRange.length)超过字符串的长度");
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    
    return [self safe_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}


/**
 搜索指定 字符串  对应  NSTaggedPointerString
 
 @param searchString 指定 字符串
 @param mask 比较模式
 @param rangeOfReceiverToSearch 搜索 范围
 @param locale 本地化
 @return 返回搜索到的字符串 范围
 */
- (NSRange)safePoint_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale {
    if (!searchString) {
        searchString = self;
    }
    
    if (rangeOfReceiverToSearch.location > self.length) {
        NSAssert(NO, @"NSRange.location超过字符串的长度");
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if (rangeOfReceiverToSearch.length > self.length) {
        NSAssert(NO, @"NSRange.length超过字符串的长度");
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
        NSAssert(NO, @"(NSRange.location + NSRange.length)超过字符串的长度");
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    
    return [self safePoint_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}

/*********************************** substringWithRange:  ***************************/
/**
 截取指定范围的字符串  对应  __NSCFConstantString
 
 @param range 指定的范围
 @return 返回截取的字符串
 */
- (NSString *)safe_substringWithRange:(NSRange)range {
    if (range.location > self.length) {
        NSAssert(NO, @"NSRange.location超过字符串的长度");
        return nil;
    }
    
    if (range.length > self.length) {
        NSAssert(NO, @"NSRange.length超过字符串的长度");
        return nil;
    }
    
    if ((range.location + range.length) > self.length) {
        NSAssert(NO, @"(NSRange.location + NSRange.length)超过字符串的长度");
        return nil;
    }
    return [self safe_substringWithRange:range];
}

/**
 截取指定范围的字符串 对应  NSTaggedPointerString
 
 @param range 指定的范围
 @return 返回截取的字符串
 */
- (NSString *)safePoint_substringWithRange:(NSRange)range {
    if (range.location > self.length) {
        NSAssert(NO, @"NSRange.location超过字符串的长度");
        return nil;
    }
    
    if (range.length > self.length) {
        NSAssert(NO, @"NSRange.length超过字符串的长度");
        return nil;
    }
    
    if ((range.location + range.length) > self.length) {
        NSAssert(NO, @"(NSRange.location + NSRange.length)超过字符串的长度");
        return nil;
    }
    return [self safePoint_substringWithRange:range];
}

@end

