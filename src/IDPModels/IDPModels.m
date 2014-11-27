//
//  IDPModels.m
//  BorjomiCalendar
//
//  Created by Anton Rayev on 11/26/14.
//  Copyright (c) 2014 IDAP. All rights reserved.
//

#import "IDPModels.h"

@interface IDPModels ()
@property (nonatomic, strong)	NSMutableArray		*mutableModels;

@end

@implementation IDPModels

@dynamic models;

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
	self = [super init];
	
	if (self) {
		self.mutableModels = [NSMutableArray array];
	}
	
	return self;
}

#pragma mark -
#pragma mark Accessors

- (NSArray *)models {
	return [self.mutableModels copy];
}

#pragma mark -
#pragma mark Public

- (void)addModel:(id)model {
	@synchronized (self) {
		[self.mutableModels addObject:model];
	}
}

- (void)removeModel:(id)model {
	@synchronized (self) {
		[self.mutableModels removeObject:model];
	}
}

- (void)addModels:(NSArray *)models {
	@synchronized (self) {
		[self.mutableModels addObjectsFromArray:models];
	}
}

- (void)removeModels:(NSArray *)models {
	@synchronized (self) {
		[self.mutableModels removeObjectsInArray:models];
	}
}

- (void)clear {
	[self.mutableModels removeAllObjects];
}

@end
