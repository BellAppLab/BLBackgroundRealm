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
#import <Realm/RLMRealmConfiguration.h>


//MARK: - CONFIGURATION
@interface RLMRealmConfiguration (Background)

/**
 The default background configuration that `BLBackgroundRealm` uses to commit write transactions in the background.
 
 @note When no `[RLMRealmConfiguration backgroundConfiguration]` is set, you must pass a valid configuration to `[RLMRealm writeInBackgroundWithConfiguration:andBlock:]`.
 
 ## See Also:
 - `[RLMRealm writeInBackgroundWithConfiguration:andBlock:]`
 */
+ (instancetype __nullable)backgroundConfiguration;

/**
 Sets default background configuration that `BLBackgroundRealm` uses to commit write transactions in the background.
 
 @note When no `[RLMRealmConfiguration backgroundConfiguration]` is set, you must pass a valid configuration to `[RLMRealm writeInBackgroundWithConfiguration:andBlock:]`.
 
 ## See Also:
 - `[RLMRealm writeInBackgroundWithConfiguration:andBlock:]`
 */
+ (void)setBackgroundConfiguration:(RLMRealmConfiguration * __nullable)configuration;

@end
