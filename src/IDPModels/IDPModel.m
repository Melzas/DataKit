//
//  ACModel.m
//  Accomplist
//
//  Created by Oleksa 'trimm' Korin on 4/14/13.
//  Copyright (c) 2013 IDAP Group. All rights reserved.
//

#import "IDPModel.h"

@interface IDPModel ()
@property (nonatomic, assign, readwrite)    IDPModelState   state;

@end

@implementation IDPModel

@synthesize state               = _state;

@dynamic target;

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    [self cleanup];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (void)setState:(IDPModelState)state {
	_state = state;
	switch (_state) {
		case IDPModelFinished:
			[self notifyObserversOfSuccessfulLoad];
			break;
			
		case IDPModelFailed:
			[self notifyObserversOfFailedLoad];
			break;
			
		case IDPModelCancelled:
			[self notifyObserversOfCancelledLoad];
			break;
			
		case IDPModelChanged:
			[self notifyObserversOfChanges];
			break;
			
		case IDPModelUnloaded:
			[self notifyObserversOfUnload];
			break;
			
		default:
			break;
	}
}

#pragma mark -
#pragma mark Public

- (void)prepareForLoad {
	
}

- (void)performLoading {
	
}

- (BOOL)load {
    if (IDPModelFinished == self.state) {
        [self notifyObserversOfSuccessfulLoad];
        return NO;
    }
	
	if (IDPModelLoading == self.state) {
		return NO;
	}
	
	[self prepareForLoad];
	
    self.state = IDPModelLoading;
	[self performLoading];
    
    return YES;
}

- (void)finishLoading {
    self.state = IDPModelFinished;
}

- (void)failLoading {
    self.state = IDPModelFailed;
    [self cleanup];
}

- (void)cancel {
    if (IDPModelLoading != self.state) {
        return;
    }
    self.state = IDPModelCancelled;
    [self cleanup];
}

- (void)finishChanging {
	self.state = IDPModelChanged;
}

- (void)dump {
    if (IDPModelUnloaded == self.state) {
        return;
    }
    
    self.state = IDPModelUnloaded;
    [self cleanup];
}

- (void)cleanup {
    
}

#pragma mark -
#pragma mark Private

- (void)notifyObserversOfSuccessfulLoad {
    [self notifyObserversOnMainThreadWithSelector:@selector(modelDidLoad:)];
}

- (void)notifyObserversOfFailedLoad {
    [self notifyObserversOnMainThreadWithSelector:@selector(modelDidFailToLoad:)];
}

- (void)notifyObserversOfCancelledLoad {
    [self notifyObserversOnMainThreadWithSelector:@selector(modelDidCancelLoading:)];
}

- (void)notifyObserversOfChanges {
    [self notifyObserversOnMainThreadWithSelector:@selector(modelDidChange:)];
}

- (void)notifyObserversOfChangesWithMessage:(NSDictionary *)message {
    SEL selector = @selector(modelDidChange:message:);
	
	[self notifyObserversOnMainThreadWithSelector:selector userInfo:message];
}

- (void)notifyObserversOfUnload {
    [self notifyObserversOnMainThreadWithSelector:@selector(modelDidUnload:)];
}

@end
