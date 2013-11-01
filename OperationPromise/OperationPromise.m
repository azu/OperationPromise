//
//  OperationPromise.m
//  OperationPromise
//
//  Created by azu on 2013/11/01.
//  Copyright (c) 2013 azu. All rights reserved.
//

#import "OperationPromise.h"

@interface OperationPromise ()
@property(nonatomic, strong) NSMutableArray *operations;
@end

@implementation OperationPromise

- (NSMutableArray *)operations {
    if (_operations == nil) {
        _operations = [NSMutableArray array];
    }
    return _operations;
}

+ (instancetype)promise {
    return [[self alloc] init];
}

+ (instancetype)promise:(NSOperationQueue *) queue {
    OperationPromise *that = [self promise];
    that.queue = queue;
    return that;
}

// Parent <- op
- (NSArray *)addDependencyOperation:(NSOperation *) operation {
    for (NSOperation *parentOperation in self.operations) {
        [operation addDependency:parentOperation];
    }
    [self.operations addObject:operation];
    return self.operations;
}

// Parent <- [op,op]
- (NSArray *)addDependencyOperations:(NSArray *) operations {
    for (NSOperation *parentOperation in self.operations) {
        [operations enumerateObjectsUsingBlock:^(NSOperation *newOp, NSUInteger idx, BOOL *stop) {
            [newOp addDependency:parentOperation];
        }];
    }
    [self.operations addObjectsFromArray:operations];
    return self.operations;
}


- (OperationPromise * (^)(NSOperation *))then {
    return ^OperationPromise *(NSOperation *operation) {
        [self addDependencyOperation:operation];
        return self;
    };
}

- (OperationPromise * (^)(NSArray *))when {
    return ^OperationPromise *(NSArray *operations) {
        [self addDependencyOperations:operations];
        return self;
    };
}

- (void (^)())start {
    return ^{
        NSAssert(self.queue != nil, @"should set queue: + (instancetype)promise:(NSOperationQueue *) queue;");
        [self.queue addOperations:self.operations waitUntilFinished:NO];
    };
}
@end

