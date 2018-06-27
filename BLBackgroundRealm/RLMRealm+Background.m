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

#import "RLMRealm+Background.h"
#import "RLMRealmConfiguration+Background.h"
#import "BLBackgroundRealmError.h"


//MARK: - Static variables
static dispatch_queue_t __nullable _realmQueue;
static NSOperationQueue * __nullable _realmOperationQueue;


NS_ASSUME_NONNULL_BEGIN

//MARK: - Private Interface
@interface RLMRealm (Background_Internal)

+ (void)commitTransactionInBackgroundWithConfiguration:(RLMRealmConfiguration * __nullable)configuration
                                              andBlock:(BLBackgroundRealmBlock)block;
@end


//MARK: - Private Implementation
@implementation RLMRealm (Background_Internal)

+ (void)commitTransactionInBackgroundWithConfiguration:(RLMRealmConfiguration * __nullable)configuration
                                              andBlock:(BLBackgroundRealmBlock)block
{
    NSAssert(block, @"Cannot write to a Realm in the background with an empty block.");
 
    __block RLMRealmConfiguration *config = configuration;
    
    //Adding an `Operation` is added to `Realm.operationQueue`
    [[RLMRealm realmOperationQueue] addOperationWithBlock:^
    {
        //Creating an autorelease pool
        @autoreleasepool {
            //Finding the right configuration
            if (!config) {
                config = [RLMRealmConfiguration backgroundConfiguration];
            }
            if (!config) {
                block(nil,
                      [BLBackgroundRealmError errorWithCode:BLBackgroundRealmErrorNoBackgroundConfiguration]);
                return;
            }
            
            //Making the background realm writable
            config.readOnly = NO;
            
            NSError *error;
            RLMRealm *realm = [RLMRealm realmWithConfiguration:config
                                                         error:&error];
            if (error) {
                block(nil, [BLBackgroundRealmError genericErrorWithError:error]);
                return;
            }
            
            //Disallowing autorefresh for performance reasons
            realm.autorefresh = NO;
            
            if (![realm refresh]) {
                block(nil, [BLBackgroundRealmError errorWithCode:BLBackgroundRealmErrorCodeRefresh]);
                return;
            }
            
            //Writing to the realm
            [realm transactionWithBlock:^{
                block(realm, nil);
            }];
        }
    }];
}
@end


//MARK: - Public Implementation
@implementation RLMRealm (Background)

+ (void)writeInBackgroundWithBlock:(BLBackgroundRealmBlock)block
{
    [RLMRealm commitTransactionInBackgroundWithConfiguration:nil
                                                    andBlock:block];
}
    
+ (void)writeInBackgroundWithConfiguration:(RLMRealmConfiguration *)configuration
                                  andBlock:(BLBackgroundRealmBlock)block
{
    [RLMRealm commitTransactionInBackgroundWithConfiguration:configuration
                                                    andBlock:block];
}
    
+ (void)writeInBackgroundWithFileURL:(NSURL *)fileURL
                            andBlock:(BLBackgroundRealmBlock)block
{
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration backgroundConfiguration];
    if (!configuration) configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.fileURL = fileURL;
    
    [RLMRealm commitTransactionInBackgroundWithConfiguration:configuration
                                                    andBlock:block];
}
    
- (void)writeInBackgroundWithBlock:(BLBackgroundRealmBlock)block
{
    RLMRealmConfiguration *configuration = self.configuration;
    [RLMRealm commitTransactionInBackgroundWithConfiguration:configuration
                                                    andBlock:block];
}

@end


//MARK: - Queues
@implementation RLMRealm (Background_Queues)
    
+ (dispatch_queue_t)realmQueue
{
    @synchronized(self) {
        if (!_realmQueue) {
            _realmQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
        }
        return _realmQueue;
    }
}
    
+ (NSOperationQueue *)realmOperationQueue
{
    @synchronized(self) {
        if (!_realmOperationQueue) {
            _realmOperationQueue = [NSOperationQueue new];
            _realmOperationQueue.name = @"BackgroundRealm.OperationQueue";
            _realmOperationQueue.underlyingQueue = [RLMRealm realmQueue];
            _realmOperationQueue.maxConcurrentOperationCount = 1;
        }
        return _realmOperationQueue;
    }
}
    
@end

NS_ASSUME_NONNULL_END
