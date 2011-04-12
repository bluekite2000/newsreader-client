
#import "VerticalSwipeScrollView.h"
#import <UIKit/UIKit.h>
#import "MWFeedItem.h"
@interface  DetailTableViewController : UIViewController <VerticalSwipeScrollViewDelegate, UIScrollViewDelegate>
{
	MWFeedItem *item;
//	NSString *headerString,*dateString, *summaryString;

	IBOutlet UIView* headerView;
	IBOutlet UIImageView* headerImageView;
	IBOutlet UILabel* headerLabel;
	
	IBOutlet UIView* footerView;
	IBOutlet UIImageView* footerImageView;
	IBOutlet UILabel* footerLabel;
	
	VerticalSwipeScrollView* verticalSwipeScrollView;
	NSArray* appData;
	NSUInteger startIndex;
	UIWebView* previousPage;
	UIWebView* nextPage;
	UIWebView* currentPage;

}
@property (nonatomic, retain) MWFeedItem *item;
//@property (nonatomic, retain) NSString *headerString,*dateString, *summaryString;

@property (nonatomic, retain) IBOutlet UIView* headerView;
@property (nonatomic, retain) IBOutlet UIImageView* headerImageView;
@property (nonatomic, retain) IBOutlet UILabel* headerLabel;
@property (nonatomic, retain) IBOutlet UIView* footerView;
@property (nonatomic, retain) IBOutlet UIImageView* footerImageView;
@property (nonatomic, retain) IBOutlet UILabel* footerLabel;
@property (nonatomic, retain) VerticalSwipeScrollView* verticalSwipeScrollView;
@property (nonatomic, retain) NSArray* appData;
@property (nonatomic) NSUInteger startIndex;
@property (nonatomic, retain) UIWebView* previousPage;
@property (nonatomic, retain) UIWebView* nextPage;
@property (nonatomic, retain) UIWebView* currentPage;


@end


