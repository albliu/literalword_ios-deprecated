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
@synthesize myDB=_myDB;

- (VersesDataBaseController *) myDB {
	if (_myDB == nil) {
		_myDB = [[VersesDataBaseController alloc] initDataBase:DATABASE_HISTORY_TABLE];
	}
	return _myDB;
}

- (NSMutableArray *) myHistory {
	if (_myHistory == nil) {
		_myHistory = [[NSMutableArray alloc] initWithCapacity: HISTORY_MAX];
		NSArray * tmp =  [self.myDB findAllVerses];

		// we need to reverse the inital array since most recently added should be on top		
		int i = [tmp count] - 1;
		for ( ; i >= 0; i--) {
			[_myHistory addObject:[tmp objectAtIndex:i]];
		}
		[tmp release];
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

- (int) existsInHistory:(VerseEntry *) entry {

	int i;
	VerseEntry * tmp;
	for ( i = 0; i < [self.myHistory count]; i++ ) {
		tmp = [self.myHistory objectAtIndex:i];
		if (([tmp.book isEqualToString:entry.book]) &&
			(tmp.chapter == entry.chapter)) return i;

	}

	return -1;
}

- (void) clear:(id) ignored {
	[self.myDB deleteAllVerses];
	[self.myHistory removeAllObjects];
	[self.tableView reloadData];

}

- (void) removeFromList:(int) index {

	VerseEntry * ver = [[self.myHistory objectAtIndex:index] autorelease];
	[self.myDB deleteVerse:ver.rowid]; 	
	[self.myHistory removeObjectAtIndex:index];

}

- (void) addToList:(VerseEntry *) ver {

	[self.myDB addVerse:ver.book 
			Chapter:[NSString stringWithFormat:@"%d", ver.chapter]
			Verses:ver.verses
			Text:ver.text]; 	

	[self.myHistory insertObject:ver atIndex:0];
}


- (void) addToHistory:(NSString *) bookname Book:(int) book Chapter:(int) chap {
		
	VerseEntry * entry = [[VerseEntry alloc] initWithBook:bookname 
						Chapter:chap Verses:nil Text:nil ID:-1];

	int exist = [self existsInHistory:entry];
	if (exist != -1) [self removeFromList:exist];

	[self addToList:entry];
	[entry release];	
	if ([self.myHistory count] > HISTORY_MAX) [self removeFromList:0]; 

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
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    // Set up the cell...
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	VerseEntry * entry = [self.myHistory objectAtIndex:[indexPath row]];

	cell.textLabel.text = [NSString stringWithFormat:@"%@ %d", entry.book, entry.chapter ];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	VerseEntry * entry = [self.myHistory objectAtIndex:[indexPath row]];

	[self.delegate selectedbookname:entry.book chapter:entry.chapter];

	[self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)dealloc {
    [self.myHistory dealloc];
    [self.myDB dealloc];
    [super dealloc];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
	// remove the item from your data
	[self removeFromList:indexPath.row];

	// refresh the table view
	[tableView reloadData];
}

@end
