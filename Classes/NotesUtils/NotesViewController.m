#import "NotesViewController.h"


@implementation NotesViewController
@synthesize myData=_myData;


- (id) initWithNotes:(NotesData *) data {
	self = [ super initWithStyle: UITableViewStylePlain];

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

	UIBarButtonItem *new = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleDone target:self action:@selector(newnote:)];

	self.navigationItem.rightBarButtonItem = new;
	[new release];

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
	return [self.myData.myNotes count]; 
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    // Set up the cell...
	if (cell == nil) {
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
	}
	
	NoteEntry * entry = [self.myData.myNotes objectAtIndex:[indexPath row]];

	cell.textLabel.text = [NSString stringWithFormat:@"%@", entry.title];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NoteEntry * entry = [self.myData.myNotes objectAtIndex:[indexPath row]];
	
	NotesEditViewController * myView = [[NotesEditViewController alloc] initWithNote:entry] ;
	myView.myDelegate = self;
	[self.navigationController pushViewController:myView animated:YES];
	[myView release];

//	[[[[UIAlertView alloc] initWithTitle: [NSString stringWithFormat:@"%@", entry.title] message:entry.body delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] autorelease] show];
}



- (void) saveNote: (NSString *) title Body:(NSString *) body {
	[self.myData addNewNote:title Body:body];	
	[self.tableView reloadData];	// populate our table's data

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

- (void) newnote:(id) ignored {

	NotesEditViewController * myView = [[NotesEditViewController alloc] init] ;
	myView.myDelegate = self;
	[self.navigationController pushViewController:myView animated:YES];
	[myView release];
}
@end
