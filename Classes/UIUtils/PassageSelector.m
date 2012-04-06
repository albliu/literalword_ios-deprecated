#import "PassageSelector.h"
#import "BibleViewController.h"

@implementation PassageSelector

@synthesize selectMenu=_selectMenu;
@synthesize bibleview=_bibleview;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}

-(UIPickerView *) selectMenu {
	if (_selectMenu == nil) {
		_selectMenu = [[UIPickerView alloc] initWithFrame:CGRectMake(frame_width / 2 - PASSAGESELECTOR_WIDTH / 2 , 0, PASSAGESELECTOR_WIDTH, PASSAGESELECTOR_HEIGHT)];
		_selectMenu.delegate =self;	
		_selectMenu.showsSelectionIndicator = YES;
		_selectMenu.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin) ; 
	}
	return _selectMenu;

}

-(id) initWithBook:(int) book Chapter:(int) chapter View:(id) v Width:(int)width {
		
	select_book = book;
	select_chapter = chapter;	

	frame_width = width;
	self.modalPresentationStyle = UIModalPresentationFormSheet;
	self.bibleview = v;
	return [self init];
}

- (void) loadView {

	[super loadView];

	[self.view addSubview:self.selectMenu];
	
}

- (void) viewDidLoad{

	[self.selectMenu selectRow:select_book inComponent:0 animated: NO];
	[self.selectMenu reloadComponent:1];
	[self.selectMenu selectRow:(select_chapter - 1) inComponent:1 animated: NO];

}


#pragma mark UIPickerView Delegate methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{ return 2; }

- (NSInteger)pickerView: (UIPickerView *)pView numberOfRowsInComponent: (NSInteger) component
{
	NSInteger ret = 0; 
	if (component == 0)
		ret = [BibleDataBaseController maxBook]; 
	else if (component == 1)
		ret = [[BibleDataBaseController getBookChapterCountAt:select_book] intValue];
	return ret;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	NSString * title;
	if (component == 0 )
		title =  [BibleDataBaseController getBookNameAt:row];
	else if (component == 1)
		title =  [NSString stringWithFormat:@"%d", row + 1];
	return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {

	if (component == 0) {
		if (select_book != row) {
			select_book = row;
			select_chapter = 1;
			[pickerView reloadComponent:1];
		}
	}
	else if (component == 1) {
		select_chapter = row + 1;
		
		//commit 
		[self.bibleview selectedbook:select_book chapter:select_chapter];
		[self.bibleview showMainView];
	}
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if (component == 0) return 200.0;
	else return 80.0;
}

- (void) dismiss {
	[self.selectMenu removeFromSuperview];
}
- (void) dealloc {
	[self.selectMenu release];
	
	[super dealloc];

}

@end
