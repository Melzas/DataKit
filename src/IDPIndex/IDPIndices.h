//
//  IDPIndices.h
//  IDPKit
//
//  Created by Anton on 27.05.14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDPIndex;

@interface IDPIndices : NSObject
@property (nonatomic, retain)	IDPIndex	*lowerLimit;
@property (nonatomic, retain)	IDPIndex	*upperLimit;

+ (id)indicesWithLowerLimit:(IDPIndex *)lowerLimit upperLimit:(IDPIndex *)upperLimit;

- (id)initWithLowerLimit:(IDPIndex *)lowerLimit upperLimit:(IDPIndex *)upperLimit;

- (IDPIndex *)indexBeforeIndex:(IDPIndex *)index;
- (IDPIndex *)indexAfterIndex:(IDPIndex *)index;

// should return index before given |index|
// intended for subclassing
// default implementation returns the index with value of the |index| decremented by 1
- (IDPIndex *)previousIndexForIndex:(IDPIndex *)index;

// should return index after given |index|
// intended for subclassing
// default implementation returns the index with value of the |index| incremented by 1
- (IDPIndex *)nextIndexForIndex:(IDPIndex *)index;

@end
