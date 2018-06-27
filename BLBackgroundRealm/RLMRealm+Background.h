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
#import <Realm/RLMRealm.h>
#import "BLBackgroundRealmBlock.h"


NS_ASSUME_NONNULL_BEGIN

//MARK: - TRANSACTIONS
@interface RLMRealm (Background)

/**
 Similar to `[RLMRealm writeInBackgroundWithConfiguration:andBlock:]`, but `[RLMRealmConfiguration backgroundConfiguration]` to commit a write transaction in the background.
 
 @param block           the block to be executed inside the background `[realm transactionWithBlock:^{}]` call.
 
 ## See Also:
 - `[RLMRealm writeInBackgroundWithConfiguration:andBlock:]`
 */
+ (void)writeInBackgroundWithBlock:(BLBackgroundRealmBlock)block;

/**
 Upon calling this function, an `NSOperation` is added to `[RLMRealm operationQueue]` which essentially:
 
 1. creates an autorelease pool
 2. tries to find a `RLMRealmConfiguration` to open a new `RLMRealm` with
 3. opens a new `RLMRealm` in the background
 4. calls `[realm transactionWithBlock:^{}]` on the background `RLMRealm`
 
 @param configuration   an instance of `RLMRealmConfiguration` used to open a new `Realm` in the background.
                        If no `RLMRealmConfiguration` is provided, it defaults to `[RLMRealmConfiguration backgroundConfiguration]`.
                        If no `backgroundConfiguration` is set, a `BLBackgroundRealmError` with a code `BLBackgroundRealmErrorNoBackgroundConfiguration` is returned.
                        Defaults to `nil`.
 @param block           the block to be executed inside the background `[realm transactionWithBlock:^{}]` call.
 
 ## See Also:
 - [Note on autorelease pools](https://realm.io/docs/swift/latest/#threading)
 - `BLBackgroundRealmErrorNoBackgroundConfiguration`
 - `[RLMRealm operationQueue]`
 */
+ (void)writeInBackgroundWithConfiguration:(RLMRealmConfiguration *)configuration
                                  andBlock:(BLBackgroundRealmBlock)block;

/**
 Similar to `[RLMRealm writeInBackgroundWithConfiguration:andBlock:]`, but using a URL instead of a `RLMConfiguration` to commit a write transaction in the background.
 
 @param fileURL         the file URL used to open a new `RLMRealm` in the background.
                        It defaults to using `[RLMRealmConfiguration backgroundConfiguration]` and setting its `fileURL` property.
                        If no `backgroundConfiguration` is set, `[RLMRealmConfiguration defaultConfiguration]` is used.
 @param block           the block to be executed inside the background `[realm transactionWithBlock:^{}]` call.
 
 ## See Also:
 - `[RLMRealm writeInBackgroundWithConfiguration:andBlock:]`
 */
+ (void)writeInBackgroundWithFileURL:(NSURL *)fileURL
                            andBlock:(BLBackgroundRealmBlock)block;

/**
 Similar to `[RLMRealm writeInBackgroundWithConfiguration:andBlock:]`, but using an existing `RLMRealm`'s configuration to commit a write transaction in the background.
 
 If the existing `RLMRealm`'s configuration is `nil`, this method defaults to `[RLMRealmConfiguration backgroundConfiguration]`.
 If no `backgroundConfiguration` is set, a `BLBackgroundRealmError` with a code `BLBackgroundRealmErrorNoBackgroundConfiguration` is returned.
 
 @param block           the block to be executed inside the background `[realm transactionWithBlock:^{}]` call.
 
 ## See Also:
 - `[RLMRealm writeInBackgroundWithConfiguration:andBlock:]`
 */
- (void)writeInBackgroundWithBlock:(BLBackgroundRealmBlock)block;

@end


//MARK: - QUEUES
@interface RLMRealm (Background_Queues)

/// The dispatch queue used to commit background write operations to Realm
+ (dispatch_queue_t)realmQueue;

/// The opertation queue used to commit background write operations to Realm
+ (NSOperationQueue *)realmOperationQueue;
    
@end

NS_ASSUME_NONNULL_END
