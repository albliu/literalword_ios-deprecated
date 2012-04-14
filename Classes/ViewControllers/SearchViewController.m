#import "SearchViewController.h"
#import "BibleViewController.h"

@interface SearchViewController() 
- (void) refreshThread;
@end

@implementation SearchViewController

static int loadedCount;

- (NSString *) formatResultText : (NSString *) txt {
    
	txt = [txt stringByReplacingOccurrencesOfString:@"<fn>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</fn>" withString:@"-->"];
	txt = [txt stringByReplacingOccurrencesOfString:@"<h1>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</h1>" withString:@"-->"];
	txt = [txt stringByReplacingOccurrencesOfString:@"<vn>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</vn>" withString:@"-->"];
	txt = [txt stringByReplacingOccurrencesOfString:@"<sv>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</sv>" withString:@"-->"];
    
	return txt;
}




#pragma mark - View lifecycle
- (void) loadView {
	[super loadView];

	myLoading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

	myLoading.center = self.view.center;
	[self.view addSubview:myLoading];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    searchData = [[NSMutableArray alloc] initWithCapacity:1];
    loadedCount =0;
    UISearchBar * mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    mySearchBar.delegate = self;
    [mySearchBar becomeFirstResponder];
    
    self.tableView.tableHeaderView = mySearchBar;
    [mySearchBar release];


}

#pragma mark - Table view data source
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	VerseEntry * entry = [searchResults objectAtIndex:[indexPath row]];
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
    static NSString* CellIdentifier = @"ResultCell";
    RTLabel * textLabel = nil;
    UILabel* verseLabel = nil;

    NSLog(@"drawing cell : %d", indexPath.row);
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

    VerseEntry * entry = [searchResults objectAtIndex:[indexPath row]];
    verseLabel.text = [NSString stringWithFormat:@"%@ %d:%@", entry.book, entry.chapter,entry.verses ];
    [textLabel setText:[self formatResultText:entry.text]];
     
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSValue * entry = [searchData objectAtIndex:[indexPath row]];
	CGSize optimumSize = [entry CGSizeValue];
    
	NSLog(@"height cell[%d] : %f ", indexPath.row, optimumSize.height);    
	return optimumSize.height + VERSE_LABEL_HEIGHT + 2 * CELL_SPACING;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    // NSLog(@"offset: %f", offset.y);   
    // NSLog(@"content.height: %f", size.height);   
    // NSLog(@"bounds.height: %f", bounds.size.height);   
    // NSLog(@"inset.top: %f", inset.top);   
    // NSLog(@"inset.bottom: %f", inset.bottom);   
    // NSLog(@"pos: %f of %f", y, h);
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        [self refreshThread];
    }
}
#pragma mark - searchDisplayControllerDelegate

// this function is mainly for height calculating

- (void) refreshThread {
  
    [myLoading startAnimating];
    while (1) {
        if (loadedCount == [searchResults count]) return;
        VerseEntry * entry = [searchResults objectAtIndex:loadedCount];
        RTLabel * rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.width - CELL_SPACING, 100)];
        [rtLabel setText:entry.text];
        [searchData addObject: [NSValue valueWithCGSize:[rtLabel optimumSize]]];
        [rtLabel release];
        if (++loadedCount % LOAD_REFRESH_RATE == 0) break;
        
    }	
    [self.tableView reloadData];
    [myLoading stopAnimating];
}

-(void) refreshResults {

    [searchData release];
	searchData = [[NSMutableArray alloc] initWithCapacity:1];
    loadedCount = 0;
    [self refreshThread];
    //[NSThread detachNewThreadSelector:@selector(refreshThread) toTarget:self withObject:nil];  
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    searchResults = [BibleDataBaseController searchString:[searchBar.text UTF8String]];
	[searchBar resignFirstResponder];
  
    [self refreshResults];

}

- (void)dealloc {
    [searchData release];
    searchResults = nil;
    [myLoading release];
    [super dealloc];
}
- (void) clear:(id) ignored {
	UISearchBar * myBar = (UISearchBar *) self.tableView.tableHeaderView;
	myBar.text = nil;
	[searchData release];
    searchData = [[NSMutableArray alloc] init];
    searchResults = nil;
	[self.tableView reloadData];
}


@end




