#import "SearchViewController.h"
#import "BibleViewController.h"


@implementation SearchViewController

#pragma mark - webview functions
- (NSString *) searchHTMLString : (NSString *) verse {

	NSString * ret =  [NSString stringWithFormat:@"<!DOCTYPE html><head>\
<link href=\"body.css\" rel=\"stylesheet\" type=\"text/css\" />\
<link href=\"literaray.css\" rel=\"stylesheet\" type=\"text/css\" />\
<style type=\"text/css\">body {-webkit-text-size-adjust:%d%%;}</style>\
</head><body>", SEARCH_RESULTS_FONT_SCALE];

	ret = [ret stringByAppendingString:verse];
	ret = [ret stringByAppendingString:[NSString stringWithUTF8String:"</body>"]];
	return ret;	
}



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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString* CellIdentifier = @"WebCell";
    UIWebView * webView = nil;
    UILabel* verseLabel = nil;

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil ) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
                                       reuseIdentifier: CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, VERSE_LABEL_HEIGHT, self.view.bounds.size.width, 44 - VERSE_LABEL_HEIGHT)];
	webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[webView setDelegate:self];
	webView.tag = CELLWEBVIEW;
        [cell.contentView addSubview: webView];
	[webView release];

        verseLabel = [[[UILabel alloc] initWithFrame: CGRectMake( 0, 0, self.view.bounds.size.width, VERSE_LABEL_HEIGHT )] autorelease];
        verseLabel.tag = CELLLABELVIEW; 
        verseLabel.font = [UIFont boldSystemFontOfSize: VERSE_LABEL_FONT_SIZE];
        verseLabel.textAlignment = UITextAlignmentLeft;
        verseLabel.textColor = [UIColor darkTextColor];
        verseLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        verseLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview: verseLabel];
    }
    else
    {
        webView = (UIWebView*)[cell.contentView viewWithTag: CELLWEBVIEW];
        verseLabel = (UILabel*)[cell.contentView viewWithTag: CELLLABELVIEW];
    }

    VerseEntry * entry = [searchData objectAtIndex:[indexPath row]];
    verseLabel.text = [NSString stringWithFormat:@"%@ %d:%@", entry.book, entry.chapter,entry.verses ];
    [webView loadHTMLString:[self searchHTMLString:entry.text] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]]; 
    return cell;
}
/*
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
*/

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
