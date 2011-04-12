

#import "NSString+XMLEntities.h"

// THIS CLASS IS DEPRECIATED 03/08/2010
// REPLACED BY NSString+HTML

@implementation NSString (XMLEntities)

- (NSString *)stringByDecodingXMLEntities {
	return [self stringByDecodingHTMLEntities];
}

- (NSString *)stringByEncodingXMLEntities {
	return [self stringByEncodingHTMLEntities];
}

@end
