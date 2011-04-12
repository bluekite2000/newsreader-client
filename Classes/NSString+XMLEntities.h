

#import <Foundation/Foundation.h>

// Import new HTML category
#import "NSString+HTML.h"

// THIS CLASS IS DEPRECIATED 03/08/2010
// REPLACED BY NSString+HTML

@interface NSString (XMLEntities)

// Old Instance Methods
- (NSString *)stringByDecodingXMLEntities;
- (NSString *)stringByEncodingXMLEntities;

@end
