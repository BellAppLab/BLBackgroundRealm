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

#import "BLBackgroundRealmError.h"


NS_ASSUME_NONNULL_BEGIN

@interface BLBackgroundRealmError()

@property (nonatomic, strong) NSError * __nullable underlyingError;

@end


@implementation BLBackgroundRealmError
    
+ (instancetype)errorWithCode:(BLBackgroundRealmErrorCode)code
{
    return [[BLBackgroundRealmError alloc] initWithCode:code];
}
    
+ (instancetype)genericErrorWithError:(NSError * __nullable)error
{
    return [[BLBackgroundRealmError alloc] initWithGenericError:error];
}
    
- (instancetype)initWithCode:(BLBackgroundRealmErrorCode)code
{
    NSAssert(code != BLBackgroundRealmErrorCodeGeneric, @"Cannot initialise a BLBackgroundRealmError with a BLBackgroundRealmErrorCodeGeneric. Use initWithGenericError: instead.");
    if (self = [super init]) {
        _code = code;
    }
    return self;
}
    
- (instancetype)initWithGenericError:(NSError * __nullable)error
{
    if (self = [super init]) {
        _code = BLBackgroundRealmErrorCodeGeneric;
        _underlyingError = error;
    }
    return self;
}
    
@synthesize code = _code;
    
- (NSString * __nonnull)localizedDescription
{
    switch (_code)
    {
        case BLBackgroundRealmErrorCodeGeneric:
            if (_underlyingError) return _underlyingError.localizedDescription;
            return @"Something went wrong while using Background Realm. This shouldn't ever happen though... Please go to https://github.com/BellAppLab/BackgroundRealm/issues and talk to us about it.";
        case BLBackgroundRealmErrorNoBackgroundConfiguration:
            return @"Trying to write a transaction to a Realm in the background, but `Realm.Configuration.backgroundConfiguration` is empty.";
        case BLBackgroundRealmErrorCodeRefresh:
            return @"Couldn't refresh a background Realm";
    }
}

@end

NS_ASSUME_NONNULL_END
