#import "IDPImageCache.h"

#import "NSObject+IDPExtensions.h"

#import "IDPImageModel.h"

static IDPImageCache *IDPSharedImageCache = nil;

@interface IDPImageCache ()
@property (nonatomic, retain)	NSMutableDictionary	*imageCache;

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
	for (IDPImageModel *imageModel in self.imageCache) {
		imageModel.cache = nil;
	}
	
	self.imageCache = nil;
	
	[super dealloc];
}

- (id)init {
	self = [super init];
	if (self) {
		self.imageCache = [NSMutableDictionary object];
	}
	
	return  self;
}

#pragma mark -
#pragma mark Public

- (void)addImage:(IDPImageModel *)imageModel {
	@synchronized(self) {
		[self.imageCache setObject:imageModel forKey:imageModel.path];
		
		imageModel.cache = self;
	}
}

- (void)removeImage:(IDPImageModel *)imageModel {
	@synchronized(self) {
		imageModel.cache = nil;
		
		[self.imageCache removeObjectForKey:imageModel.path];
	}
}

- (IDPImageModel *)cachedImageForPath:(NSString *)imagePath {
	IDPImageModel *imageModel = nil;
	@synchronized(self) {
		imageModel = [self.imageCache objectForKey:imagePath];
	}
	
	return imageModel;
}

#pragma mark -
#pragma mark Private

+ (id)__sharedObject {
	return IDPSharedImageCache;
}

@end
