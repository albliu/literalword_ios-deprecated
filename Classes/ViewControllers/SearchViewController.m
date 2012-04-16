#import "SearchViewController.h"
#import "BibleViewController.h"



@implementation SearchViewController

int loadedCount;
int currRotation;

- (NSString *) formatResultText : (NSString *) txt {
    
	txt = [txt stringByReplacingOccurrencesOfString:@"<fn>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</fn>" withString:@"-->"];
	txt = [txt stringByReplacingOccurrencesOfString:@"<h1>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</h1>" withString:@"-->"];
	txt = [txt stringByReplacingOccurrencesOfString:@"<vn>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</vn>" withString:@"-->"];
	txt = [txt stringByReplacingOccurrencesOfString:@"<sv>" withString:@"<!--"];
	txt = [txt stringByReplacingOccurrencesOfString:@"</sv>" withString:@"-->"];
    txt = [txt stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""];
	
	NSScanner *scanner = nil; 
	NSString *text = nil;
	scanner = [NSScanner scannerWithString:txt];
    
	// get rid of comments first
	while (![scanner isAtEnd]) 
	{
		[scanner scanUpToString:@"<!--" intoString:NULL];
		[scanner scanUpToString:@"-->" intoString:&text];
		txt = [txt stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@-->", text] withString:@""];
        
	}
	
	scanner = nil;
	text = nil;
	// restart scanner
	scanner = [NSScanner scannerWithString:txt];
	
    
	while (![scanner isAtEnd])
    {
		[scanner scanUpToString:@"<" intoString:NULL];
		[scanner scanUpToString:@">" intoString:&text];
        txt = [txt stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];	
    }
  
    
	return txt;
}




#pragma mark - View lifecycle
- (void) loadView {
	[super loadView];
    currRotation = 0;
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
    
    self.tableView.rowHeight = (VERSE_LABEL_HEIGHT + VERSE_TEXT_HEIGHT + 2*CELL_SPACING);
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
    
    NSLog(@"text: %@", entry.text);
	if (entry != nil) {
		[self.delegate selectedbook:entry.book_index chapter:entry.chapter 
						verse:[entry.verses intValue] highlights:[NSArray arrayWithObject:entry.verses]];
	}

	[self.navigationController popToRootViewControllerAnimated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString* CellIdentifier = @"resultCell";
    UILabel * textLabel = nil;
    UILabel* verseLabel = nil;
    
    
    //NSLog(@"drawing cell : %d", indexPath.row);
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil ) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
                                       reuseIdentifier: CellIdentifier] autorelease];
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.width - CELL_SPACING, VERSE_TEXT_HEIGHT)]; 
        textLabel.tag = CELLTEXTVIEW;
        textLabel.font = [UIFont systemFontOfSize:VERSE_TEXT_FONT_SIZE];
        //textLabel.lineBreakMode = UILineBreakModeWordWrap;
        textLabel.numberOfLines = 2;
        [cell.contentView addSubview: textLabel];
        [textLabel release];
        
        verseLabel = [[[UILabel alloc] initWithFrame: CGRectMake( CELL_SPACING, CELL_SPACING, self.view.frame.size.width - CELL_SPACING, VERSE_LABEL_HEIGHT )] autorelease];
        verseLabel.tag = CELLLABELVIEW; 
        verseLabel.font = [UIFont boldSystemFontOfSize: VERSE_LABEL_FONT_SIZE];
        verseLabel.textAlignment = UITextAlignmentLeft;
        verseLabel.textColor = [UIColor darkTextColor];
        verseLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview: verseLabel];
    }
    else
    {
        textLabel = (UILabel*)[cell.contentView viewWithTag: CELLTEXTVIEW];
        verseLabel = (UILabel*)[cell.contentView viewWithTag: CELLLABELVIEW];
    }
    
    
    VerseEntry * entry = [searchResults objectAtIndex:[indexPath row]];
    verseLabel.text = [NSString stringWithFormat:@"%@ %d:%@", entry.book, entry.chapter,entry.verses ];
    textLabel.text = [self formatResultText:entry.text];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [searchResults count];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    searchResults = [BibleDataBaseController searchString:[searchBar.text UTF8String]];
	[searchBar resignFirstResponder];
  
    [self.tableView reloadData];

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
    searchResults = nil;
	[self.tableView reloadData];
}


