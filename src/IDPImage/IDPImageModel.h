//
//  IDPImageModel.h
//  IDPKit
//
//  Created by Anton Rayev on 5/6/14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IDPImageModel.h"

#import "IDPModel.h"

@class IDPImageCache;

typedef enum {
	kIDPImageSourceFile,
	kIDPImageSourceURL,
	kIDPImageSourceFileURL,
	kIDPImageSourceURLFile,
	kIDPImageSourceFileURLUpdate
} IDPImageSource;

@interface IDPImageModel : IDPModel
@property (nonatomic, readonly)	NSString		*path;
@property (nonatomic, readonly)	UIImage			*image;
@property (nonatomic, assign)	IDPImageSource	imageSource;
@property (nonatomic, retain)	IDPImageCache	*cache;

+ (id)modelWithPath:(NSString *)path;
+ (id)modelWithPath:(NSString *)path data:(NSData *)data;

- (id)initWithPath:(NSString *)path;
- (id)initWithPath:(NSString *)path data:(NSData *)data;

- (void)loadFromSource:(IDPImageSource)source;
- (void)save;

@end
