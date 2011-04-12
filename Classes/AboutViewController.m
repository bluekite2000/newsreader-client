

#import "AboutViewController.h"


@implementation AboutViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	UILabel *helloLabel;
	if (self.interfaceOrientation==UIInterfaceOrientationPortrait || self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown)
	{

	 helloLabel= [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 380)];
	}
	else if (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight || self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft)
	{
		helloLabel= [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 460,250)];
	}
	
	
	helloLabel.text = @"Cảm ơn bạn sử dụng Vnexpress app phiên bản Lite.\nMục đích chính của app này là mang tin tới iphone bạn nhanh và gọn. Một chức năng hữu dụng khác của app là bạn có thể tải bài về khi bạn online và đọc khi bạn offline. Hiện tại chúng tôi giữ 50 bài mới nhất từ trang chính của Vnexpress và cập nhật tin mỗi 10 phút. Nếu bạn đã refresh mà vẫn không thấy tin mới là vì Vnexpress chưa có bài mới. Vnexpress viết khoảng 5-7 bài trong 1 giờ (giờ hành chánh). Bạn refresh ngày 2 lần là đủ để lấy hết tin trong ngày. Lưu ý nếu bài bạn tải về iphone có định dạng không chuẩn, lí do là Vnexpress không tuân theo tiêu chuẩn xml.\nDat-Nhà sách ngoại văn U.S.A Books-sachesl.com";
	helloLabel.lineBreakMode = UILineBreakModeWordWrap;
	helloLabel.numberOfLines = 0;
	[helloLabel setFont:[UIFont fontWithName:@"Times New Roman" size:16]];

	[mainView addSubview:helloLabel];

	[helloLabel release];	
    
    self.view = mainView;
    [mainView release];
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation {
	return YES; 
	
}
 */
/*
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {

	UIView* theSubView = [self.view.subviews objectAtIndex:0];
	// Casting subview, won't be pretty if subview isn't a UILabel
	UILabel *myLabel = (UILabel *)theSubView; 
	CGRect newFrame = myLabel.frame;
	
	if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
		// Assuming this is the correct UIView object
		newFrame.size.height = 250;
		newFrame.size.width = 460;

		myLabel.frame = newFrame;
				
	} else	if((self.interfaceOrientation == UIDeviceOrientationPortrait) || (self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)){
		newFrame.size.height = 350;
		newFrame.size.width = 300;
		
		myLabel.frame = newFrame;


	}
}

*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
    // Release any retained subviews of the main view.
}


- (void)dealloc {
    [super dealloc];
}


@end
