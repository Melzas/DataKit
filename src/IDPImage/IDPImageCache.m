#import "IDPImageCache.h"

#import "NSObject+IDPExtensions.h"

#import "IDPWeakDictionary.h"
#import "IDPImageModel.h"

static IDPImageCache *IDPSharedImageCache = nil;

@interface IDPImageCache ()
@property (nonatomic, retain)	IDPWeakMutableDictionary	*imageCache;

@end

@implementation IDPImageCache

#pragma mark -
#pragma mark Class Methods

+ (id)sharedObject {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		IDPSharedImageCache = [[self alloc] init];
	});
	
	return IDPSharedImageCache;
}


#pragma mark -
#pragma mark Initializatins and Deallocations

- (void)dealloc {
	self.imageCache = nil;
	
	[super dealloc];
}

- (id)init {
	self = [super init];
	if (self) {
		self.imageCache = [IDPWeakMutableDictionary object];
	}
	
	return  self;
}

#pragma mark -
#pragma mark Public

- (void)addImage:(IDPImageModel *)imageModel {
	@synchronized(self) {
		if (nil != imageModel.path && ![imageModel.path isEqualToString:@""]) {
			[self.imageCache setObject:imageModel forKey:imageModel.path];
			imageModel.cache = self;
		}
	}
}

- (void)removeImage:(IDPImageModel *)imageModel {
	@synchronized(self) {
		imageModel.cache = nil;
		
		[self.imageCache removeObjectForKey:imageModel.path];
	}
}

- (UIImage *)cachedImageForPath:(NSString *)imagePath {
	IDPImageModel *imageModel = nil;
	
	@synchronized(self) {
		imageModel = [self.imageCache objectForKey:imagePath];
	}
	
	return imageModel.image;
}

#pragma mark -
#pragma mark Private

+ (id)__sharedObject {
	return IDPSharedImageCache;
}

@end
