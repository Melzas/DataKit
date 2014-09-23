//
//  IDPImageCache.h
//  IDPKit
//
//  Created by Anton Rayev on 5/6/14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

#import "IDPSingletonModel.h"

@class IDPImageModel;

@interface IDPImageCache : IDPSingletonModel

- (void)addImage:(IDPImageModel *)imageModel;
- (void)removeImage:(IDPImageModel *)imageModel;

// returns nil if image not in the cache
- (IDPImageModel *)cachedImageForPath:(NSString *)imagePath;

@end
