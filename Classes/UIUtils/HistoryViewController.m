#import "HistoryViewController.h"
#import "BibleViewController.h"

#define FONT_SIZE 20.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_CONTENT_HEIGHT_MARGIN 2.0f
#define MINIMUM_CELL_CONTENT_HEIGHT 40.0f


@implementation HistoryViewController
@synthesize myHistory=_myHistory;
@synthesize delegate=_delegate;

- (NSMutableArray *) myHistory {
	if (_myHistory == nil) {
		_myHistory = [[NSMutableArray alloc] initWithCapacity:HISTORY_MAX];
	}
	return _myHistory;

}

- (id) initWithDelegate:(id) bibleView {
    self = [ super initWithStyle: UITableViewStylePlain];

    if (self != nil) {
        self.title = @"History";
    }
    self.delegate = bibleView;
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
 
	// setup our list view to autoresizing in case we decide to support autorotation along the other UViewControllers
	self.tableView.autoresizesSubviews = YES;
	self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
 
 
}

- (void) viewDidLoad {

	UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clear:)];

	self.navigationItem.rightBarButtonItem = clear;
	[clear release];

	[self.tableView reloadData];	// populate our table's data
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (int) existsInHistory:(NSArray *) entry {

	int i;
	NSArray * tmp;
	for ( i = 0; i < [self.myHistory count]; i++ ) {
		tmp = [self.myHistory objectAtIndex:i];
		if (( [entry objectAtIndex:2] == [tmp objectAtIndex:2]) &&
			([entry objectAtIndex:1] == [tmp objectAtIndex:1])) return i;

	}

	return -1;
}

- (void) addToHistory:(NSString *) bookname Book:(int) book Chapter:(int) chap {
		
	NSArray * entry = [[NSArray alloc] initWithObjects:bookname, [NSNumber numberWithInt:chap],[NSNumber numberWithInt:book], nil];

	int exist = [self existsInHistory:entry];
	if (exist != -1) [self.myHistory removeObjectAtIndex:exist];

	[self.myHistory insertObject:entry atIndex:0];
	[entry release];	

	if ([self.myHistory count] > HISTORY_MAX) [self.myHistory removeObjectAtIndex:0]; 

	[self.tableView reloadData];
}
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.myHistory count]; 
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UILabel *label = nil;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    // Set up the cell...
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		[label setLineBreakMode:UILineBreakModeWordWrap];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setMinimumFontSize:FONT_SIZE];
		[label setNumberOfLines:0];
		[label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
		[label setTag:1];
		[[cell contentView] addSubview:label];
	}
	
	NSArray * entry = [self.myHistory objectAtIndex:[indexPath row]];

	NSString *text = [NSString stringWithFormat:@"%@ %@", [entry objectAtIndex:0], [entry objectAtIndex:1] ];

	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
	
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
	if (!label)
		label = (UILabel*)[cell viewWithTag:1];
	
	[label setText:text];
	[label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_HEIGHT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, MINIMUM_CELL_CONTENT_HEIGHT))];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray * entry = [self.myHistory objectAtIndex:[indexPath row]];

	[self.delegate selectedbook:[[entry objectAtIndex:2] intValue] chapter:[[entry objectAtIndex:1] intValue]];

	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) clear:(id) ignored {
	[self.myHistory removeAllObjects];
	[self.tableView reloadData];

}

- (void)dealloc {
    [super dealloc];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
	// remove the item from your data
	[self.myHistory removeObjectAtIndex:indexPath.row];

	// refresh the table view
	[tableView reloadData];
}

@end
