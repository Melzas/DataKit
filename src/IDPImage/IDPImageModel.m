#import "IDPImageModel.h"

#import "IDPImageCache.h"

static NSString * const kFFCacheFolder	= @"Caches";

@interface IDPImageModel () <IDPModelObserver>
@property (nonatomic, copy)		NSString	*path;
@property (nonatomic, retain)	UIImage		*image;

@property (nonatomic, retain)	IDPURLConnection	*connection;
@property (nonatomic, retain)	NSData				*imageData;
@property (nonatomic, readonly)	NSString			*savePath;

@end

@implementation IDPImageModel

@dynamic image;
@dynamic savePath;

#pragma mark -
#pragma mark Class Methods

+ (id)modelWithPath:(NSString *)path {
	return [[[self alloc] initWithPath:path] autorelease];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)cleanup {
	[self.cache removeImage:self];
	self.cache = nil;
	self.path = nil;
	
	self.connection = nil;
	self.imageData = nil;
}

- (id)initWithPath:(NSString *)path {
	IDPImageCache *cache = [IDPImageCache sharedObject];
	IDPImageModel *imageModel = [cache cachedImageForPath:path];
	
	if (nil != imageModel) {
		[self autorelease];
		return [imageModel retain];
	}
	
    self = [super init];
    if (self) {
		self.path = path;
		
		[cache addImage:self];
    }
	
    return self;
}

#pragma mark -
#pragma mark - Accessors

- (void)setConnection:(IDPURLConnection *)connection {
	IDPNonatomicRetainPropertySynthesizeWithObserver(_connection, connection);
}

- (UIImage *)image {
	return [UIImage imageWithData:self.imageData];
}

- (NSString *)savePath {
	NSString *libraryPath = [NSFileManager libraryDirectoryPath];
	NSString *cachePath = [libraryPath stringByAppendingPathComponent:kFFCacheFolder];
	NSString *imageName = [self.path lastPathComponent];
	
	return [cachePath stringByAppendingPathComponent:imageName];
}

#pragma mark -
#pragma mark Public

- (void)save {
	[self.imageData writeToFile:self.savePath atomically:YES];
}

- (void)loadFromFile {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if (nil == self.imageData) {
			self.imageData = [NSData dataWithContentsOfFile:self.savePath];
		}
		
		nil == self.imageData ? [self failLoading] : [self finishLoading];
	});
}

- (void)cancel {
	self.connection = nil;
	
	[super cancel];
}

#pragma mark -
#pragma mark Private

- (void)performLoading {
	if (nil != self.imageData) {
		[self finishLoading];
		return;
	}
	
	NSURL *imageUrl = [NSURL URLWithString:self.path];
	self.connection = [IDPURLConnection connectionToURL:imageUrl];
	[self.connection load];
}

#pragma mark -
#pragma mark IDPModelObserver

- (void)modelDidLoad:(id)model {
	IDPURLConnection *connection = self.connection;
	self.imageData = connection.data;
	
	[self finishLoading];
	self.connection = nil;
}

- (void)modelDidFailToLoad:(id)model {
	[self loadFromFile];
	
	self.connection = nil;
}

@end
