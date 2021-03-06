#import "IDPImageModel.h"

#import "NSFileManager+IDPExtensions.h"
#import "IDPPropertyMacros.h"

#import "IDPImageCache.h"
#import "IDPURLConnection.h"

static NSString * const kIDPCacheFolder	= @"Caches";

@interface IDPImageModel () <IDPModelObserver>
@property (nonatomic, copy)		NSString			*path;
@property (nonatomic, retain)	IDPURLConnection	*connection;

@property (atomic, retain)		NSData				*imageData;
@property (nonatomic, readonly)	NSString			*savePath;

- (void)loadFromFile;
- (void)loadFromURL;

@end

@implementation IDPImageModel

@dynamic image;
@dynamic savePath;

#pragma mark -
#pragma mark Class Methods

+ (id)modelWithPath:(NSString *)path {
	return [[[self alloc] initWithPath:path] autorelease];
}

+ (id)modelWithPath:(NSString *)path data:(NSData *)data {
	return [[[self alloc] initWithPath:path data:data] autorelease];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
	[self cleanup];
	self.path = nil;
	
	[super dealloc];
}

- (id)initWithPath:(NSString *)path {
	self = [super init];
	
	if (self) {
		self.imageSource = kIDPImageSourceFileURL;
		
		IDPImageCache *cache = [IDPImageCache sharedObject];
		UIImage *image = [cache cachedImageForPath:path];
		
		if (nil != image) {
			self.imageData = UIImagePNGRepresentation(image);
			[self finishLoading];
		}
		
		self.path = path;
		[cache addImage:self];
	}
	
	return self;
}

- (id)initWithPath:(NSString *)path data:(NSData *)data {
	self = [super init];
	
	if (self) {
		self.imageSource = kIDPImageSourceFile;
		
		IDPImageCache *cache = [IDPImageCache sharedObject];
		UIImage *image = [cache cachedImageForPath:path];
		
		if (nil != image) {
			self.imageData = UIImagePNGRepresentation(image);
			[self finishLoading];
		}
		
		if (nil != data) {
			self.imageData = data;
			[self finishLoading];
		} else {
			[self failLoading];
		}
		
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
	NSString *cachePath = [libraryPath stringByAppendingPathComponent:kIDPCacheFolder];
	NSString *imageName = [self.path lastPathComponent];
	
	return [cachePath stringByAppendingPathComponent:imageName];
}

#pragma mark -
#pragma mark Public

- (void)loadFromSource:(IDPImageSource)source {
	self.imageSource = source;
	
	[self load];
}

- (void)save {
	[self.imageData writeToFile:self.savePath atomically:YES];
}

- (void)cancel {
	self.connection = nil;
	
	[super cancel];
}

- (void)dump {
	[self save];
	
	[super dump];
}

- (void)cleanup {
	[self.cache removeImage:self];
	self.cache = nil;
	
	self.connection = nil;
	self.imageData = nil;
}

#pragma mark -
#pragma mark Private

- (void)loadFromFile {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		self.imageData = [NSData dataWithContentsOfFile:self.savePath];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self finishLoading];
		});
	});
}

- (void)loadFromURL {
	NSURL *imageUrl = [NSURL URLWithString:self.path];
	self.connection = [IDPURLConnection connectionToURL:imageUrl];
	[self.connection load];
}

- (void)performLoading {
	IDPImageSource imageSource = self.imageSource;
	
	switch (imageSource) {
		case kIDPImageSourceFile:
		case kIDPImageSourceFileURL:
		case kIDPImageSourceFileURLUpdate:
			[self loadFromFile];
			break;
			
		case kIDPImageSourceURL:
		case kIDPImageSourceURLFile:
			[self loadFromURL];
			break;
	}
}

- (void)finishLoading {
	IDPImageSource imageSource = self.imageSource;
	
	switch (imageSource) {
		case kIDPImageSourceFile:
		case kIDPImageSourceURL:
			(nil == self.imageData) ? [self failLoading] : [super finishLoading];
			break;
			
		case kIDPImageSourceFileURL:
			(nil == self.imageData) ? [self loadFromURL] : [super finishLoading];
			break;
			
		case kIDPImageSourceURLFile:
			(nil == self.imageData) ? [self loadFromFile] : [super finishLoading];
			break;
			
		case kIDPImageSourceFileURLUpdate:
			self.imageSource = kIDPImageSourceURL;
			[self loadFromURL];
			
			if (nil != self.imageData) {
				[super finishLoading];
			}
			break;
	}
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
	[self failLoading];
	
	self.connection = nil;
}

@end
