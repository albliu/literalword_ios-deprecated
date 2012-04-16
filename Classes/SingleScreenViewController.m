#import "SingleScreenViewController.h"
#import "BibleUtils/BibleUtils.h"

@implementation SingleScreenViewController

@synthesize bibleView=_bibleView;
@synthesize searchView=_searchView;
@synthesize notesView=_notesView;

-(SearchViewController *) searchView {

	if (!_searchView) {
		_searchView = [[SearchViewController alloc] initWithDelegate: self.bibleView Data:nil];
        //_searchView = [[SearchViewController2 alloc] init];
		_searchView.title = @"Search"; 
	}
	return _searchView;

}
-(BibleViewController *) bibleView{
	if (!_bibleView) {
		_bibleView = [[BibleViewController alloc] initWithFrame:self.view.bounds];
		_bibleView.myDelegate = self;
	}
	return _bibleView;
}
-(NotesViewController *) notesView {

	if (!_notesView) {
		_notesView = [[NotesViewController alloc] init];
		_notesView.title = @"Notes"; 
	}
	return _notesView;

}

- (id) init {

	history = [[HistoryData alloc] init];
	bookmarks = [[BookmarkData alloc] init];
	memory = [[MemoryVersesData alloc] init];

	return [super init];
}	

- (void)loadView {

	[super loadView];
	
	[self.view addSubview:self.bibleView.view];

}

- (void) setUpToolBar {

	NSMutableArray * toolbarItems = [[NSMutableArray alloc] initWithCapacity:1];
	UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(search:)];
	[toolbarItems addObject:search];
	[search release];


	UIBarButtonItem *notes = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(notes:)];
	notes.style = UIBarButtonItemStyleBordered;
	[toolbarItems addObject:notes];
	[notes release];

	UIBarButtonItem *memoryverse = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"memory.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(memverse:)];
	[toolbarItems addObject:memoryverse];
	[memoryverse release];
/*	

	UIBarButtonItem *fullscreen = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(fullscreen:)];
	fullscreen.style = UIBarButtonItemStyleBordered;
//	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
*/
	[self setToolbarItems:toolbarItems];
	[toolbarItems release];

	UIBarButtonItem *showToolbar = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showToolBar:)];
	self.navigationItem.rightBarButtonItem = showToolbar;
	[showToolbar release];


	// Show 2 buttons

	UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 44.01f)];
	tools.clearsContextBeforeDrawing = NO;
	tools.clipsToBounds = NO;
	tools.barStyle = -1;
	tools.autoresizingMask = (UIViewAutoresizingFlexibleHeight);	

	toolbarItems = [[NSMutableArray alloc] initWithCapacity:1];

	UIBarButtonItem *myhistory = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"history.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showhistory:)];
	myhistory.width = 30.0f;
	[toolbarItems addObject:myhistory];
	[myhistory release];

	UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark:)];
	bookmark.width = 30.0f;
	[toolbarItems addObject:bookmark];
	[bookmark release];

	[tools setItems:toolbarItems animated:NO]; 
	[toolbarItems release];
	
	UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
	[tools release];

	self.navigationItem.leftBarButtonItem = twoButtons;
	[twoButtons release];


	self.navigationController.navigationBar.tintColor = [UIColor SHEET_BLUE ];

	self.navigationItem.titleView = self.bibleView.passageTitle;

}

-(void) viewDidLoad {
	[super viewDidLoad];

	[self setUpToolBar];
}

- (void)dealloc {
	[history release]; 
	[bookmarks release];
	[memory release];
	[self.bibleView release];	
	[self.notesView release];	
	[self.searchView release];	
	[super dealloc];
}


#pragma mark Navigation Bar functions
-(void) hideToolBar:(BOOL) hide {
	if (hide) {
		[self.navigationController setToolbarHidden:YES];
		self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain ;
	} else {
		 [self.navigationController setToolbarHidden:NO];
		self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone ;

	}

}

-(void) showToolBar:(id)ignored {

	[self hideToolBar:!(self.navigationController.toolbarHidden)];
	
}

- (void) showMainView {

	[self hideToolBar:YES];
}


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
	[self showMainView];
	[self allowNavigationController:NO];
}

- (void) unLockScreen{
	[self allowNavigationController:YES];
}
#pragma mark - Button Actions

- (void) bookmark:(id)ignored {
	[self hideToolBar:YES];

	BookmarkViewController * myView = [[BookmarkViewController alloc] initWithDelegate: self.bibleView Data:bookmarks] ;
	myView.title = @"Bookmarks"; 
	[self.navigationController pushViewController:myView animated:YES];
	[myView release];

}

- (void) search:(id)ignored {
	[self hideToolBar:YES];

	[self.navigationController pushViewController:self.searchView animated:YES];

}

- (void) showhistory:(id)ignored {
	[self hideToolBar:YES];

	HistoryViewController * historyView = [[HistoryViewController alloc] initWithDelegate: self.bibleView Data:history] ;
	historyView.title = @"History"; 
	[self.navigationController pushViewController:historyView animated:YES];
	[historyView release];

}
- (void) notes:(id)ignored {
	[self hideToolBar:YES];

	[self.navigationController pushViewController:self.notesView animated:YES];

}
- (void) fullscreen:(id)ignored {
	[self hideToolBar:YES];

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}

- (void) memverse:(id)ignored {
	[self hideToolBar:YES];

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


@end

