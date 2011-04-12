
#import "Reachability.h"

#import "DetailTableViewController.h"
#import "NSString+HTML.h"
#import "SHK.h"
#import "FlurryAPI.h"


CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@interface DetailTableViewController (PrivateMethods)
-(void)hideGradientBackground:(UIView*)theView;
-(UIWebView*) createWebViewForIndex:(NSUInteger)index;
@end

@implementation DetailTableViewController

@synthesize item;


@synthesize headerView, headerImageView, headerLabel;
@synthesize footerView, footerImageView, footerLabel;
@synthesize verticalSwipeScrollView, appData, startIndex;
@synthesize previousPage, nextPage,currentPage;

- (void)viewDidLoad
{
	
	[FlurryAPI logAllPageViews:self.navigationController];
		
	headerImageView.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));

	UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Share"
															style:UIBarButtonItemStyleBordered
														   target:self
														   action:@selector(goShare:)]; 
	
	
	self.navigationItem.rightBarButtonItem = bbi;
	
	[bbi release]; 

	
}

-(void)willAppearIn:(UINavigationController *)navigationController
{

	
	self.verticalSwipeScrollView = [[[VerticalSwipeScrollView alloc] initWithFrame:self.view.frame headerView:headerView footerView:footerView startingAt:startIndex delegate:self] autorelease];
	[self.view addSubview:verticalSwipeScrollView];
}

- (void) rotateImageView:(UIImageView*)imageView angle:(CGFloat)angle
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	imageView.transform = CGAffineTransformMakeRotation(DegreesToRadians(angle));
	[UIView commitAnimations];
}

# pragma mark VerticalSwipeScrollViewDelegate

-(void) headerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView
{
	[self rotateImageView:headerImageView angle:0];
}

-(void) headerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView
{
	[self rotateImageView:headerImageView angle:180];
}

-(void) footerLoadedInScrollView:(VerticalSwipeScrollView*)scrollView
{
	[self rotateImageView:footerImageView angle:180];
}

-(void) footerUnloadedInScrollView:(VerticalSwipeScrollView*)scrollView
{
	[self rotateImageView:footerImageView angle:0];
}

-(UIView*) viewForScrollView:(VerticalSwipeScrollView*)scrollView atPage:(NSUInteger)page
{
	//NSLog(@"rotating");


	UIWebView* webView = nil;
	

	if (page < scrollView.currentPageIndex)
		webView = [[previousPage retain] autorelease];
	else if (page > scrollView.currentPageIndex)
		webView = [[nextPage retain] autorelease];

	if (!webView)
		webView = [self createWebViewForIndex:page];

	self.previousPage = page > 0 ? [self createWebViewForIndex:page-1] : nil;
	NSLog(@"%@",self.item.title);

	self.nextPage = (page == (appData.count-1)) ? nil : [self createWebViewForIndex:page+1];
	NSLog(@"%@",self.item.title);

	MWFeedItem *temp;
	if (page > 0){
		temp=(MWFeedItem *)[appData objectAtIndex:page-1];
		headerLabel.text = temp.title;
	}
	if (page != appData.count-1)
	{
		temp=(MWFeedItem *)[appData objectAtIndex:page+1];

		footerLabel.text = temp.title	;
	}
	

	self.currentPage=webView;
	self.item=(MWFeedItem *)[appData objectAtIndex:page];

	return webView;
}

-(NSUInteger) pageCount
{
	return appData.count;
}


-(void)goShare:(id)sender


{	
	
	
	
	
	if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable) {
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Ái chà!"
														 message:@"Mạng bị hỏng rồi!"
														delegate:self
											   cancelButtonTitle:@"OK"
											   otherButtonTitles:nil, nil];
		[alert show];
	}
	else{
	//	NSLog(@"%@",item.title);
	NSURL *url = [NSURL URLWithString:item.link]; 
	
	
	SHKItem *shkitem = [SHKItem URL:url title:item.title
						];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:shkitem];
	[actionSheet showFromToolbar:self.navigationController.toolbar]; 
	}
}




/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

	return YES; 	
}
*/

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	/*

	UIWebView* mywebView = self.currentPage;
	UIScrollView * myscrollView = self.verticalSwipeScrollView;

	
	CGRect newwebFrame = mywebView.frame;	
	CGRect newscrollFrame = myscrollView.frame;	

	
	if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
		// Assuming this is the correct UIView object
		NSLog(@"landscape");
		newwebFrame.size.height = 420;
		newwebFrame.size.width = 470;
		
		mywebView.frame = newwebFrame;
		
		newscrollFrame.size.height = 420;
		newscrollFrame.size.width = 470;
		
		myscrollView.frame = newscrollFrame;
		
	} else	if((self.interfaceOrientation == UIDeviceOrientationPortrait) || (self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)){
		newwebFrame.size.height = 420;
		newwebFrame.size.width = 320;
		
		mywebView.frame = newwebFrame;
		
		newscrollFrame.size.height = 420;
		newscrollFrame.size.width = 320;
		
		myscrollView.frame = newscrollFrame;
	
		
		
	} 
	 
	 */
}


-(UIWebView*) createWebViewForIndex:(NSUInteger)index
{
	MWFeedItem *tempitem = (MWFeedItem *)[appData objectAtIndex:index];
	//NSLog(@"%@",self.item.title);
	
	//NSLog(@"creating webview");
	
	UIWebView* webView = [[[UIWebView alloc] initWithFrame:self.view.frame] autorelease];
	webView.opaque = NO;
	[webView setBackgroundColor:[UIColor clearColor]];
	[self hideGradientBackground:webView];

	NSDate *todaycali = tempitem.date;
	
	NSDate* todaysaigon = [[[NSDate alloc] initWithTimeInterval:54000 sinceDate:todaycali] autorelease];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
	
	
	NSString* cssTags = @"<style type=\"text/css\"/> p {padding-right: 15px; } img {max-width: 100%; width: auto; height: auto;} </style>";
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	NSString *htmlString =[NSString stringWithFormat:@"<html><head>%@ <b>%@</b></head><body><br />%@%@</body></html>",
						   cssTags,tempitem.title,[dateFormat stringFromDate:todaysaigon],tempitem.summary];
	
	[webView loadHTMLString:htmlString baseURL:baseURL];
	[dateFormat release];
	
	return webView;
}

- (void) hideGradientBackground:(UIView*)theView
{
	for (UIView * subview in theView.subviews)
	{
		if ([subview isKindOfClass:[UIImageView class]])
			subview.hidden = YES;
		
		[self hideGradientBackground:subview];
	}
}

- (void)viewDidUnload
{
	self.headerView = nil;
	self.headerImageView = nil;
	self.headerLabel = nil;
	
	self.footerView = nil;
	self.footerImageView = nil;
	self.footerLabel = nil;
}

- (void)dealloc
{
	[headerView release];
	[headerImageView release];
	[headerLabel release];
	
	[footerView release];
	[footerImageView release];
	[footerLabel release];
	
	[verticalSwipeScrollView release];
	[appData release];
	[previousPage release];
	[nextPage release];
	
	[super dealloc];
}

@end
