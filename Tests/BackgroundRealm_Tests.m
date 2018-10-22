#import <XCTest/XCTest.h>
#import <Realm/Realm.h>
#import <BLBackgroundRealm/BLBackgroundRealm.h>
#import "TestObject.h"


@interface BackgroundRealm_Tests : XCTestCase

@property (nonatomic, strong) BLBackgroundRealm *defaultBackgroundRealm;
@property (nonatomic, strong) BLBackgroundRealm *backgroundBackgroundRealm;
@property (nonatomic, strong) BLBackgroundRealm *customBackgroundRealm;
@property (nonatomic, strong) BLBackgroundRealm *fileBackgroundRealm;
@property (nonatomic, strong) BLBackgroundRealm *updateBackgroundRealm;

@property (nonatomic, strong) RLMNotificationToken *backgroundWriteToken;

@end


@implementation BackgroundRealm_Tests

- (void)testInitialisingBackgroundRealmWithTheDefaultConfiguration {
    XCTestExpectation *expectRealm = [self expectationWithDescription:@"We should be able to create a BackgroundRealm from Realm.Configuration.default"];

    __weak typeof(self) weakSelf = self;
    _defaultBackgroundRealm = [BLBackgroundRealm backgroundRealmWithBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) {
        XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
        XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
        
        XCTAssertNotEqual([NSThread currentThread], [NSThread mainThread], "We should be in the background");

        [weakSelf setDefaultBackgroundRealm:nil];
        [expectRealm fulfill];
    }];
    
    [self waitForExpectations:@[expectRealm]
                      timeout:3];
}

- (void)testInitialisingBackgroundRealmWithTheBackgroundConfiguration {
    XCTestExpectation *expectRealm = [self expectationWithDescription:@"We should be able to create a BackgroundRealm from Realm.Configuration.backgroundConfiguration"];
    
    NSURL *url = [[[RLMRealmConfiguration defaultConfiguration].fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"testInitialisingBackgroundRealmWithTheBackgroundConfiguration.realm"];
    XCTAssertNotNil(url, "The test realm URL shouldn't be nil");
    NSLog(@"URL: %@", url);
    
    RLMRealmConfiguration *config = [[RLMRealmConfiguration alloc] init];
    config.fileURL = url;
    [RLMRealmConfiguration setBackgroundConfiguration:config];

    __weak typeof(self) weakSelf = self;
    _backgroundBackgroundRealm = [BLBackgroundRealm backgroundRealmWithBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) {
        XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
        XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
        
        XCTAssertNotEqual([NSThread currentThread], [NSThread mainThread], "We should be in the background");
        
        XCTAssertNotNil(realm.configuration.fileURL,
                        "The background realm's configuration shouldn't be empty");
        XCTAssertTrue([realm.configuration.fileURL.absoluteString isEqualToString:config.fileURL.absoluteString],
                      "The background realm's URL should be equal to the one set on Realm.Configuration.backgroundConfiguration");

        [weakSelf setBackgroundBackgroundRealm:nil];
        [expectRealm fulfill];
    }];
    
    [self waitForExpectations:@[expectRealm]
                      timeout:3];
}

