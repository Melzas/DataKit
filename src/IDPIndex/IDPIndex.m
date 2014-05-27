//
//  IDPIndex.m
//  IDPKit
//
//  Created by Anton Rayev on 5/23/14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

#import "IDPIndex.h"

@implementation IDPIndex

#pragma mark -
#pragma mark Class Methods

+ (id)indexWithValue:(NSInteger)value {
	return [[[self alloc] initWithValue:value] autorelease];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)initWithValue:(NSInteger)value {
	self = [super init];
	
	if (self) {
		self.value = value;
	}
	
	return self;
}

@end
