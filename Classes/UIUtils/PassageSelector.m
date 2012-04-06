#import "PassageSelector.h"
#import "BibleViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PassageSelector

-(id) initWithBook:(int) book Chapter:(int) chapter View:(id) v Width:(int)width {
		
	select_book = book;
	select_chapter = chapter;	

	frame_width = width;
	self.modalPresentationStyle = UIModalPresentationFormSheet;
	return [self initWithRootView:v];
}

- (void) loadView {

	[super loadView];

	[self loadClearView];

	UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(frame_width / 2 - PASSAGESELECTOR_WIDTH / 2 , 0, PASSAGESELECTOR_WIDTH, PASSAGESELECTOR_HEIGHT + MYBUTTON_HEIGHT)];

	UIPickerView * _selectMenu = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, PASSAGESELECTOR_WIDTH, PASSAGESELECTOR_HEIGHT)];
	_selectMenu.delegate =self;	
	_selectMenu.showsSelectionIndicator = YES;

	[_selectMenu.layer setCornerRadius:8.0f];
	[_selectMenu.layer setMasksToBounds:YES];

	[_selectMenu selectRow:select_book inComponent:0 animated: NO];
	[_selectMenu reloadComponent:1];
	[_selectMenu selectRow:(select_chapter - 1) inComponent:1 animated: NO];


	[myView addSubview:_selectMenu];
	[_selectMenu release];

	UIButton * select = [self generateButton:"Select" selector:@selector(verseselected)
		frame:CGRectMake(PASSAGESELECTOR_WIDTH/2, PASSAGESELECTOR_HEIGHT, PASSAGESELECTOR_WIDTH/2,MYBUTTON_HEIGHT)];
	[myView addSubview:select];

	UIButton * cancel = [self generateButton:"Cancel" selector:@selector(versecanceled) 
		frame:CGRectMake(0, PASSAGESELECTOR_HEIGHT, PASSAGESELECTOR_WIDTH/2,MYBUTTON_HEIGHT)];
	[myView addSubview:cancel];

	myView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin) ; 
	
	[self.view addSubview:myView];
	[myView release];
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
			[pickerView reloadComponent:1];
		}
	}
	else if (component == 1) {
		select_chapter = row + 1;
	}
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if (component == 0) return 200.0;
	else return 80.0;
}

-(void) verseselected {
	//commit 
	[self.rootview selectedbook:select_book chapter:select_chapter];
	[self dismissMyView];
}

-(void) versecanceled {
	//commit 
	[self dismissMyView];
}
@end
