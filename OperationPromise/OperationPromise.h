//
//  OperationPromise.h
//  OperationPromise
//
//  Created by azu on 2013/11/01.
//  Copyright (c) 2013 azu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationPromise : NSObject
+ (instancetype)promise;

+ (instancetype)promise:(NSOperationQueue *) queue;

@property(nonatomic, strong) NSOperationQueue *queue;

@property(readonly) OperationPromise *(^then)(id operation);
@property(readonly) OperationPromise *(^when)(NSArray *operations);
@property(readonly) void (^start)(void);
@end
