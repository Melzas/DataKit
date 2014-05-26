//
//  IDPIndex.m
//  IDPKit
//
//  Created by Anton Rayev on 5/23/14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

#import "IDPIndex.h"

@interface IDPIndex ()
@property (nonatomic, assign)	NSInteger	internalValue;

- (NSInteger)valueInLimits:(NSInteger)value;

@end

@implementation IDPIndex

@dynamic value;

#pragma mark -
#pragma mark Class Methods

+ (id)indexWithValue:(NSInteger)value
		  lowerLimit:(NSInteger)lowerLimit
		  upperLimit:(NSInteger)upperLimit
{
	return [[[self alloc] initWithValue:value
							 lowerLimit:lowerLimit
							 upperLimit:upperLimit] autorelease];
}

+ (id)indexWithValue:(NSInteger)value {
	return [[[self alloc] initWithValue:value] autorelease];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)initWithValue:(NSInteger)value
		 lowerLimit:(NSInteger)lowerLimit
		 upperLimit:(NSInteger)upperLimit
{
	self = [super init];
	
	if (self) {
		self.value = value;
		self.lowerLimit = lowerLimit;
		self.upperLimit = upperLimit;
	}
	
	return self;
}

- (id)initWithValue:(NSInteger)value {
	return [self initWithValue:value lowerLimit:value upperLimit:value];
}

#pragma mark -
#pragma mark Accessors

- (NSInteger)value {
	return self.internalValue;
}

- (void)setValue:(NSInteger)value {
	self.internalValue = [self valueInLimits:value];
}

- (void)setLowerLimit:(NSInteger)lowerLimit {
	IDPNonatomicAssignPropertySynthesize(_lowerLimit, lowerLimit);
	
	self.internalValue = [self valueInLimits:self.internalValue];
}

- (void)setUpperLimit:(NSInteger)upperLimit {
	IDPNonatomicAssignPropertySynthesize(_upperLimit, upperLimit);
	
	self.internalValue = [self valueInLimits:self.internalValue];
}

#pragma mark -
#pragma mark Public

- (NSInteger)previous {
	NSInteger value = --self.internalValue;
	
	if (value < self.lowerLimit) {
		value = self.upperLimit;
	}
	
	return self.internalValue = value;
}

- (NSInteger)next {
	NSInteger value = ++self.internalValue;
	
	if (value > self.upperLimit) {
		value = self.lowerLimit;
	}
	
	return self.internalValue = value;
}

#pragma mark -
#pragma mark Private

- (NSInteger)valueInLimits:(NSInteger)value {
	NSInteger lowerLimit = self.lowerLimit;
	NSInteger upperLimit = self.upperLimit;
	
	if (value < lowerLimit) {
		value = lowerLimit;
	}
	
	if (value > upperLimit) {
		value = upperLimit;
	}
	
	return value;
}

@end
