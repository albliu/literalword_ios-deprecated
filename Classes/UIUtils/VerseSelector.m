#import "VerseSelector.h"
#import "BibleViewController.h"

@implementation VerseSelector

@synthesize rootview=_rootview;
@synthesize tableView=_tableView;


-(UITableView *) tableView {
	if (_tableView == nil) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - VERSES_TABLE_WIDTH / 2, frame.size.height / 2 - VERSES_TABLE_HEIGHT / 2, VERSES_TABLE_WIDTH, VERSES_TABLE_HEIGHT) style:UITableViewStylePlain];
		_tableView.delegate = self;

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
	[self.tableView release];
	[super dealloc];

}

#pragma mark Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (ver / (VERSES_TABLE_WIDTH / VERSES_CELL_SIDE)); 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return VERSES_CELL_SIDE;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

	int row = indexPath.row;
    // Set up the cell...
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellAccessoryDetailDisclosureButton;

		for (int i = 0; i < (VERSES_TABLE_WIDTH / VERSES_CELL_SIDE); i++) {
			int value = (row * (VERSES_TABLE_WIDTH / VERSES_CELL_SIDE)) + i + 1;	
			UIButton * tmp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			tmp.frame = CGRectMake(i*VERSES_CELL_SIDE, 0, VERSES_CELL_SIDE, VERSES_CELL_SIDE);
			tmp.tag = i; 
			[tmp setTitle:[NSString stringWithFormat:@"%d", value] forState: UIControlStateNormal];	
			[tmp setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];	
			[tmp addTarget:self action:@selector(selectedVerse:) forControlEvents:UIControlEventTouchDown];
			[cell.contentView addSubview:tmp];
			[tmp release];
		}


	} else {

		for (int i = 0; i < (VERSES_TABLE_WIDTH / VERSES_CELL_SIDE); i++) {
			int value = (row * (VERSES_TABLE_WIDTH / VERSES_CELL_SIDE)) + i + 1;	
			UIButton * tmp = (UIButton *) [cell.contentView viewWithTag:i];
			[tmp setTitle:[NSString stringWithFormat:@"%d", value] forState: UIControlStateNormal];	
		}

	}



    return cell;
}


-(void) selectedVerse:(UIButton *) buttonView
{
	int verse = [[buttonView currentTitle] intValue];
	[self.rootview gotoVerse:verse];
	[self.rootview showMainView];

}


@end
