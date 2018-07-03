#import <XCTest/XCTest.h>
#import <Realm/Realm.h>
#import <BLBackgroundRealm/BLBackgroundRealm.h>
#import "TestObject.h"


@interface Realm_Background_Tests : XCTestCase

@property (nonatomic, strong) RLMNotificationToken *staticBackgroundWriteToken;
@property (nonatomic, strong) RLMNotificationToken *instanceBackgroundWriteToken;

@end


@implementation Realm_Background_Tests

- (void)setUp {
    [super setUp];
    
    [RLMRealmConfiguration setBackgroundConfiguration:nil];
    _staticBackgroundWriteToken = nil;
    _instanceBackgroundWriteToken = nil;
}

- (void)testStaticWriteInBackgroundWithNoConfiguration {
    XCTestExpectation *expectError = [self expectationWithDescription:@"We should get a BackgroundRealm.Error.noBackgroundConfiguration from calling `Realm.writeInBackground` with no configuration set"];
    
    [RLMRealm writeInBackgroundWithBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) {
        if (error) {
            XCTAssert(error.code == BLBackgroundRealmErrorNoBackgroundConfiguration, "Since we haven't set a background configuration, we should get a BackgroundRealm.Error.noBackgroundConfiguration back from writeInBackground");
        } else {
            XCTFail("We haven't got the right error here");
        }
        
        [expectError fulfill];
    }];
    
    [self waitForExpectations:@[expectError]
                      timeout:3];
}

- (void)testInstanceWriteInBackgroundWithNoConfiguration {
    XCTestExpectation *expectRealm = [self expectationWithDescription:@"We should get a Realm instance back from calling `realm.writeInBackground` with the default configuration"];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm writeInBackgroundWithBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) {
        XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
        XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
        
        [expectRealm fulfill];
    }];
    
    [self waitForExpectations:@[expectRealm]
                      timeout:3];
}

- (void)testStaticWriteInBackgroundWithFileURL {
    XCTestExpectation *expectRealm = [self expectationWithDescription:@"We should get a Realm instance back from calling `Realm.writeInBackground` with a background file URL set"];
    
    NSURL *url = [[[RLMRealmConfiguration defaultConfiguration].fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"testStaticWriteInBackgroundWithFileURL.realm"];
    XCTAssertNotNil(url, "The test realm URL shouldn't be nil");
    NSLog(@"URL: %@", url);
    
    [RLMRealm writeInBackgroundWithFileURL:url
                                  andBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error)
    {
        XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
        XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
        XCTAssertNotNil(realm.configuration.fileURL, "The background realm's configuration shouldn't be empty");
        XCTAssertTrue([realm.configuration.fileURL.absoluteString isEqualToString:url.absoluteString], "The background realm's URL should be equal to %@", url);
        
        [expectRealm fulfill];
    }];
    
    [self waitForExpectations:@[expectRealm]
                      timeout:3];
}

- (void)testInstanceWriteInBackgroundWithFileURL {
    XCTestExpectation *expectRealm = [self expectationWithDescription:@"We should get a Realm instance back from calling `realm.writeInBackground` with a background file URL set"];
    
    NSURL *url = [[[RLMRealmConfiguration defaultConfiguration].fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"testInstanceWriteInBackgroundWithFileURL.realm"];
    XCTAssertNotNil(url, "The test realm URL shouldn't be nil");
    NSLog(@"URL: %@", url);
    
    RLMRealm *realm = [RLMRealm realmWithURL:url];
    [realm writeInBackgroundWithBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) {
        XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
        XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
        XCTAssertNotNil(realm.configuration.fileURL, "The background realm's configuration shouldn't be empty");
        XCTAssertTrue([realm.configuration.fileURL.absoluteString isEqualToString:url.absoluteString], "The background realm's URL should be equal to %@", url);
        
        [expectRealm fulfill];
    }];
    
    [self waitForExpectations:@[expectRealm]
                      timeout:3];
}

- (void)testStaticWriteInBackgroundWithConfiguration {
    XCTestExpectation *expectRealm = [self expectationWithDescription:@"We should get a Realm instance back from calling `Realm.writeInBackground` with a background configuration set"];
    
    NSURL *url = [[[RLMRealmConfiguration defaultConfiguration].fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"testStaticWriteInBackgroundWithConfiguration.realm"];
    XCTAssertNotNil(url, "The test realm URL shouldn't be nil");
    NSLog(@"URL: %@", url);
    
    RLMRealmConfiguration *config = [[RLMRealmConfiguration alloc] init];
    config.fileURL = url;
    [RLMRealmConfiguration setBackgroundConfiguration:config];
    
    [RLMRealm writeInBackgroundWithBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) {
        XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
        XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
        XCTAssertNotNil(realm.configuration.fileURL, "The background realm's configuration shouldn't be empty");
        XCTAssertTrue([realm.configuration.fileURL.absoluteString isEqualToString:[RLMRealmConfiguration backgroundConfiguration].fileURL.absoluteString], "The background realm's URL should be equal to the one set on Realm.Configuration.backgroundConfiguration");
        
        [expectRealm fulfill];
    }];
    
    [self waitForExpectations:@[expectRealm]
                      timeout:3];
}