- (void)testInitialisingBackgroundRealmWithCustomConfiguration {
    XCTestExpectation *expectRealm = [self expectationWithDescription:@"We should be able to create a BackgroundRealm with a custom configuration"];
    
    NSURL *url = [[[RLMRealmConfiguration defaultConfiguration].fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"testInitialisingBackgroundRealmWithCustomConfiguration.realm"];
    XCTAssertNotNil(url, "The test realm URL shouldn't be nil");
    NSLog(@"URL: %@", url);
    
    RLMRealmConfiguration *config = [[RLMRealmConfiguration alloc] init];
    config.fileURL = url;

    [RLMRealmConfiguration setBackgroundConfiguration:[RLMRealmConfiguration defaultConfiguration]];

    __weak typeof(self) weakSelf = self;
    _customBackgroundRealm = [BLBackgroundRealm backgroundRealmWithConfiguration:config
                                                                        andBlock:^(RLMRealm * _Nullable realm,
                                                                                   BLBackgroundRealmError * _Nullable error)
    {
        XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
        XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
        
        XCTAssertNotEqual([NSThread currentThread], [NSThread mainThread], "We should be in the background");
        
        XCTAssertNotNil(realm.configuration.fileURL, "The background realm's configuration shouldn't be empty");
        XCTAssertTrue([realm.configuration.fileURL.absoluteString isEqualToString:config.fileURL.absoluteString], "The background realm's URL should be equal to the one set on Realm.Configuration.backgroundConfiguration");
        XCTAssertFalse([realm.configuration.fileURL.absoluteString isEqualToString:[RLMRealmConfiguration backgroundConfiguration].fileURL.absoluteString], "The background realm's URL should be equal to the one set upon initialisation");

        [weakSelf setCustomBackgroundRealm:nil];
        [expectRealm fulfill];
    }];
    
    [self waitForExpectations:@[expectRealm]
                      timeout:3];
}

- (void)testInitialisingBackgroundRealmWithFileURL {
    XCTestExpectation *expectRealm = [self expectationWithDescription:@"We should be able to create a BackgroundRealm with a custom file URL"];
    
    NSURL *url = [[[RLMRealmConfiguration defaultConfiguration].fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"testInitialisingBackgroundRealmWithFileURL.realm"];
    XCTAssertNotNil(url, "The test realm URL shouldn't be nil");
    NSLog(@"URL: %@", url);

    [RLMRealmConfiguration setBackgroundConfiguration:[RLMRealmConfiguration defaultConfiguration]];

    __weak typeof(self) weakSelf = self;
    _fileBackgroundRealm = [BLBackgroundRealm backgroundRealmWithFileURL:url
                                                                andBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error)
    {
        XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
        XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
        
        XCTAssertNotEqual([NSThread currentThread], [NSThread mainThread], "We should be in the background");
        
        XCTAssertNotNil(realm.configuration.fileURL, "The background realm's configuration shouldn't be empty");
        XCTAssertTrue([realm.configuration.fileURL.absoluteString isEqualToString:url.absoluteString], "The background realm's URL should be equal to the one set on Realm.Configuration.backgroundConfiguration");
        XCTAssertFalse([realm.configuration.fileURL.absoluteString isEqualToString:[RLMRealmConfiguration backgroundConfiguration].fileURL.absoluteString], "The background realm's URL shouldn't be equal to the one set upon initialisation");

        [weakSelf setFileBackgroundRealm:nil];
        [expectRealm fulfill];
    }];
    
    [self waitForExpectations:@[expectRealm]
                      timeout:3];
}

- (void)testReceivingBackgroundChangesFromBackgroundWrite {
    XCTestExpectation *expectWrite = [self expectationWithDescription:@"We should get a background notification from a write transaction initated by a call to `realm.writeInBackground"];
    
    NSURL *url = [[[RLMRealmConfiguration defaultConfiguration].fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"testReceivingBackgroundChangesFromBackgroundWrite.realm"];
    XCTAssertNotNil(url, "The test realm URL shouldn't be nil");
    NSLog(@"URL: %@", url);
    
    RLMRealmConfiguration *config = [[RLMRealmConfiguration alloc] init];
    config.fileURL = url;
    [RLMRealmConfiguration setBackgroundConfiguration:config];
    
    NSString *name = @"TEST TEST";
    __weak typeof(self) weakSelf = self;
    _updateBackgroundRealm = [BLBackgroundRealm backgroundRealmWithFileURL:url
                                                                  andBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error)
    {
        XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
        XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
        
        [realm beginWriteTransaction];
        [realm deleteAllObjects];
        [realm commitWriteTransaction];
        
        [weakSelf setBackgroundWriteToken:[[TestObject allObjectsInRealm:realm] addNotificationBlock:^(RLMResults * _Nullable results,
                                                                                                       RLMCollectionChange * _Nullable change,
                                                                                                       NSError * _Nullable error)
        {
            if (error) {
                XCTFail("%@", error);
                [weakSelf setBackgroundWriteToken:nil];
                [weakSelf setUpdateBackgroundRealm:nil];
                [expectWrite fulfill];
                return;
            }
            
            if (!change) {
                NSLog(@"Initial");
                return;
            }
            
            TestObject *object = [results objectAtIndex:change.insertions.firstObject.integerValue];
            
            XCTAssertFalse(change.insertions.count == 0, "We should have inserted a TestObject");
            XCTAssertNotNil(object, "We should have inserted a TestObject");
            XCTAssertTrue([object.name isEqualToString:name], "We should have inserted a TestObject with the name %@", name);
            XCTAssertNotEqual([NSThread currentThread], [NSThread mainThread], "We should be in the background");

            [weakSelf setBackgroundWriteToken:nil];
            [weakSelf setUpdateBackgroundRealm:nil];
            [expectWrite fulfill];
        }]];
        
        XCTAssertNotNil(weakSelf.backgroundWriteToken, "The observation token shouldn't be nil here");
        
        [realm writeInBackgroundWithBlock:^(RLMRealm * _Nullable bgRealm, BLBackgroundRealmError * _Nullable error) {
            TestObject *object = [[TestObject alloc] init];
            object.name = name;
            [bgRealm addObject:object];
        }];
    }];
    
    [self waitForExpectations:@[expectWrite]
                      timeout:5];
}

@end
