

#import <Foundation/Foundation.h>

// Dependant upon GTMNSString+HTML

@interface NSString (HTML)

// Instance Methods
- (NSString *)stringByConvertingHTMLToPlainText;
- (NSString *)stringByDecodingHTMLEntities;
- (NSString *)stringByEncodingHTMLEntities;
- (NSString *)stringWithNewLinesAsBRs;
- (NSString *)stringByRemovingNewLinesAndWhitespace;

// DEPRECIATED - Please use NSString stringByConvertingHTMLToPlainText
- (NSString *)stringByStrippingTags; 

- (NSString *)flattenHTML;

@end
