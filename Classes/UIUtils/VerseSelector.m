#import "VerseSelector.h"
#import <QuartzCore/QuartzCore.h>

@implementation VerseSelector



- (void) setMyFrames {
	
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		myWidth = VERSES_TABLE_LONG;
		myHeight = VERSES_TABLE_SHORT;
	} else { 
		myWidth = VERSES_TABLE_SHORT;
		myHeight = VERSES_TABLE_LONG;
	}

	cols = myWidth / VERSES_CELL_SIDE;
	rows = ver / cols;
	if ( (ver % cols) != 0) rows += 1;


}
-(VerseSelector *) initWithRootView:(id) del Verses:(int) v {

	ver = v;
	frame = [[UIScreen mainScreen] bounds];

	return [self initWithRootView:del];
}

- (void) loadView {

	[super loadView];

	[self setMyFrames];

	UIView * clearBackground = [[UIView alloc] initWithFrame:frame];
	[clearBackground setBackgroundColor: [UIColor colorWithRed:0.332f green:0.332f blue:0.332f alpha:0.4f]];
	clearBackground.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ) ; 
	[self.view addSubview:clearBackground];
	[clearBackground release];

	int myheight = ( myHeight > ( rows * VERSES_CELL_SIDE) ) ? (rows * VERSES_CELL_SIDE) : myHeight;	


	UIView * viewFrame = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - myWidth / 2 - VERSES_TABLE_BORDER, frame.size.height / 2 - myheight / 2 - VERSES_TABLE_BORDER, myWidth + 2*VERSES_TABLE_BORDER, myheight + 2*VERSES_TABLE_BORDER)];
	viewFrame.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin) ; 
	[viewFrame setBackgroundColor: [UIColor SHEET_BLUE]];

	[viewFrame.layer setCornerRadius:8.0f];
	[viewFrame.layer setMasksToBounds:YES];

	[self.view addSubview:viewFrame];
	[viewFrame release];

	UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - myWidth / 2, frame.size.height / 2 - myheight / 2, myWidth, myheight) style:UITableViewStylePlain] ;
	[tableView setDataSource:self];
	[tableView setDelegate:self];
	[tableView setBackgroundColor: [UIColor clearColor]];
	tableView.separatorColor = [UIColor clearColor];
	tableView.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin) ; 
	[tableView reloadData];

	[self.view addSubview:tableView];	
	[tableView release];

	// allow backBUtton to work
	UIButton * verse = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_OFFSET, self.view.bounds.size.height - BUTTON_SIZE - BUTTON_OFFSET, BUTTON_SIZE,BUTTON_SIZE)];
	[verse addTarget:self action:@selector(dismissMyView) forControlEvents:UIControlEventTouchUpInside];
	[verse setBackgroundColor:[UIColor clearColor]];
	verse.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin) | (UIViewAutoresizingFlexibleTopMargin);	
	[self.view addSubview:verse];
	[verse release];	



}


#pragma mark Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return rows; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return VERSES_CELL_SIDE;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";

	int row = indexPath.row;
	UITableViewCell * cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell setBackgroundColor: [UIColor clearColor]];
	for (int i = 0; i < cols; i++) {
		int value = (row * cols) + i + 1;	
		if (value > ver) break;
		UIButton * tmp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		tmp.frame = CGRectMake(i*VERSES_CELL_SIDE, 0, VERSES_CELL_SIDE, VERSES_CELL_SIDE);
		tmp.tag = value; 
		[tmp setTitle:[NSString stringWithFormat:@"%d", value] forState: UIControlStateNormal];	
		[tmp setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];	
		[tmp addTarget:self action:@selector(selectedVerse:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:tmp];
	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	// do nothing
	return;
}

-(void) selectedVerse:(id) sender 
{
	UIButton * buttonView = (UIButton *) sender;
	int verse = buttonView.tag;
	[self.rootview gotoVerse:verse];
	[self dismissMyView];

}


@end
