//
//  IDPIndices.m
//  IDPKit
//
//  Created by Anton on 27.05.14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

#import "IDPIndices.h"

#import "IDPIndex.h"

@implementation IDPIndices

#pragma mark -
#pragma mark Class Methods

+ (id)indicesWithLowerLimit:(IDPIndex *)lowerLimit upperLimit:(IDPIndex *)upperLimit {
	return [[self alloc] initWithLowerLimit:lowerLimit upperLimit:upperLimit];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
	self.lowerLimit = nil;
	self.upperLimit = nil;
	
	[super dealloc];
}

- (id)initWithLowerLimit:(IDPIndex *)lowerLimit upperLimit:(IDPIndex *)upperLimit {
	self = [super init];
	
	if (self) {
		self.lowerLimit = lowerLimit;
		self.upperLimit = upperLimit;
	}
	
	return self;
}

- (id)init {
	return [self initWithLowerLimit:[IDPIndex indexWithValue:0]
						 upperLimit:[IDPIndex indexWithValue:0]];
}

#pragma mark -
#pragma mark Public

- (IDPIndex *)indexBeforeIndex:(IDPIndex *)index {
	NSInteger indexValue = index.value;
	
	IDPIndex *lowerLimit = self.lowerLimit;
	IDPIndex *upperLimit = self.upperLimit;
	
	if (indexValue <= lowerLimit.value || indexValue > upperLimit.value) {
		return upperLimit;
	}
	
	return [self previousIndexForIndex:index];
}

- (IDPIndex *)indexAfterIndex:(IDPIndex *)index {
	NSInteger indexValue = index.value;
	
	IDPIndex *lowerLimit = self.lowerLimit;
	IDPIndex *upperLimit = self.upperLimit;
	
	if (indexValue < lowerLimit.value || indexValue >= upperLimit.value) {
		return lowerLimit;
	}
		
	return [self nextIndexForIndex:index];
}

#pragma mark -
#pragma mark Private

- (IDPIndex *)previousIndexForIndex:(IDPIndex *)index {
	return [IDPIndex indexWithValue:index.value - 1];
}

- (IDPIndex *)nextIndexForIndex:(IDPIndex *)index {
	return [IDPIndex indexWithValue:index.value + 1];
}

@end
