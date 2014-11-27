//
//  IDPModels.h
//  BorjomiCalendar
//
//  Created by Anton Rayev on 11/26/14.
//  Copyright (c) 2014 IDAP. All rights reserved.
//

#import "IDPModel.h"

#define IDPModelsInterfaceSynthesize(prefix, name) \
- (void)add##name:(prefix##name *)model; \
- (void)remove##name:(prefix##name *)model; \
\
- (void)add##name##s:(NSArray *)models; \
- (void)remove##name##s:(NSArray *)models; \

#define IDPModelsImplementationSynthesize(prefix, name) \
- (void)add##name:(prefix##name *)model { \
	[self addModel:model]; \
} \
\
- (void)remove##name:(prefix##name *)model { \
	[self removeModel:model]; \
} \
\
- (void)add##name##s:(NSArray *)models { \
	[self addModels:models]; \
} \
\
- (void)remove##name##s:(NSArray *)models { \
	[self removeModels:models]; \
}


@interface IDPModels : IDPModel
@property (nonatomic, readonly)		NSArray		*models;

- (void)addModel:(id)model;
- (void)removeModel:(id)model;

- (void)addModels:(NSArray *)models;
- (void)removeModels:(NSArray *)models;

- (void)clear;

@end
