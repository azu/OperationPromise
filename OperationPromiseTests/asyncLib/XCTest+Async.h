//
//  SenTest+Async.h
//  Created by Taras Kalapun on 1/29/13.
//

#import <SenTestingKit/SenTestingKit.h>
#import <XCTest/XCTest.h>

@interface XCTestCase (Async)

- (void)runTestWithBlock:(void (^)(void))block;
- (void)runTestWithBlock:(void (^)(void))block timeOut:(NSTimeInterval)timeOut;
- (void)blockTestCompleted;

- (void)asyncRecordFailureWithDescription:(NSString *) description inFile:(NSString *) filename atLine:(NSUInteger) lineNumber expected:(BOOL) expected;
@end
