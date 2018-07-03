# BLBackgroundRealm [![Version](https://img.shields.io/badge/Version-1.0.2-black.svg?style=flat)](#installation) [![License](https://img.shields.io/cocoapods/l/BLBackgroundRealm.svg?style=flat)](#license)

[![Platforms](https://img.shields.io/badge/Platforms-iOS|tvOS|macOS|watchOS-brightgreen.svg?style=flat)](#installation)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/BLBackgroundRealm.svg?style=flat&label=CocoaPods)](https://cocoapods.org/pods/BLBackgroundRealm)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Twitter](https://img.shields.io/badge/Twitter-@BellAppLab-blue.svg?style=flat)](http://twitter.com/BellAppLab)

![BLBackgroundRealm](./Images/background_realm.png)

BLBackgroundRealm is a collection of handy classes and extensions that make it easier to work with `RLMRealm` in the background.

It's main focus is to enhance existing `RLMRealm`s and Realm-based code bases with very little overhead and refactoring. 

**Note**: Although this module makes it more convenient to work with a `RLMRealm` in the background, it does **not** make  `RLMRealm`s nor its objects thread-safe. They should still be accessed only from within their appropriate thread.

## Specs

* Realm 3.0.0+
* iOS 9+
* tvOS 10+
* watchOS 3+
* macOS 10.10+

### Swift

For the Swift counterpart, see [BackgroundRealm](https://github.com/BellAppLab/BackgroundRealm).

## Writing to a Realm in the background

Commiting write transactions in the background becomes as easy as:

```objc
[RLMRealm writeInBackgroundWithConfiguration:<#(nonnull RLMRealmConfiguration *)#>
                                    andBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) 
{
    <#code#>
}];
```

Optionally, you can set a default `backgroundConfiguration` that will be used in all write transactions in the background:

```objc
RLMRealmConfiguration *config = [[RLMRealmConfiguration alloc] init];
config.fileURL = url;
[RLMRealmConfiguration setBackgroundConfiguration:config];

[RLMRealm writeInBackgroundWithBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) {
    <#code#>
}];
```

Finally, you can easily move from any `Realm` instance to its background counterpart:

```objc
RLMRealm *realm = [RLMRealm defaultRealm];

[realm writeInBackgroundWithBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) {
    <#code#>
}];
```

## The `BackgroundRealm`

Background Realm exposes a `BLBackgroundRealm`  class, which basically:

1. creates a private `NSThread` and `NSRunLoop` where a new background `RLMRealm` will be opened
2. opens a `RLMRealm` in the private thread
3. runs work in the background thread

This is particularly useful if you'd like to:

- make computationally expensive changes to the `RLMRealm`
- register for change notifications in the background, without necessarily triggering a UI update right away

### Usage

- Creating a `BLBackgroundRealm` using `[RLMConfiguration backgroundConfiguration]`:

```objc
BLBackgroundRealm *bgRealm = [BLBackgroundRealm backgroundRealmWithBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) {
    <#code#>
}];
```

- Creating a `BLBackgroundRealm` using a custom configuration:

```objc
[BLBackgroundRealm backgroundRealmWithConfiguration:<#(nonnull RLMRealmConfiguration *)#> 
                                           andBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) 
{
    <#code#>
}];
```

- Creating a `BLBackgroundRealm` using a file `NSURL`:

```objc
[BLBackgroundRealm backgroundRealmWithFileURL:<#(nonnull NSURL *)#> 
                                     andBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) 
{
    <#code#>
}];
```

## Installation

### Cocoapods

```ruby
pod 'BLBackgroundRealm', '~> 1.0'
```

Then `#import <BLBackgroundRealm/BLBackgroundRealm.h>` where needed.

### Carthage

```objc
github "BellAppLab/BLBackgroundRealm" ~> 1.0
```

Then `#import <BLBackgroundRealm/BLBackgroundRealm.h>` where needed.

### Git Submodules

```shell
cd toYourProjectsFolder
git submodule add -b submodule --name BLBackgroundRealm https://github.com/BellAppLab/BLBackgroundRealm.git
```

Then drag the `BLBackgroundRealm` folder into your Xcode project.

## Forks

When forking this repo, make sure to download the Realm framework and add it manually to the project.

- [Realm - Objective-C - v3.0.0](https://static.realm.io/downloads/objc/realm-objc-3.0.0.zip)
- [Realm - Objective-C - latest](https://realm.io/docs/objc/latest/)

## Author

Bell App Lab, apps@bellapplab.com

### Credits

[Logo image](https://thenounproject.com/search/?q=background&i=635453#) by [mikicon](https://thenounproject.com/mikicon) from [The Noun Project](https://thenounproject.com/)

## License

BackgroundRealm is available under the MIT license. See the LICENSE file for more info.
