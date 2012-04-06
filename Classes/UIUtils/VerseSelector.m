#import "VerseSelector.h"
#import "BibleViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation VerseSelector

@synthesize rootview=_rootview;
@synthesize tableView=_tableView;


-(UITableView *) tableView {
	if (_tableView == nil) {

		int myheight = ( VERSES_TABLE_HEIGHT > ( rows * VERSES_CELL_SIDE) ) ? (rows * VERSES_CELL_SIDE) : VERSES_TABLE_HEIGHT;	

		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - VERSES_TABLE_WIDTH / 2 - VERSES_TABLE_BORDER, frame.size.height / 2 - myheight / 2 - VERSES_TABLE_BORDER, VERSES_TABLE_WIDTH + 2*VERSES_TABLE_BORDER, myheight + 2*VERSES_TABLE_BORDER) style:UITableViewStylePlain];
		[_tableView setDataSource:self];
		[_tableView setDelegate:self];
		_tableView.layer.borderWidth = VERSES_TABLE_BORDER;
		_tableView.layer.borderColor = [[UIColor grayColor] CGColor];
		_tableView.separatorColor = [UIColor clearColor];
		_tableView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin) ; 

	}	
	return _tableView;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}


-(VerseSelector *) initWithViewFrame:(CGRect) rect Delegate: del Verses:(int) v {

	ver = v;

	int col = VERSES_TABLE_WIDTH / VERSES_CELL_SIDE;
	rows = ver / col;
	if ( (ver % col) != 0) rows += 1;

	frame = rect;
	self.rootview = del;
	return self;
}

- (void) loadView {

	[super loadView];

	[self.view addSubview:self.tableView];
	
}

- (void) viewDidLoad {
	[self.tableView reloadData];
}

-(void) showMyView {
	[self viewDidLoad];

}

-(void) dismissMyView {

	[self.tableView removeFromSuperview];
}

-(void) dealloc {
	[super dealloc];

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

	for (int i = 0; i < (VERSES_TABLE_WIDTH / VERSES_CELL_SIDE); i++) {
		int value = (row * (VERSES_TABLE_WIDTH / VERSES_CELL_SIDE)) + i + 1;	
		if (value > ver) break;
		UIButton * tmp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		tmp.frame = CGRectMake(i*VERSES_CELL_SIDE + VERSES_TABLE_BORDER, 0, VERSES_CELL_SIDE, VERSES_CELL_SIDE);
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
	[self.rootview showMainView];

}


@end
