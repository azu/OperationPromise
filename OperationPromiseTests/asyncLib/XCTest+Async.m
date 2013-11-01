//
//  Original
//  SenTest+Async.m
//  Created by Taras Kalapun on 1/29/13.
//

#import <objc/runtime.h>
#import <XCTest/XCTest.h>

static const NSTimeInterval kDefaultTimeOut = 2.0;
static const char *kSenTestAsyncSemaphore = "kSenTestAsyncSemaphore";


@implementation XCTestCase (Async)


- (void)setAsyncSemaphore:(dispatch_semaphore_t) semaphore {
    objc_setAssociatedObject(self, kSenTestAsyncSemaphore, semaphore, OBJC_ASSOCIATION_ASSIGN);
}

- (dispatch_semaphore_t)asyncSemaphore {
    return (objc_getAssociatedObject(self, kSenTestAsyncSemaphore));
}

- (void)blockTestCompleted {
    dispatch_semaphore_signal([self asyncSemaphore]);
}

- (void)runTestWithBlock:(void (^)(void)) block {
    [self runTestWithBlock:block timeOut:kDefaultTimeOut];
}

- (void)runTestWithBlock:(void (^)(void)) block timeOut:(NSTimeInterval) timeoutInterval {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self setAsyncSemaphore:semaphore];

    block();

    NSDate *timeoutDate = nil;
    if (timeoutInterval == 0) {
        timeoutDate = [NSDate distantFuture];
    } else {
        timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutInterval];
    }

    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];

        if ([(NSDate *)[NSDate date] compare:timeoutDate] == NSOrderedDescending) {
            // Will signal semaphore
            NSException *exception = [NSException exceptionWithName:@"XCTestAsync timeout" reason:@"Operation timed out" userInfo:nil];
            [(XCTestCase *)self asyncRecordFailureWithDescription:[exception description] inFile:@"" atLine:0 expected:NO];
        }
    }
}


+ (void)load; {

    Method newMethod = class_getInstanceMethod([self class],
        @selector(recordFailureWithDescription:inFile:atLine:expected:));
    if (newMethod) {
        class_replaceMethod(objc_getClass(class_getName(self)),
            @selector(recordFailureWithDescription:inFile:atLine:expected:),
            method_getImplementation(newMethod),
            method_getTypeEncoding(newMethod));
    }
}

- (void)asyncRecordFailureWithDescription:(NSString *) description inFile:(NSString *) filename atLine:(NSUInteger) lineNumber expected:(BOOL) expected {
    if ([self asyncSemaphore] != nil) {
        [self blockTestCompleted];
    }
    id dynamicSelf = self;
    if ([dynamicSelf respondsToSelector:@selector(recordFailureWithDescription:inFile:atLine:expected:)]) {
        [dynamicSelf recordFailureWithDescription:description inFile:filename atLine:lineNumber expected:expected];
    }
}


@end

