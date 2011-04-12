

#import <Foundation/Foundation.h>

@interface MWFeedInfo : NSObject <NSCoding> {
	
	NSString *title; // Feed title
	NSString *link; // Feed link
	NSString *summary; // Feed summary / description
	//NSString *img_url;
	
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *summary;
//@property (nonatomic, copy) NSString *img_url;


@end
