//
//  IDPModelProtocol.h
//  PatiencePad
//
//  Created by Oleksa 'trimm' Korin on 4/14/13.
//  Copyright (c) 2013 IDAP Group. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "IDPModelObserver.h"

typedef enum {
    IDPModelReady,
    IDPModelLoading,
    IDPModelFinished,
    IDPModelFailed,
    IDPModelCancelled,
    IDPModelUnloaded
} IDPModelState;

@protocol IDPModel <NSObject>

@optional

@property (nonatomic, readonly) NSArray         *observers;

@property (nonatomic, readonly) IDPModelState   state;

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;
- (BOOL)isObjectAnObserver:(id)observer;

// should perform preparation steps before loading
// default implementation does nothing
// intended for subclassing
- (void)prepareForLoad;

// should load the model and inform observers of loading state
// default implementation does nothing
// intended for subclassing
- (void)performLoading;

// loads the model using prepareForLoad and performLodaing methods
// if the model is loaded already, notifies observers upon calling the method
// returns YES, if the state != IDPModelLoading
- (BOOL)load;

// method used for subclassing
// currrent implementation sets the corresponding state
// and informs observers of loading success
// only subclasses can directly call the method
- (void)finishLoading;

// method used for subclassing
// currrent implementation sets the corresponding state
// and informs observers of loading failure
// only subclasses can directly call the method
- (void)failLoading;

// method intended for subclassing
// cancels loading
// if the model is loading
// currrent implementation sets the corresponding state
// calls cleanup
// and informs observers of loading failure
// Does nothing otherwise
- (void)cancel;

// default implementation sets the corresponding state
// and informs obsevers of changes
- (void)finishChanging;

// default implementation sets the corresponding state
// and informs obsevers of changes
- (void)finishChangingWithMessaage:(NSDictionary *)message;

// method itnended for subclassing
// should unload the models and inform the delegate of state
// sets loaded to NO and informs observers of unload
- (void)dump;

// method itnended for subclassing
// cleans the data contained in the model
// is called in dealloc, failLoading, dump and cancel
// default implementation does nothing
- (void)cleanup;

@end