- (void)testInstanceWriteInBackgroundWithConfiguration {
    XCTestExpectation *expectRealm = [self expectationWithDescription:@"We should get a Realm instance back from calling `realm.writeInBackground` with a background configuration set"];
    
    NSURL *url = [[[RLMRealmConfiguration defaultConfiguration].fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"testInstanceWriteInBackgroundWithConfiguration.realm"];
    XCTAssertNotNil(url, "The test realm URL shouldn't be nil");
    NSLog(@"URL: %@", url);
    
    RLMRealmConfiguration *config = [[RLMRealmConfiguration alloc] init];
    config.fileURL = url;
    [RLMRealmConfiguration setBackgroundConfiguration:config];
    
    RLMRealm *realm = [RLMRealm realmWithURL:url];
    [realm writeInBackgroundWithBlock:^(RLMRealm * _Nullable realm, BLBackgroundRealmError * _Nullable error) {
        XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
        XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
        XCTAssertNotNil(realm.configuration.fileURL, "The background realm's configuration shouldn't be empty");
        XCTAssertTrue([realm.configuration.fileURL.absoluteString isEqualToString:[RLMRealmConfiguration backgroundConfiguration].fileURL.absoluteString], "The background realm's URL should be equal to the one set on Realm.Configuration.backgroundConfiguration");
        
        [expectRealm fulfill];
    }];
    
    [self waitForExpectations:@[expectRealm]
                      timeout:3];
}

- (void)testReceivingChangesFromStaticBackgroundWrite {
    XCTestExpectation *expectWrite = [self expectationWithDescription:@"We should get a notification from a write transaction initated by a call to `Realm.writeInBackground`"];
    
    NSURL *url = [[[RLMRealmConfiguration defaultConfiguration].fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"testReceivingChangesFromStaticBackgroundWrite.realm"];
    XCTAssertNotNil(url, "The test realm URL shouldn't be nil");
    NSLog(@"URL: %@", url);
    
    RLMRealmConfiguration *config = [[RLMRealmConfiguration alloc] init];
    config.fileURL = url;
    [RLMRealmConfiguration setBackgroundConfiguration:config];
    
    NSString *name = @"TEST TEST";
    
    NSError *error;
    RLMRealm *realm = [RLMRealm realmWithConfiguration:[RLMRealmConfiguration backgroundConfiguration] error:&error];
    
    XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
    XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
    
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
    
    _staticBackgroundWriteToken = [[TestObject allObjectsInRealm:realm] addNotificationBlock:^(RLMResults * _Nullable results,
                                                                                               RLMCollectionChange * _Nullable change,
                                                                                               NSError * _Nullable error)
    {
        if (error) {
            XCTFail("%@", error);
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
        
        [expectWrite fulfill];
    }];
    
    [RLMRealm writeInBackgroundWithBlock:^(RLMRealm * _Nullable bgRealm, BLBackgroundRealmError * _Nullable error) {
        TestObject *object = [[TestObject alloc] init];
        object.name = name;
        [bgRealm addObject:object];
    }];
    
    [self waitForExpectations:@[expectWrite]
                      timeout:5];
}

- (void)testReceivingChangesFromInstanceBackgroundWrite {
    XCTestExpectation *expectWrite = [self expectationWithDescription:@"We should get a notification from a write transaction initated by a call to `realm.writeInBackground`"];
    
    NSURL *url = [[[RLMRealmConfiguration defaultConfiguration].fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"testReceivingChangesFromInstanceBackgroundWrite.realm"];
    XCTAssertNotNil(url, "The test realm URL shouldn't be nil");
    NSLog(@"URL: %@", url);
    
    RLMRealmConfiguration *config = [[RLMRealmConfiguration alloc] init];
    config.fileURL = url;
    [RLMRealmConfiguration setBackgroundConfiguration:config];
    
    NSString *name = @"TEST TEST";
    
    NSError *error;
    RLMRealm *realm = [RLMRealm realmWithConfiguration:[RLMRealmConfiguration backgroundConfiguration] error:&error];
    
    XCTAssertNil(error, "We should be able to get a background Realm with no errors, but got one: %@", error);
    XCTAssertNotNil(realm, "We should be able to get a background Realm with no errors");
    
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
    
    _instanceBackgroundWriteToken = [[TestObject allObjectsInRealm:realm] addNotificationBlock:^(RLMResults * _Nullable results,
                                                                                                 RLMCollectionChange * _Nullable change,
                                                                                                 NSError * _Nullable error)
       {
           if (error) {
               XCTFail("%@", error);
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
           
           [expectWrite fulfill];
       }];
    
    [realm writeInBackgroundWithBlock:^(RLMRealm * _Nullable bgRealm, BLBackgroundRealmError * _Nullable error) {
        TestObject *object = [[TestObject alloc] init];
        object.name = name;
        [bgRealm addObject:object];
    }];
    
    [self waitForExpectations:@[expectWrite]
                      timeout:5];
}

@end
