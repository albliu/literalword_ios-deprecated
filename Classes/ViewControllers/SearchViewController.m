#import "SearchViewController.h"
#import "BibleViewController.h"


@implementation SearchViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    searchData = [[NSArray alloc] init];
    UISearchBar * mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    mySearchBar.delegate = self;
    
    self.tableView.tableHeaderView = mySearchBar;
    [mySearchBar release];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	VerseEntry * entry = [searchData objectAtIndex:[indexPath row]];
	// we assume search results will always only have 1 verse
	if (entry != nil) {
		[self.delegate selectedbook:entry.book_index chapter:entry.chapter 
						verse:[entry.verses intValue] highlights:[NSArray arrayWithObject:entry.verses]];
	}

	[self.navigationController popToRootViewControllerAnimated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

	return [searchData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    VerseEntry * entry = nil;
    if (searchData != nil) entry = [searchData objectAtIndex:[indexPath row]];

    if (entry == nil)  {

        cell.detailTextLabel.text = nil;
        cell.textLabel.text = nil;

    } else  {

        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %d:%@", entry.book, entry.chapter,entry.verses ];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", entry.text ];


    } 
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

#pragma mark - searchDisplayControllerDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:searchBar.text delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];
	[searchData release];
	searchData = [BibleDataBaseController searchString:[searchBar.text UTF8String]];
	[self.tableView reloadData];
}

- (void)dealloc {
    [searchData release];
    [super dealloc];
}
@end
