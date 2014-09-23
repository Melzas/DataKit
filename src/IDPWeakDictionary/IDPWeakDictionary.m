//
//  IDPWeakMutableDictionary.m
//  Tixxit
//
//  Created by Anton on 08.06.14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

#import "IDPWeakDictionary.h"

#import "NSArray+IDPExtensions.h"

#import "IDPWeakArray.h"

@implementation IDPWeakMutableDictionary

#pragma mark -
#pragma mark NSDictionary

- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys {
    self = [super init];
    if (self) {
		NSMutableArray *weakObjects = [IDPMutableWeakArray weakArray];
		[weakObjects addObjectsFromArray:objects];
		
        self.dictionary = [NSMutableDictionary dictionaryWithObjects:weakObjects
                                                             forKeys:keys];
    }
    
    return self;
}

- (id)objectForKey:(id)aKey {
    IDPWeakReference *weakReference = [super objectForKey:aKey];
	
	return weakReference.object;
}

#pragma mark -
#pragma mark NSMutableDictionary

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey {
	IDPWeakReference *weakReference = [IDPWeakReference referenceWithObject:anObject];
	
    [super setObject:weakReference forKey:aKey];
}

@end
