#import "SearchViewController.h"
#import "BibleViewController.h"
//#import "SearchTableViewCell.h"

@implementation SearchViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    searchData = [[NSArray alloc] init];
    UISearchBar * mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    mySearchBar.delegate = self;
    [mySearchBar becomeFirstResponder];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

	VerseEntry * entry = [searchData objectAtIndex:[indexPath row]];
	RTLabel * rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(0, VERSE_LABEL_HEIGHT, self.view.frame.size.width, 100)];
	[rtLabel setText:entry.text];
	CGSize optimumSize = [rtLabel optimumSize];
	return optimumSize.height + VERSE_LABEL_HEIGHT + 2 * CELL_SPACING;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString* CellIdentifier = @"ResultCell";
    RTLabel * textLabel = nil;
    UILabel* verseLabel = nil;

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil ) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
                                       reuseIdentifier: CellIdentifier] autorelease];

	textLabel = [[RTLabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.width - CELL_SPACING, 100)];
    	[textLabel setParagraphReplacement:@""];
	textLabel.tag = CELLTEXTVIEW;
        [cell.contentView addSubview: textLabel];
	[textLabel release];

        verseLabel = [[[UILabel alloc] initWithFrame: CGRectMake( CELL_SPACING, CELL_SPACING, self.view.frame.size.width, VERSE_LABEL_HEIGHT )] autorelease];
        verseLabel.tag = CELLLABELVIEW; 
        verseLabel.font = [UIFont boldSystemFontOfSize: VERSE_LABEL_FONT_SIZE];
        verseLabel.textAlignment = UITextAlignmentLeft;
        verseLabel.textColor = [UIColor darkTextColor];
        verseLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview: verseLabel];
    }
    else
    {
        textLabel = (RTLabel*)[cell.contentView viewWithTag: CELLTEXTVIEW];
        verseLabel = (UILabel*)[cell.contentView viewWithTag: CELLLABELVIEW];
    }

    VerseEntry * entry = [searchData objectAtIndex:[indexPath row]];
    verseLabel.text = [NSString stringWithFormat:@"%@ %d:%@", entry.book, entry.chapter,entry.verses ];
    [textLabel setText:[NSString stringWithFormat:@"%@", entry.text ]];
     
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

#pragma mark - searchDisplayControllerDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

	[searchData release];
	searchData = [BibleDataBaseController searchString:[searchBar.text UTF8String]];
	[searchBar resignFirstResponder];
	[self.tableView reloadData];
}

- (void)dealloc {
    [searchData release];
    [super dealloc];
}


@end




