#import "VersesViewController.h"
#import "BibleViewController.h"


@implementation VersesViewController
@synthesize delegate=_delegate;
@synthesize myData=_myData;


- (id) initWithDelegate:(id) bibleView Data:(VersesData *) data {
    self = [ super initWithStyle: UITableViewStylePlain];

    self.delegate = bibleView;
    self.myData = data;
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.myData.myVerses count]; 
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    // Set up the cell...
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	VerseEntry * entry = [self.myData.myVerses objectAtIndex:[indexPath row]];

	cell.textLabel.text = [NSString stringWithFormat:@"%@ %d", entry.book, entry.chapter ];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	VerseEntry * entry = [self.myData.myVerses objectAtIndex:[indexPath row]];

	[self.delegate selectedbook:entry.book_index chapter:entry.chapter];

	[self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)dealloc {
    [self.myData release];
    [super dealloc];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
	// remove the item from your data
	[self.myData removeFromList:indexPath.row];

	// refresh the table view
	[tableView reloadData];
}

- (void) clear:(id) ignored {
	[self.myData clear];
	[self.tableView reloadData];
}
@end
