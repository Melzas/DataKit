//
//  IDPSingletonModel.h
//  MovieScript
//
//  Created by Artem Chabanniy on 10/09/2013.
//  Copyright (c) 2013 IDAP Group. All rights reserved.
//

#import "IDPModel.h"

@interface IDPSingletonModel : IDPModel

+ (id)sharedObject;

@end