//
//  OperationPromiseTests.m
//  OperationPromiseTests
//
//  Created by azu on 2013/11/01.
//  Copyright (c) 2013 azu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OperationPromise.h"

@interface OperationPromiseTests : XCTestCase

@end

@implementation OperationPromiseTests {
    OperationPromise *promise;
}

- (void)setUp {
    [super setUp];
    promise = [OperationPromise promise];
}

- (void)tearDown {
    promise = nil;
    [super tearDown];
}

- (void)testThen {
    NSMutableArray *race = [NSMutableArray array];
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        [race addObject:@1];
    }];
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        [race addObject:@2];
    }];
    NSBlockOperation *blockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
        [race addObject:@3];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [OperationPromise promise:queue]
        .then(blockOperation1)
        .then(blockOperation2)
        .then(blockOperation3)
        .start();
    [queue waitUntilAllOperationsAreFinished];

    NSArray *expect = @[@1, @2, @3];
    XCTAssertEqualObjects(race, expect);
}

- (void)testWhen {
    NSMutableArray *race = [NSMutableArray array];
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        [race addObject:@1];
    }];
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        [race addObject:@2];
    }];
    NSBlockOperation *blockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
        [race addObject:@3];
    }];
    NSBlockOperation *blockOperation4 = [NSBlockOperation blockOperationWithBlock:^{
        [race addObject:@4];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [OperationPromise promise:queue]
        .then(blockOperation1)
        .when(@[blockOperation2, blockOperation3])
        .then(blockOperation4)
        .start();
    [queue waitUntilAllOperationsAreFinished];

    NSArray *expect = @[@1, @2, @3, @4];
    XCTAssertEqualObjects(race[0], expect[0]);
    XCTAssertEqualObjects(race[3], expect[3]);
}

- (void)testStart_Exception {
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
    }];
    XCTAssertThrows([OperationPromise promise]
        .then(blockOperation1)
        .start());
}

- (void)testAppendingQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    __block BOOL isCalled = NO;
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        isCalled = YES;
    }];
    OperationPromise *operationPromise = [OperationPromise promise]
        .then(blockOperation1);
    operationPromise.queue = queue;
    operationPromise.start();
    [queue waitUntilAllOperationsAreFinished];
    XCTAssertTrue(isCalled);

}
@end