/*
 @interface SearchViewController() 
 - (void) refreshThread;
 @end
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 
 return [searchData count];
 }
 
 -(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
 
 if (currRotation == 0) currRotation = 1;
 else currRotation = 0;
 
 [self.tableView reloadData];
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {    
 NSString* CellIdentifier;
 RTLabel * textLabel = nil;
 UILabel* verseLabel = nil;
 
 if (currRotation == 0) CellIdentifier = @"currRotationCell";
 else CellIdentifier= @"rotatedCell";
 
 //NSLog(@"drawing cell : %d", indexPath.row);
 UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
 if ( cell == nil ) 
 {
 cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
 reuseIdentifier: CellIdentifier] autorelease];
 if (currRotation == 0)
 textLabel = [[RTLabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.width - CELL_SPACING, 100)];
 else 
 textLabel = [[RTLabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.height - CELL_SPACING, 100)]; 
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
 NSArray * curr = [searchData objectAtIndex:[indexPath row]];
 NSValue * entry = [curr objectAtIndex:currRotation];
 CGSize optimumSize = [entry CGSizeValue];
 
 //NSLog(@"height cell[%d] : %f (rotation %d)", indexPath.row, optimumSize.height, currRotation);    
 return optimumSize.height + VERSE_LABEL_HEIGHT + 2 * CELL_SPACING;
 
 }
 
 - (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
 CGPoint offset = aScrollView.contentOffset;
 CGRect bounds = aScrollView.bounds;
 CGSize size = aScrollView.contentSize;
 UIEdgeInsets inset = aScrollView.contentInset;
 float y = offset.y + bounds.size.height - inset.bottom;
 float h = size.height;
 
 float reload_distance = 10;
 if(y > h + reload_distance) {
 [self refreshThread];
 }
 }
 #pragma mark - searchDisplayControllerDelegate
 
 // this function is mainly for height calculating
 
 - (void) refreshThread {
 
 
 NSMutableArray * inserts = [[NSMutableArray alloc] initWithCapacity:1];
 [myLoading startAnimating];
 while (1) {
 if (loadedCount == [searchResults count]) return;
 
 // add new index path
 NSIndexPath * newPath = [NSIndexPath indexPathForRow:loadedCount inSection:0];
 [inserts addObject:newPath];
 
 //figure out cell widths 
 
 VerseEntry * entry = [searchResults objectAtIndex:loadedCount];
 
 RTLabel * rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.width - CELL_SPACING, 100)];
 [rtLabel setText:entry.text];
 NSValue * curr = [NSValue valueWithCGSize:[rtLabel optimumSize]];
 [rtLabel release];
 
 rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.height - CELL_SPACING, 100)];
 [rtLabel setText:entry.text];   
 NSValue * rotate = [NSValue valueWithCGSize:[rtLabel optimumSize]];
 [rtLabel release];
 
 NSArray * heights = [NSArray arrayWithObjects:curr,rotate, nil];
 [searchData addObject: heights];
 
 if (++loadedCount % LOAD_REFRESH_RATE == 0) break;
 
 }	
 
 [self.tableView beginUpdates];
 [self.tableView insertRowsAtIndexPaths:inserts withRowAnimation:UITableViewRowAnimationNone];
 [self.tableView endUpdates];
 //[self.tableView reloadData];
 [myLoading stopAnimating];
 }
 
 -(void) refreshResults {
 
 [searchData release];
 searchData = [[NSMutableArray alloc] initWithCapacity:1];
 loadedCount = 0;
 [self refreshThread];
 //[NSThread detachNewThreadSelector:@selector(refreshThread) toTarget:self withObject:nil];  
 
 }

 {    
 NSString* CellIdentifier;
 RTLabel * textLabel = nil;
 UILabel* verseLabel = nil;
 
 if (currRotation == 0) CellIdentifier = @"currRotationCell";
 else CellIdentifier= @"rotatedCell";
 
 //NSLog(@"drawing cell : %d", indexPath.row);
 UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
 if ( cell == nil ) 
 {
 cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
 reuseIdentifier: CellIdentifier] autorelease];
 if (currRotation == 0)
 textLabel = [[RTLabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.width - CELL_SPACING, 100)];
 else 
 textLabel = [[RTLabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.height - CELL_SPACING, 100)]; 
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
 NSArray * curr = [searchData objectAtIndex:[indexPath row]];
 NSValue * entry = [curr objectAtIndex:currRotation];
 CGSize optimumSize = [entry CGSizeValue];
 
 //NSLog(@"height cell[%d] : %f (rotation %d)", indexPath.row, optimumSize.height, currRotation);    
 return optimumSize.height + VERSE_LABEL_HEIGHT + 2 * CELL_SPACING;
 
 }
 
 - (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
 CGPoint offset = aScrollView.contentOffset;
 CGRect bounds = aScrollView.bounds;
 CGSize size = aScrollView.contentSize;
 UIEdgeInsets inset = aScrollView.contentInset;
 float y = offset.y + bounds.size.height - inset.bottom;
 float h = size.height;
 
 float reload_distance = 10;
 if(y > h + reload_distance) {
 [self refreshThread];
 }
 }
 #pragma mark - searchDisplayControllerDelegate
 
 // this function is mainly for height calculating
 
 - (void) refreshThread {
 
 
 NSMutableArray * inserts = [[NSMutableArray alloc] initWithCapacity:1];
 [myLoading startAnimating];
 while (1) {
 if (loadedCount == [searchResults count]) return;
 
 // add new index path
 NSIndexPath * newPath = [NSIndexPath indexPathForRow:loadedCount inSection:0];
 [inserts addObject:newPath];
 
 //figure out cell widths 
 
 VerseEntry * entry = [searchResults objectAtIndex:loadedCount];
 
 RTLabel * rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.width - CELL_SPACING, 100)];
 [rtLabel setText:entry.text];
 NSValue * curr = [NSValue valueWithCGSize:[rtLabel optimumSize]];
 [rtLabel release];
 
 rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(CELL_SPACING, VERSE_LABEL_HEIGHT + CELL_SPACING, self.view.frame.size.height - CELL_SPACING, 100)];
 [rtLabel setText:entry.text];   
 NSValue * rotate = [NSValue valueWithCGSize:[rtLabel optimumSize]];
 [rtLabel release];
 
 NSArray * heights = [NSArray arrayWithObjects:curr,rotate, nil];
 [searchData addObject: heights];
 
 if (++loadedCount % LOAD_REFRESH_RATE == 0) break;
 
 }	
 
 [self.tableView beginUpdates];
 [self.tableView insertRowsAtIndexPaths:inserts withRowAnimation:UITableViewRowAnimationNone];
 [self.tableView endUpdates];
 //[self.tableView reloadData];
 [myLoading stopAnimating];
 }
 
 -(void) refreshResults {
 
 [searchData release];
 searchData = [[NSMutableArray alloc] initWithCapacity:1];
 loadedCount = 0;
 [self refreshThread];
 //[NSThread detachNewThreadSelector:@selector(refreshThread) toTarget:self withObject:nil];  
 
 }
*/

@end




