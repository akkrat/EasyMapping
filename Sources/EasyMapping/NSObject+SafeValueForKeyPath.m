//
//  EasyMapping
//
//  Copyright (c) 2012-2014 Lucas Medeiros.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSObject+SafeValueForKeyPath.h"

@implementation NSObject (SafeValueForKeyPath)

- (nullable id)ek_valueForJSKeyPath:(NSString *)keyPath {
    id result;
    if ([self ek_safeValueForKeyPath:keyPath value:&result]) {
        return result;
    }
    __auto_type range = NSMakeRange(0, keyPath.length);
    NSRange dot;
    NSMutableArray *results = [NSMutableArray new];
    while ((dot = [keyPath rangeOfString:@"." options:NSBackwardsSearch range:range]).location != NSNotFound) {
        range.length = dot.location;
        __auto_type prefix = [keyPath substringToIndex:dot.location];
        __auto_type suffix = [keyPath substringFromIndex:dot.location + 1];
        if (suffix.length > 0 && prefix.length > 0) {
            if ([self ek_safeValueForKeyPath:prefix value:&result]) {
                id subvalue = nil;
                if (result == nil || [result ek_safeValueForKeyPath:suffix value:&subvalue]) {
                    [results addObject:subvalue ?: NSNull.null];
                }
            }
        }
    };
    __block BOOL error = NO;
    [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == results.firstObject || [obj isEqual:results.firstObject]) {

        } else {
            *stop = YES;
            error = YES;
        }
    }];
    if (results.count > 1) {
        NSLog(@"[EasyMapping]: %@: Several values for the same keyPath. \nkeyPath = %@ \nself = %@ \nvalues: %@", (error ? @"Error" : @"Warning"), keyPath, self, results);
    }
    if (error) {
        return nil;
    }
    return results.firstObject == NSNull.null ? nil : results.firstObject;
}

- (BOOL)ek_safeValueForKeyPath:(NSString *)keyPath value:(inout id *)result {
    @try {
        id outcome = [self valueForKeyPath:keyPath];
        if (result != NULL) {
            *result = outcome;
        }
        return YES;
    } @catch (NSException *exception) {
        if ([self isKindOfClass:NSDictionary.class]) {
            NSDictionary *d = (NSDictionary *)self;
            id outcome = [d objectForKey:keyPath];
            if (result != NULL) {
                *result = outcome;
            }
            return outcome != nil;
        }
    }
    if (result != NULL) {
        *result = nil;
    }
    return NO;
}

@end
