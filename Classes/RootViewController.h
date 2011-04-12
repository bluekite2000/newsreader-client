#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "HJObjManager.h"
#import "DetailTableViewController.h"

@interface RootViewController : UITableViewController <MWFeedParserDelegate> {
	
	// Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
UIActivityIndicatorView *cLoadingView;
	HJObjManager* objMan;
	
	DetailTableViewController *detailTableViewController;


	
}

@property (nonatomic, retain) NSArray *itemsToDisplay;
@property (nonatomic, retain) UIActivityIndicatorView *cLoadingView;
@property (nonatomic, retain) DetailTableViewController *detailTableViewController;

- (void)initSpinner;

- (void)spinBegin;

- (void)spinEnd;

@end
