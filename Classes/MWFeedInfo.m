

#import "MWFeedInfo.h"

#define EXCERPT(str, len) (([str length] > len) ? [[str substringToIndex:len-1] stringByAppendingString:@"…"] : str)

@implementation MWFeedInfo

@synthesize title, link, summary;
//@synthesize  img_url;

#pragma mark NSObject

- (NSString *)description {
	NSMutableString *string = [[NSMutableString alloc] initWithString:@"MWFeedInfo: "];
	if (title)   [string appendFormat:@"“%@”", EXCERPT(title, 50)];
	//if (link)    [string appendFormat:@" (%@)", link];
	//if (summary) [string appendFormat:@", %@", MWExcerpt(summary, 50)];
	
	return [string autorelease];
}

- (void)dealloc {
	[title release];
	[link release];
	[summary release];
	//[img_url release];
	[super dealloc];
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		title = [[decoder decodeObjectForKey:@"title"] retain];
		link = [[decoder decodeObjectForKey:@"link"] retain];
		summary = [[decoder decodeObjectForKey:@"summary"] retain];
		//img_url = [[decoder decodeObjectForKey:@"img_url"] retain];

		//NSLog(@"summary %@",summary);
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	if (title) [encoder encodeObject:title forKey:@"title"];
	if (link) [encoder encodeObject:link forKey:@"link"];
	if (summary) [encoder encodeObject:summary forKey:@"summary"];
	//if (img_url) [encoder encodeObject:img_url forKey:@"img_url"];

}

@end
