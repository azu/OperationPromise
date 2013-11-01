# OperationPromise

NSOperation(NSOperationQueue) dependency manager library.

## Installation

```ruby
pod 'OperationPromise',
```

## Usage

``OperationPromise`` has ``then`` and ``when`` method.

It possible to chain methods.

Example of ``then``

```objc
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
[queue waitUntilAllOperationsAreFinished];// sync wait....
NSArray *expect = @[@1, @2, @3];
XCTAssertEqualObjects(race, expect);
// Call @1 -> @2 -> @3
```

Example of ``when``

```objc
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
[queue waitUntilAllOperationsAreFinished];// wait perform all operation...

NSArray *expect = @[@1, @2, @3, @4];
XCTAssertEqualObjects(race[0], expect[0]);
XCTAssertEqualObjects(race[3], expect[3]);
// call @1 -> (@2 or @3) -> @4
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

MIT