//
//  IDPIndex.h
//  IDPKit
//
//  Created by Anton Rayev on 5/23/14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

@interface IDPIndex : NSObject
@property (nonatomic, assign)	NSInteger	value;
@property (nonatomic, assign)	NSInteger	lowerLimit;
@property (nonatomic, assign)	NSInteger	upperLimit;

+ (id)indexWithValue:(NSInteger)value
		  lowerLimit:(NSInteger)lowerLimit
		  upperLimit:(NSInteger)upperLimit;
+ (id)indexWithValue:(NSInteger)value;

- (id)initWithValue:(NSInteger)value
		 lowerLimit:(NSInteger)lowerLimit
		 upperLimit:(NSInteger)upperLimit;
- (id)initWithValue:(NSInteger)value;

- (NSInteger)previous;
- (NSInteger)next;

@end
