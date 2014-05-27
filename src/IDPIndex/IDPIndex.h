//
//  IDPIndex.h
//  IDPKit
//
//  Created by Anton Rayev on 5/23/14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

@interface IDPIndex : NSObject
@property (nonatomic, assign)	NSInteger	value;

+ (id)indexWithValue:(NSInteger)value;

- (id)initWithValue:(NSInteger)value;

@end
