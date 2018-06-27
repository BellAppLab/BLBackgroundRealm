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

#import <Realm/Realm.h>
#import "BLBackgroundRealmClass.h"
#import "RLMRealmConfiguration+Background.h"
#import "RLMRealm+Background.h"
#import "BLBackgroundRealmError.h"
#import "BLBackgroundWorker.h"


NS_ASSUME_NONNULL_BEGIN

//MARK: - Private Interface
@interface BLBackgroundRealm ()
    
@property (nonatomic, strong) RLMRealmConfiguration *configuration;
@property (nonatomic, strong) RLMRealm * __nullable underlyingRealm;
@property (nonatomic, strong) BLBackgroundWorker *worker;

- (void)setupWithBlock:(BLBackgroundRealmBlock)block;

@end


//MARK: - Implementation
@implementation BLBackgroundRealm

//MARK: Properties
- (RLMSchema * __nullable)schema {
    return _underlyingRealm.schema;
}
    
- (RLMRealmConfiguration * __nullable)configuration {
    return _underlyingRealm.configuration;
}
    
- (BOOL)isEmpty {
    if (_underlyingRealm) return _underlyingRealm.isEmpty;
    return YES;
}
    
- (BLBackgroundWorker *)worker {
    if (!_worker) {
        _worker = [BLBackgroundWorker new];
    }
    return _worker;
}

//MARK: Initialisers
+ (instancetype)backgroundRealmWithBlock:(BLBackgroundRealmBlock)block
{
    return [[BLBackgroundRealm alloc] initWithBlock:block];
}
    
- (instancetype)initWithBlock:(BLBackgroundRealmBlock)block
{
    RLMRealmConfiguration *config = [RLMRealmConfiguration backgroundConfiguration];
    if (!config) {
        config = [RLMRealmConfiguration defaultConfiguration];
    }
    NSAssert(config, @"Trying to initialise a BLBackgroundRealm but no [RLMRealmConfiguration backgroundConfiguration] has been set.");
    
    if (self = [super init]) {
        _configuration = config;
    }
    [self setupWithBlock:block];
    return self;
}
    
+ (instancetype)backgroundRealmWithConfiguration:(RLMRealmConfiguration *)configuration
                                        andBlock:(BLBackgroundRealmBlock)block
{
    return [[BLBackgroundRealm alloc] initWithConfiguration:configuration
                                                   andBlock:block];
}
    
- (instancetype)initWithConfiguration:(RLMRealmConfiguration *)configuration
                             andBlock:(BLBackgroundRealmBlock)block
{
    NSAssert(configuration, @"Cannot initialise a BLBackgroundRealm with a nil configuration.");
    
    if (self = [super init]) {
        _configuration = configuration;
    }
    [self setupWithBlock:block];
    return self;
}
    
+ (instancetype)backgroundRealmWithFileURL:(NSURL *)url
                                  andBlock:(BLBackgroundRealmBlock)block
{
    return [[BLBackgroundRealm alloc] initWithFileURL:url
                                             andBlock:block];
}
    
- (instancetype)initWithFileURL:(NSURL *)url
                       andBlock:(BLBackgroundRealmBlock)block
{
    NSAssert(url, @"Cannot initialise a BLBackgroundRealm with a nil file URL.");
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration backgroundConfiguration];
    if (!config) config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = url;
    
    if (self = [super init]) {
        _configuration = config;
    }
    [self setupWithBlock:block];
    return self;
}

//MARK: Setup
- (void)setupWithBlock:(BLBackgroundRealmBlock)block
{
    NSAssert(block, @"Cannot create a BLBackgroundRealm with an empty block.");
    
    RLMRealmConfiguration *config = _configuration;
    
    // According to Realm's docs (https://realm.io/docs/swift/3.0.0/#opening-a-synchronized-realm),
    // synchronised, read-only Realms must be opened using `asyncOpen`
    if (config.syncConfiguration && config.readOnly) {
        [RLMRealm asyncOpenWithConfiguration:config
                               callbackQueue:[RLMRealm realmQueue]
                                    callback:^(RLMRealm * _Nullable realm,
                                               NSError * _Nullable error)
        {
            block(realm,
                  [BLBackgroundRealmError genericErrorWithError:error]);
        }];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.worker startWithBlock:^
    {
        if (!weakSelf) {
            block(nil,
                  [BLBackgroundRealmError genericErrorWithError:nil]);
            return;
        }
        
        NSError *error;
        weakSelf.underlyingRealm = [RLMRealm realmWithConfiguration:config
                                                              error:&error];
        
        if (error) {
            block(nil,
                  [BLBackgroundRealmError genericErrorWithError:error]);
            return;
        }
        
        block(weakSelf.underlyingRealm, nil);
    }];
}

@end

NS_ASSUME_NONNULL_END
