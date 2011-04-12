#import "RootViewController.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "DetailTableViewController.h"
#import "AboutViewController.h"
#import "Reachability.h"
#import "SHK.h"
#import "HJObjManager.h"
#import "HJManagedImageV.h"
#import "FlurryAPI.h"


@implementation RootViewController
@synthesize itemsToDisplay;
@synthesize cLoadingView;
@synthesize detailTableViewController;

#define NAME_TAG 1
#define TIME_TAG 2
#define IMAGE_TAG 3
#define TEXT_TAG 4
#define ROW_HEIGHT 70

#define IMAGE_SIDE 48
#define BORDER_WIDTH 4
#define TEXT_OFFSET_X 2
#define LABEL_HEIGHT 40
#define LABEL_WIDTH 300
#define TEXT_WIDTH (320 - TEXT_OFFSET_X - BORDER_WIDTH)
#define TEXT_OFFSET_Y 35
#define TEXT_HEIGHT (ROW_HEIGHT - TEXT_OFFSET_Y - BORDER_WIDTH)


#define IMAGE_X 240
#define IMAGE_Y -10
#define IMAGE_HEIGHT 75
#define IMAGE_WIDTH 75
#pragma mark -
#pragma mark View lifecycle

- (void)spinBegin {
	
	[cLoadingView startAnimating];
	
}
- (void)initSpinner {
	
	cLoadingView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];    
	
	// we put our spinning "thing" right in the center of the current view
	
	CGPoint newCenter = (CGPoint) [self.view center];
	
	cLoadingView.center = newCenter;
	
	[self.view addSubview:cLoadingView];
	
}

- (void)spinEnd {
	
	[cLoadingView stopAnimating];
	
}
- (void)viewDidLoad {
	
	
	//track this pageview
	
	[FlurryAPI logAllPageViews:self.navigationController];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
	NSDate* todaysaigon ;
	NSDate *todaycali;
	
	
	[self initSpinner];
	// Super
	[super viewDidLoad];



	// Setup
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	parsedItems = [[NSMutableArray alloc] init];
	
	// Refresh button
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(refresh)] autorelease];

	UIBarButtonItem *leftButton = [[[UIBarButtonItem alloc] initWithTitle:@"About"
																	style:UIBarButtonSystemItemDone
																  target:self 
																  action:@selector(setsource)] autorelease];
	self.navigationItem.leftBarButtonItem = leftButton;
	
	[NSThread detachNewThreadSelector: @selector(spinBegin) toTarget:self withObject:nil];
	self.title = @"Loading...";


	if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable) {
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Ái chà!"
														 message:@"Mạng bị hỏng rồi!"
														delegate:self
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil, nil];
		[alert show];
		
		
		NSString *applicationDocumentsDir = 
		[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
		NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:@"sample.xml"];

		NSDictionary* fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:storePath error:nil];
		todaycali = [fileAttribs valueForKey:NSFileModificationDate];
		todaysaigon = [[[NSDate alloc] initWithTimeInterval:54000 sinceDate:todaycali] autorelease];
		
		
		NSString *dateString = [dateFormat stringFromDate:todaysaigon];
		
		UILabel *lastupdated = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
		lastupdated.backgroundColor = [UIColor grayColor];
		lastupdated.textColor = [UIColor whiteColor];
		lastupdated.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		lastupdated.shadowOffset = CGSizeMake(0, -1.0);
		lastupdated.text=[NSString stringWithFormat:@"  Last updated %@", dateString];
		
		self.tableView.tableHeaderView=lastupdated;
		
		
		if(feedParser.delegate != self){ 
			
			feedParser = [[MWFeedParser alloc] initWithFeedURL:storePath];
			
			feedParser.offline=true;
			feedParser.delegate = self;
			feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
			feedParser.connectionType = ConnectionTypeAsynchronously;
			[feedParser parse];

						
	
			
		}		

	}
	else {//there is internet
		
		todaycali = [NSDate date];
		
		todaysaigon = [[[NSDate alloc] initWithTimeInterval:54000 sinceDate:todaycali] autorelease];
		
		
		NSString *dateString = [dateFormat stringFromDate:todaysaigon];
		
		UILabel *lastupdated = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
		lastupdated.backgroundColor = [UIColor grayColor];
		lastupdated.textColor = [UIColor whiteColor];
		lastupdated.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		lastupdated.shadowOffset = CGSizeMake(0, -1.0);
		lastupdated.text=[NSString stringWithFormat:@"  Cập nhật lúc: %@", dateString];
		
		self.tableView.tableHeaderView=lastupdated;
		
		feedParser = [[MWFeedParser alloc] initWithFeedURL:@"http://offover.com/vne/vne.xml"];
		feedParser.delegate = self;
		feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
		feedParser.connectionType = ConnectionTypeAsynchronously;
		[feedParser parse];
		
	}
	
	
	// Create the object manager
	objMan = [[HJObjManager alloc] init];
	
	//if you are using for full screen images, you'll need a smaller memory cache than the defaults,
	//otherwise the cached images will get you out of memory quickly
	//objMan = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:1];
	
	// Create a file cache for the object manager to use
	// A real app might do this durring startup, allowing the object manager and cache to be shared by several screens
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/flickr/"] ;
	HJMOFileCache* fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
	objMan.fileCache = fileCache;
	
	// Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
	fileCache.fileCountLimit = 100;
	fileCache.fileAgeLimit = 60*60*24*7; //1 week
	[fileCache trimCacheUsingBackgroundThread];
	[dateFormat release];
	
}



