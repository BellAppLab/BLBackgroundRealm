/*
 Copyright (c) 2018 Bell App Lab <apps@bellapplab.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/**
 The `BLBackgroundRealmErrorCode` enum describes the errors that may occur while dealing with the `BLBackgroundRealm` module.
 */
typedef enum : NSUInteger {
    /// This error occurs when no `[RLMRealmConfiguration backgroundConfiguration]` has been set and no configuration has been passed to `[RLMRealm writeInBackgroundWithBlock:]`.
    BLBackgroundRealmErrorNoBackgroundConfiguration,
    /// During a write operation in the background, `BLBackgroundRealm` will try to refresh its `realm` before changing it. This error describes the situation where it wasn't possible to perform that refresh for some reason.
    BLBackgroundRealmErrorCodeRefresh,
    /// A generic error, usually encapsulating an underlying error coming from `RLMRealm` itself.
    BLBackgroundRealmErrorCodeGeneric,
} BLBackgroundRealmErrorCode;


/**
 The `BLBackgroundRealmError` class describes the errors that may occur while dealing with the `BLBackgroundRealm` module.
 */
@interface BLBackgroundRealmError: NSObject
    
+ (instancetype)errorWithCode:(BLBackgroundRealmErrorCode)code;
+ (instancetype)genericErrorWithError:(NSError * __nullable)error;
- (instancetype)initWithCode:(BLBackgroundRealmErrorCode)code;
- (instancetype)initWithGenericError:(NSError * __nullable)error;

@property (readonly) BLBackgroundRealmErrorCode code;
@property (readonly, copy) NSString * localizedDescription;

@end

NS_ASSUME_NONNULL_END
