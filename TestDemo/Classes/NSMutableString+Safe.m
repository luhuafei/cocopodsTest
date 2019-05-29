//
// NSMutableString+Safe.h
//  iPhoneX
//
//  Created by DengTianran on 2017/8/21.
//  Copyright © 2017年 LHF. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Swizzling.h"
#import "NSMutableString+Safe.h"

@implementation NSMutableString (Safe)

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class classStr = NSClassFromString(@"__NSCFString");
        
        [classStr hf_swizzleMethod:@selector(substringFromIndex:) withMethod:@selector(safeMutable_substringFromIndex:)];
        
        
        
        [classStr hf_swizzleMethod:@selector(substringToIndex:) withMethod:@selector(safeMutable_substringToIndex:)];
     
        
         [classStr hf_swizzleMethod:@selector(substringWithRange:) withMethod:@selector(safeMutable_substringWithRange:)];
        
  
        
        
         [classStr hf_swizzleMethod:@selector(rangeOfString:options:range:locale:) withMethod:@selector(safeMutable_rangeOfString:options:range:locale:)];
      
        
         [classStr hf_swizzleMethod:@selector(appendString:) withMethod:@selector(safeMutable_appendString:)];
    });
    
}


#pragma mark --- implement method
/****************************************  substringFromIndex:  ***********************************/
/**
 从from位置截取字符串 对应 __NSCFString
 
 @param from 截取起始位置
 @return 截取的子字符串
 */
- (NSString *)safeMutable_substringFromIndex:(NSUInteger)from {
    if (from > self.length ) {
        NSAssert(NO, @"开始位置超过字符串的长度");
        return nil;
    }
    return [self safeMutable_substringFromIndex:from];
}


/****************************************  substringFromIndex:  ***********************************/
/**
 从开始截取到to位置的字符串  对应  __NSCFString
 
 @param to 截取终点位置
 @return 返回截取的字符串
 */
- (NSString *)safeMutable_substringToIndex:(NSUInteger)to {
    if (to > self.length ) {
        NSAssert(NO, @"ToIndex位置超过字符串的长度");
        return nil;
    }
    return [self safeMutable_substringToIndex:to];
}



/*********************************** rangeOfString:options:range:locale:  ***************************/
/**
 搜索指定 字符串  对应  __NSCFString
 
 @param searchString 指定 字符串
 @param mask 比较模式
 @param rangeOfReceiverToSearch 搜索 范围
 @param locale 本地化
 @return 返回搜索到的字符串 范围
 */
- (NSRange)safeMutable_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale {
    if (!searchString) {
        searchString = self;
    }
    
    if (rangeOfReceiverToSearch.location > self.length) {
        NSAssert(NO, @"开始位置超过字符串的长度");
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if (rangeOfReceiverToSearch.length > self.length) {
        NSAssert(NO, @"ToIndex位置超过字符串的长度");
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
        NSAssert(NO, @"(开始位置 + ToIndex位置)超过字符串的长度");
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    
    return [self safeMutable_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}



/*********************************** substringWithRange:  ***************************/
/**
 截取指定范围的字符串  对应  __NSCFString
 
 @param range 指定的范围
 @return 返回截取的字符串
 */
- (NSString *)safeMutable_substringWithRange:(NSRange)range {
    if (range.location > self.length) {
        NSAssert(NO, @"开始位置超过字符串的长度");
        return nil;
    }
    
    if (range.length > self.length) {
        NSAssert(NO, @"ToIndex位置超过字符串的长度");
        return nil;
    }
    
    if ((range.location + range.length) > self.length) {
        NSAssert(NO, @"(开始位置 + ToIndex位置)超过字符串的长度");
        return nil;
    }
    return [self safeMutable_substringWithRange:range];
}


/*********************************** safeMutable_appendString:  ***************************/
/**
 追加字符串 对应  __NSCFString
 
 @param aString 追加的字符串
 */
- (void)safeMutable_appendString:(NSString *)aString {
    if (!aString) {
        NSAssert(NO, @"拼接字符串不能为空");
        return;
    }
    return [self safeMutable_appendString:aString];
}
@end

