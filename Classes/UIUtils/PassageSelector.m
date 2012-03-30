#import "PassageSelector.h"
#import "BibleViewController.h"

@implementation PassageSelector


@synthesize selectMenu=_selectMenu;
@synthesize delegate=_delegate;
@synthesize hidden=_hidden;
@synthesize view=_view;
@synthesize bibleDB=_bibleDB;

-(UIPickerView *) selectMenu {
	if (_selectMenu == nil) {
		_selectMenu = [[UIPickerView alloc] initWithFrame:CGRectMake((frame_width/2) - (PASSAGESELECTOR_WIDTH/2) , 0, PASSAGESELECTOR_WIDTH, PASSAGESELECTOR_HEIGHT)];
		_selectMenu.delegate =self;	
		_selectMenu.showsSelectionIndicator = YES;
		_selectMenu.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin); 
	}
	return _selectMenu;

}

-(BOOL) hidden {
	return self.selectMenu.hidden;
}

-(PassageSelector *) initWithViewWidth:(int) width Delegate: del BibleDB:(BibleDataBaseController *)db {
	frame_width = width;
	self.delegate = del;
	[self.selectMenu setHidden:YES];
	self.view = self.selectMenu;
	self.bibleDB = db;	
	return self;
}


-(void) showSelector:(int) book withChapter:(int) chapter {

	select_book = book;
	select_chapter = chapter;	
	[self.selectMenu selectRow:book inComponent:0 animated: NO];
	[self.selectMenu reloadComponent:1];
	[self.selectMenu selectRow:(chapter - 1) inComponent:1 animated: NO];
	[self.selectMenu setHidden:NO];

}

-(void) hideSelector {
	[self.selectMenu setHidden:YES];

}

#pragma mark UIPickerView Delegate methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{ return 2; }

- (NSInteger)pickerView: (UIPickerView *)pView numberOfRowsInComponent: (NSInteger) component
{
	NSInteger ret = 0; 
	if (component == 0)
		ret = [self.bibleDB maxBook]; 
	else if (component == 1)
		ret = [[self.bibleDB getBookChapterCountAt:select_book] intValue];
	return ret;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	NSString * title;
	if (component == 0 )
		title =  [self.bibleDB getBookNameAt:row];
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
		[pickerView setHidden:YES];
		
		//commit 
		[self.delegate selectedbook:select_book chapter:select_chapter];
	}
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if (component == 0) return 200.0;
	else return 80.0;
}

- (oneway void) release {
	[self.selectMenu release];
	
	[super release];

}

@end