- (void)setsource {
	
	// track this action
		[FlurryAPI logEvent:@"ABOUT"];
	
	AboutViewController *about  = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
	[self.navigationController pushViewController:about animated:YES];
	if ([self.navigationController isNavigationBarHidden])
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	[about release];
	
	
}
// Deselect
#pragma mark -
#pragma mark Parsing

// Reset and reparse
- (void)refresh {
	[FlurryAPI logEvent:@"REFRESH"];
	
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
	
	NSDate* todaysaigon ;
	NSDate *todaycali;
	NSString *dateString;
	if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable) {
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Ái chà!"
														 message:@"Mạng bị hỏng rồi!"
														delegate:self
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil, nil];
		[alert show];
		NSString *applicationDocumentsDir = 
		[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
		NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:@"sample.xml"];
		
		
		NSDictionary* fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:storePath error:nil];
		todaycali = [fileAttribs valueForKey:NSFileModificationDate];
		todaysaigon = [[[NSDate alloc] initWithTimeInterval:54000 sinceDate:todaycali] autorelease];
		
		
	
		NSString *dateString = [dateFormat stringFromDate:todaysaigon];
		
		UILabel *lastupdated = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
		lastupdated.backgroundColor = [UIColor grayColor];
		lastupdated.textColor = [UIColor whiteColor];
		lastupdated.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		lastupdated.shadowOffset = CGSizeMake(0, -1.0);
		lastupdated.text=[NSString stringWithFormat:@"  Cập nhật lúc: %@", dateString];
		
		self.tableView.tableHeaderView=lastupdated;
		
		self.tableView.userInteractionEnabled =YES;

	}
	else
	{
		[NSThread detachNewThreadSelector: @selector(spinBegin) toTarget:self withObject:nil];
		NSDate *todaycali = [NSDate date];
		
		todaysaigon = [[[NSDate alloc] initWithTimeInterval:54000 sinceDate:todaycali] autorelease];
	
		
		dateString = [dateFormat stringFromDate:todaysaigon];
		
		UILabel *lastupdated = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
		lastupdated.backgroundColor = [UIColor grayColor];
		lastupdated.textColor = [UIColor whiteColor];
		lastupdated.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
		lastupdated.shadowOffset = CGSizeMake(0, -1.0);
		lastupdated.text=[NSString stringWithFormat:@"  Cập nhật lúc: %@", dateString];
		
		self.tableView.tableHeaderView=lastupdated;
				
		
		
		if(feedParser.delegate != self)
			{//if user has no wifi before but has wifi during using the app, this code will refresh 
				feedParser = [[MWFeedParser alloc] initWithFeedURL:@"http://offover.com/vne/vne.xml"];
				feedParser.delegate = self;
				feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
				feedParser.connectionType = ConnectionTypeAsynchronously;
				[feedParser parse];
			}
		else{//if user has wif before and during using the app, this code will refresh
			self.title = @"Refreshing...";

			[parsedItems removeAllObjects];

			[feedParser stopParsing];

			[feedParser parse];
			self.tableView.userInteractionEnabled = NO;
			self.tableView.alpha = 0.3;
			
		}
		

	}
	
		[dateFormat release];
	
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	if (item) [parsedItems addObject:item];	
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {

	self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
						   [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"date" 
																				 ascending:NO] autorelease]]];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
	[NSThread detachNewThreadSelector: @selector(spinEnd) toTarget:self withObject:nil];
	

}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {	
	self.title = @"Failed";
	self.itemsToDisplay = [NSArray array];
	[parsedItems removeAllObjects];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
}
/*

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation {
	
return YES; 
	
}
*/

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	
	return itemsToDisplay.count;


}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	HJManagedImageV* mi;
	

    if (cell == nil) {
		
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		//cell.accessoryType =UITableViewCellAccessoryNone;
		//Create a managed image view and add it to the cell (layout is very naieve)
		
		/*
		if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight))
			{
				mi = [[[HJManagedImageV alloc] initWithFrame:CGRectMake(IMAGE_X+200,IMAGE_Y,IMAGE_HEIGHT,IMAGE_WIDTH)] autorelease];
}
	else {
		mi = [[[HJManagedImageV alloc] initWithFrame:CGRectMake(IMAGE_X,IMAGE_Y,IMAGE_HEIGHT,IMAGE_WIDTH)] autorelease];

	}*/
		
		mi = [[[HJManagedImageV alloc] initWithFrame:CGRectMake(IMAGE_X,IMAGE_Y,IMAGE_HEIGHT,IMAGE_WIDTH)] autorelease];


		mi.tag = IMAGE_TAG;


		[cell.contentView addSubview:mi];
		UILabel *title;
		UILabel *summary;
		CGRect rect;

		//Title
		rect = CGRectMake(TEXT_OFFSET_X, BORDER_WIDTH, LABEL_WIDTH, LABEL_HEIGHT);
		title = [[UILabel alloc] initWithFrame:rect];
		title.tag = NAME_TAG;
		title.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
		title.highlightedTextColor = [UIColor whiteColor];
		title.opaque = NO;
		title.backgroundColor = [UIColor clearColor];
		title.numberOfLines = 2;
		title.lineBreakMode = UILineBreakModeWordWrap;

		[cell.contentView addSubview:title];

		[title release];
		//Message body
		rect = CGRectMake(TEXT_OFFSET_X, TEXT_OFFSET_Y, TEXT_WIDTH, TEXT_HEIGHT);
		summary = [[UILabel alloc] initWithFrame:rect];
		summary.tag = TEXT_TAG;
		summary.lineBreakMode = UILineBreakModeWordWrap;
		summary.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
		summary.highlightedTextColor = [UIColor whiteColor];
		summary.numberOfLines = 2;
		summary.opaque = NO;
		summary.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:summary];

		[summary release];
		
		
    }
	else {
		mi = (HJManagedImageV*)[cell viewWithTag:IMAGE_TAG];
		[mi clear];
	}
	

	
    
	// Configure the cell.
	MWFeedItem *item = [itemsToDisplay objectAtIndex:indexPath.row];


	if(item)	{
		UILabel *label;
		NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
		CGRect cellFrame = [cell frame];


		label = (UILabel *)[cell viewWithTag:NAME_TAG];
		label.text =itemTitle;
		label.textColor=[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
		label.font = [UIFont boldSystemFontOfSize:14];
		if(!item.img_url)
		{
			
			[label setFrame:CGRectMake( TEXT_OFFSET_X, BORDER_WIDTH,LABEL_WIDTH, LABEL_HEIGHT)];
			/*
			if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight))

			[label setFrame:CGRectMake( TEXT_OFFSET_X, BORDER_WIDTH,LABEL_WIDTH+160, LABEL_HEIGHT)];
			else {
				[label setFrame:CGRectMake( TEXT_OFFSET_X, BORDER_WIDTH,LABEL_WIDTH, LABEL_HEIGHT)];

			}
*/
			
		}
		else {
			
			[label setFrame:CGRectMake( TEXT_OFFSET_X, BORDER_WIDTH,LABEL_WIDTH-74, LABEL_HEIGHT)];
			
			/*
			if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight))

			[label setFrame:CGRectMake( TEXT_OFFSET_X, BORDER_WIDTH,LABEL_WIDTH-74+160, LABEL_HEIGHT)];
			else {
				[label setFrame:CGRectMake( TEXT_OFFSET_X, BORDER_WIDTH,LABEL_WIDTH-74, LABEL_HEIGHT)];

			}
			 */

			
		}
		
		label = (UILabel *)[cell viewWithTag:TEXT_TAG];
		label.text = itemSummary;
		if(!item.img_url)
		{
			[label setFrame:CGRectMake(TEXT_OFFSET_X, TEXT_OFFSET_Y, TEXT_WIDTH, TEXT_HEIGHT)];

			/*
			if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight))
			{	
				[label setFrame:CGRectMake(TEXT_OFFSET_X, TEXT_OFFSET_Y, TEXT_WIDTH+160, TEXT_HEIGHT)];
			}
else
		[label setFrame:CGRectMake(TEXT_OFFSET_X, TEXT_OFFSET_Y, TEXT_WIDTH, TEXT_HEIGHT)];*/
			
		}
		else {
			[label setFrame:CGRectMake(TEXT_OFFSET_X, TEXT_OFFSET_Y, TEXT_WIDTH-76, TEXT_HEIGHT)];

			
			/*
			if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight))
			{	
				[label setFrame:CGRectMake(TEXT_OFFSET_X, TEXT_OFFSET_Y, TEXT_WIDTH-76+160, TEXT_HEIGHT)];
			}
			else
			[label setFrame:CGRectMake(TEXT_OFFSET_X, TEXT_OFFSET_Y, TEXT_WIDTH-76, TEXT_HEIGHT)];*/

		}

			
		if(label.frame.size.height > TEXT_HEIGHT)
		{
			cellFrame.size.height = ROW_HEIGHT + label.frame.size.height - TEXT_HEIGHT;
		}
		else
		{
			cellFrame.size.height = ROW_HEIGHT;
		}
		
		[cell setFrame:cellFrame];
		
		label = (UILabel *)[cell viewWithTag:IMAGE_TAG];
		[label setFrame:CGRectMake(IMAGE_X,IMAGE_Y,IMAGE_HEIGHT,IMAGE_WIDTH)];

		/*
		if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight))
		{		

			[label setFrame:CGRectMake(IMAGE_X+160,IMAGE_Y,IMAGE_HEIGHT,IMAGE_WIDTH)];
			
		}
		else {
			[label setFrame:CGRectMake(IMAGE_X,IMAGE_Y,IMAGE_HEIGHT,IMAGE_WIDTH)];
		}*/

		mi.url = [NSURL URLWithString:item.img_url];

		[objMan manage:mi];

	}
	return cell;
	

}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"you clicked me!");
	
	
	self.detailTableViewController = [[[DetailTableViewController alloc] initWithNibName:nil bundle:nil] autorelease];
	self.detailTableViewController.item = (MWFeedItem *)[itemsToDisplay objectAtIndex:indexPath.row];

	detailTableViewController.appData = itemsToDisplay;
	detailTableViewController.startIndex = indexPath.row;
	[self.navigationController pushViewController:detailTableViewController animated:YES];
 
 
	
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[objMan release];
	[detailTableViewController release];

	[formatter release];
	[parsedItems release];
	[itemsToDisplay release];
	[feedParser release];
    [super dealloc];
}

@end
