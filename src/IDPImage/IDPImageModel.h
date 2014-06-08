//
//  IDPImageModel.h
//  IDPKit
//
//  Created by Anton Rayev on 5/6/14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

@class IDPImageCache;

@interface IDPImageModel : IDPModel
@property (nonatomic, readonly)	NSString		*path;
@property (nonatomic, readonly)	UIImage			*image;
@property (nonatomic, retain)	IDPImageCache	*cache;

+ (id)modelWithPath:(NSString *)path;
- (id)initWithPath:(NSString *)path;

- (void)save;
- (void)loadFromFile;

@end
