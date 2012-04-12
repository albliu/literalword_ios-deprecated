#import "SplitScreenViewController.h"
#import "BibleUtils/BibleUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation SplitScreenViewController

@synthesize bibleView=_bibleView;
@synthesize secbibleView=_secbibleView;
@synthesize searchView=_searchView;

-(SearchViewController *) searchView {

	if (!_searchView) {
		_searchView = [[SearchViewController alloc] initWithDelegate: self.bibleView Data:nil];
		_searchView.title = @"Search"; 
	}
	return _searchView;

}

-(BibleViewController *) bibleView{
	if (!_bibleView) {
		_bibleView = [[BibleViewController alloc] initWithFrame:CGRectMake(BORDER_OFFSET,0, self.view.bounds.size.width/2 - 2*BORDER_OFFSET, self.view.bounds.size.height)];
		_bibleView.myDelegate = self;
	}
	return _bibleView;
}

-(BibleViewController *) secbibleView{
	if (!_secbibleView) {
		_secbibleView = [[BibleViewController alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 + BORDER_OFFSET, 0, self.view.bounds.size.width/2 - 2 * BORDER_OFFSET, self.view.bounds.size.height)];
		_secbibleView.myDelegate = self;
	}
	return _secbibleView;
}


- (void) setUpToolBar {

	self.navigationController.navigationBar.tintColor = [UIColor SHEET_BLUE ];



	// Show 4 buttons

	UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 240.0f, 44.01f)];
	tools.clearsContextBeforeDrawing = NO;
	tools.clipsToBounds = NO;
	tools.barStyle = -1;
	tools.autoresizingMask = (UIViewAutoresizingFlexibleHeight);	

	NSMutableArray * toolbarItems = [[NSMutableArray alloc] initWithCapacity:1];

	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[toolbarItems addObject:flex];
	[flex release];

	UIBarButtonItem *myhistory = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"history.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showhistory:)];
	myhistory.width = 35.0f;
	[toolbarItems addObject:myhistory];
	[myhistory release];

	UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark:)];
	bookmark.width = 35.0f;
	[toolbarItems addObject:bookmark];
	[bookmark release];

	UIBarButtonItem *memoryverse = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"memory.png"] style:UIBarButtonItemStylePlain target:self action:@selector(memverse:)];
	memoryverse.width = 35.0f;
	[toolbarItems addObject:memoryverse];
	[memoryverse release];
	
	UIBarButtonItem *fullscreen = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"split.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fullscreen:)];
	fullscreen.width = 35.0f;
	[toolbarItems addObject:fullscreen];
	[fullscreen release];

	UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(search:)];
	search.width = 35.0f;
	[toolbarItems addObject:search];
	[search release];


	UIBarButtonItem *notes = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit.png"] style:UIBarButtonItemStylePlain target:self action:@selector(notes:)];
	notes.width = 35.0f;
	[toolbarItems addObject:notes];
	[notes release];

	flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[toolbarItems addObject:flex];
	[flex release];

	[tools setItems:toolbarItems animated:NO]; 
	[tools sizeToFit];
	[toolbarItems release];

	self.navigationItem.titleView = tools;
	[tools release];
	
	UIBarButtonItem *leftButtons = [[UIBarButtonItem alloc] initWithCustomView:self.bibleView.passageTitle];
	self.navigationItem.leftBarButtonItem = leftButtons;
	[leftButtons release];


	UIBarButtonItem *rightButtons = [[UIBarButtonItem alloc] initWithCustomView:self.secbibleView.passageTitle];
	self.navigationItem.rightBarButtonItem = rightButtons;
	[rightButtons release];


}


#pragma mark Navigation Bar functions

-(void) allowNavigationController:(BOOL) b {
	if (b) 
		self.navigationController.navigationBar.userInteractionEnabled = YES;
	else
		self.navigationController.navigationBar.userInteractionEnabled = NO;

}

#pragma mark BibleView Delegates

- (VerseEntry *) initPassage {
	return [history lastPassage];

}
- (void) addToHist:(int) book Chapter:(int) chapter {
	[history addToHistory:book Chapter:chapter];
}

- (void) addToMem:(int) book Chapter:(int) chapter Verses:(NSArray *) ver Text:(NSString *) txt {
	[memory addToMemoryVerses:book Chapter:chapter Verses:ver Text:txt];   

}

- (void) addToBmarks:(int) book Chapter:(int) chapter Verses:(NSArray *) ver {
	[bookmarks addToBookmarks:book Chapter:chapter Verses:ver Text:nil];   
}

- (void) lockScreen {
	[self allowNavigationController:NO];
}

- (void) unLockScreen{
	[self allowNavigationController:YES];
}
#pragma mark - Button Actions

- (void) bookmark:(id)ignored {

	BookmarkViewController * myView = [[BookmarkViewController alloc] initWithDelegate: self.bibleView Data:bookmarks] ;
	myView.title = @"Bookmarks"; 
	[self.navigationController pushViewController:myView animated:YES];
	[myView release];
}

- (void) search:(id)ignored {

	[self.navigationController pushViewController:self.searchView animated:YES];

}

- (void) showhistory:(id)ignored {

	HistoryViewController * historyView = [[HistoryViewController alloc] initWithDelegate: self.bibleView Data:history] ;
	historyView.title = @"History"; 
	[self.navigationController pushViewController:historyView animated:YES];
	[historyView release];

}
- (void) notes:(id)ignored {

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}
- (void) fullscreen:(id)ignored {

	
	if (split) {
		
		self.bibleView.view.frame = CGRectMake(BORDER_OFFSET, 0, self.view.bounds.size.width - 2 * BORDER_OFFSET, self.view.bounds.size.height);
		self.secbibleView.view.hidden = YES;
		self.secbibleView.passageTitle.hidden = YES;
		split = NO;
	} else {
		self.bibleView.view.frame = CGRectMake(BORDER_OFFSET, 0, self.view.bounds.size.width/2 - 2 * BORDER_OFFSET, self.view.bounds.size.height);
		self.secbibleView.view.hidden = NO;
		self.secbibleView.passageTitle.hidden = NO;

		split = YES;
	
	}

}

- (void) memverse:(id)ignored {

	VersesViewController * myView = [[VersesViewController alloc] initWithDelegate:self.bibleView Data:memory] ;
	myView.title = @"Memory Verses"; 
	[self.navigationController pushViewController:myView animated:YES];
	[myView release];

}


#pragma mark UIViewController delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}

- (id) init {

	history = [[HistoryData alloc] init];
	bookmarks = [[BookmarkData alloc] init];
	memory = [[MemoryVersesData alloc] init];

	return [super init];
}	

- (void)loadView {

	[super loadView];

	self.view.backgroundColor = [UIColor SHEET_BLUE];

	[self.view addSubview:self.bibleView.view];
	self.bibleView.view.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self.bibleView.view.layer setCornerRadius:8.0f];
	[self.bibleView.view.layer setMasksToBounds:YES];


	[self.view addSubview:self.secbibleView.view];
	self.secbibleView.view.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self.secbibleView.view.layer setCornerRadius:8.0f];
	[self.secbibleView.view.layer setMasksToBounds:YES];
}
-(void) viewDidLoad {
	[super viewDidLoad];

	split = YES;
	[self fullscreen:nil];
	[self setUpToolBar];
}

- (void)dealloc {
	[history release]; 
	[bookmarks release];
	[memory release];
	[self.bibleView release];	
	[self.secbibleView release];	
	[self.searchView release];	
	[super dealloc];
}


@end

