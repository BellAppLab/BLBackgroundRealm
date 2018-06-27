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

#import "BLBackgroundWorker.h"


typedef void(^BLBackgroundWorkerBlock)(void);


@interface BLBackgroundWorker ()

@property (nonatomic, strong) NSThread *thread;
@property (nonatomic, copy) BLBackgroundWorkerBlock block;

@property (readonly) BOOL isRunning;
    
- (void)runBlock;
- (void)runRunLoop;
    
- (void)stop;

@end


@implementation BLBackgroundWorker
    
- (void)dealloc {
    [self stop];
}
    
- (BOOL)isRunning {
    if (!self.thread) return NO;
    return !self.thread.isCancelled;
}
    
- (void)runBlock {
    _block();
}
    
- (void)startWithBlock:(BLBackgroundWorkerBlock)block
{
    if (self.isRunning) {
        [self stop];
    }
    
    self.block = block;
    
    self.thread = [[NSThread alloc] initWithTarget:self
                                          selector:@selector(runRunLoop)
                                            object:nil];
    self.thread.name = [NSString stringWithFormat:@"%@-%@", NSStringFromClass([self class]), [NSUUID UUID].UUIDString];
    [self.thread start];
    
    [self performSelector:@selector(runBlock)
                 onThread:self.thread
               withObject:nil
            waitUntilDone:NO
                    modes:@[NSDefaultRunLoopMode]];
}
    
- (void)runRunLoop {
    while (self.isRunning) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
    [NSThread exit];
}
    
- (void)stop {
    [self.thread cancel];
    self.thread = nil;
}

@end
