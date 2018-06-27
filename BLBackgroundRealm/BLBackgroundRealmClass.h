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
#import "BLBackgroundRealmBlock.h"


@class RLMSchema, RLMRealmConfiguration;

NS_ASSUME_NONNULL_BEGIN

//MARK: - BACKGROUND REALM
/**
 A BackgroundRealm essentially:
 
    1. creates a private NSThread and NSRunLoop where a new background `RLMRealm` will be opened
    2. opens an `RLMRealm` in the private thread
    3. executes the `completion` block in the background thread
 
 Upon successfully opening the `RLMRealm` in the background, the `completion` block is executed, which gives clients a chance to:
 
    - make computationally expensive changes to the `RLMRealm`, or
    - register for change notifications in the background
 
 This is particularly useful if you'd like to be notified of changes to a `RLMRealm` but not necessarily want to trigger a UI update right away.
 
 @warning Although a `BLBackgroundRealm` can be created from any thread, it does **not** make its underlying `RLMRealm` nor its objects thread-safe. They should still be accessed only from within their appropriate thread. In other words, **it is not safe** to use the underlying `RLMRealm` in your apps UI.
 
 ## See Also [BLBackgroundRealm backgroundRealmWithConfiguration:andBlock:]
 */
@interface BLBackgroundRealm : NSObject

//MARK: - Properties
/// The `RLMSchema` used by the underlying `RLMRealm`.
@property (readonly) RLMSchema * __nullable schema;

/// The `RLMConfiguration` value that was used to create the underlying `RLMRealm` instance.
@property (readonly) RLMRealmConfiguration * __nullable configuration;

/// Indicates if the underlying `RLMRealm` contains any objects.
@property (readonly) BOOL isEmpty;

//MARK: - Initializers
/**
 Obtains a `BLBackgroundRealm` instance with the default background configuration.
 
 @param block   block to be executed once the `BLBackgroundRealm` creates its underlying `RLMRealm` in the background.
 */
+ (instancetype)backgroundRealmWithBlock:(BLBackgroundRealmBlock)block;

/**
 Obtains a `BLBackgroundRealm` instance with the default background configuration.
 
 @param block   a block to be executed once the `BLBackgroundRealm` creates its underlying `RLMRealm` in the background.
 */
- (instancetype)initWithBlock:(BLBackgroundRealmBlock)block;

/**
 Obtains a `BLBackgroundRealm` instance with the given configuration.
 
 @param configuration   a configuration value to use when creating the `RLMRealm`. Defaults to `[RLMConfiguration backgroundConfiguration]`.
 @param block           a block to be executed once the `BLBackgroundRealm` creates its underlying `Realm` in the background.
 */
+ (instancetype)backgroundRealmWithConfiguration:(RLMRealmConfiguration *)configuration
                                        andBlock:(BLBackgroundRealmBlock)block;

/**
 Obtains a `BLBackgroundRealm` instance with the given configuration.
 
 @param configuration   a configuration value to use when creating the `RLMRealm`. Defaults to `[RLMConfiguration backgroundConfiguration]`.
 @param block           a block to be executed once the `BLBackgroundRealm` creates its underlying `RLMRealm` in the background.
 */
- (instancetype)initWithConfiguration:(RLMRealmConfiguration *)configuration
                             andBlock:(BLBackgroundRealmBlock)block;

/**
 Obtains a `BLBackgroundRealm` instance with the file URL.
 
 @param url             the file URL used to open a new `RLMRealm` in the background. It defaults to using `[RLMConfiguration backgroundConfiguration]` and setting its `fileURL` property. If no `backgroundConfiguration` is set, `[RLMConfiguration defaultConfiguration]` is used.
 @param block           a block to be executed once the `BLBackgroundRealm` creates its underlying `RLMRealm` in the background.
 */
+ (instancetype)backgroundRealmWithFileURL:(NSURL *)url
                                  andBlock:(BLBackgroundRealmBlock)block;

/**
 Obtains a `BLBackgroundRealm` instance with the file URL.
 
 @param url             the file URL used to open a new `RLMRealm` in the background. It defaults to using `[RLMConfiguration backgroundConfiguration]` and setting its `fileURL` property. If no `backgroundConfiguration` is set, `[RLMConfiguration defaultConfiguration]` is used.
 @param block           a block to be executed once the `BLBackgroundRealm` creates its underlying `RLMRealm` in the background.
 */
- (instancetype)initWithFileURL:(NSURL *)url
                       andBlock:(BLBackgroundRealmBlock)block;

@end

NS_ASSUME_NONNULL_END
