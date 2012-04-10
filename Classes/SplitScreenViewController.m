#import "SplitScreenViewController.h"
#import "BibleUtils/BibleUtils.h"
#import <ViewControllers/ViewControllers.h>

@implementation SplitScreenViewController

@synthesize bibleView=_bibleView;
@synthesize secbibleView=_secbibleView;



-(BibleViewController *) bibleView{
	if (!_bibleView) {
		_bibleView = [[BibleViewController alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/2, self.view.bounds.size.height)];
		_bibleView.myDelegate = self;
	}
	return _bibleView;
}

-(BibleViewController *) secbibleView{
	if (!_secbibleView) {
		_secbibleView = [[BibleViewController alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 0, self.view.bounds.size.width/2, self.view.bounds.size.height)];
		_secbibleView.myDelegate = self;
	}
	return _secbibleView;
}

- (id) init {

	history = [[HistoryData alloc] init];
	bookmarks = [[BookmarkData alloc] init];
	memory = [[MemoryVersesData alloc] init];

	return [super init];
}	

- (void)loadView {

	[super loadView];
	split = YES;
	[self.view addSubview:self.bibleView.view];
	self.bibleView.view.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self.view addSubview:self.secbibleView.view];
	self.secbibleView.view.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

- (void) setUpToolBar {

	self.navigationController.navigationBar.tintColor = [UIColor SHEET_BLUE ];



	// Show 4 buttons

	UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 44.01f)];
	tools.clearsContextBeforeDrawing = NO;
	tools.clipsToBounds = NO;
	tools.barStyle = -1;
	tools.autoresizingMask = (UIViewAutoresizingFlexibleHeight);	

	NSMutableArray * toolbarItems = [[NSMutableArray alloc] initWithCapacity:1];

	UIBarButtonItem *myhistory = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"history.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showhistory:)];
	myhistory.width = 35.0f;
	[toolbarItems addObject:myhistory];
	[myhistory release];

	UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark:)];
	bookmark.width = 35.0f;
	[toolbarItems addObject:bookmark];
	[bookmark release];

	UIBarButtonItem *memoryverse = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"memory.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(memverse:)];
	memoryverse.width = 35.0f;
	[toolbarItems addObject:memoryverse];
	[memoryverse release];
	
	UIBarButtonItem *fullscreen = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(fullscreen:)];
	fullscreen.style = UIBarButtonItemStyleBordered;
	fullscreen.width = 35.0f;
	[toolbarItems addObject:fullscreen];
	[fullscreen release];

	UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(search:)];
	search.width = 35.0f;
	[toolbarItems addObject:search];
	[search release];


	UIBarButtonItem *notes = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(notes:)];
	notes.style = UIBarButtonItemStyleBordered;
	notes.width = 35.0f;
	[toolbarItems addObject:notes];
	[notes release];


	[tools setItems:toolbarItems animated:NO]; 
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

-(void) viewDidLoad {
	[super viewDidLoad];


	[self setUpToolBar];
}

- (void)dealloc {
	[history release]; 
	[bookmarks release];
	[memory release];
	[self.bibleView release];	
	[self.secbibleView release];	
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

}

- (void) search:(id)ignored {
	[self hideToolBar:YES];

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}

- (void) showhistory:(id)ignored {
	[self hideToolBar:YES];

	HistoryViewController * historyView = [[HistoryViewController alloc] initWithDelegate: self.bibleView Data:history] ;
	historyView.title = @"History"; 
	[self.navigationController pushViewController:historyView animated:YES];

}
- (void) notes:(id)ignored {
	[self hideToolBar:YES];

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}
- (void) fullscreen:(id)ignored {
	[self hideToolBar:YES];

	if (split) {
		self.bibleView.view.frame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
		self.secbibleView.view.hidden = YES;
		self.secbibleView.passageTitle.hidden = YES;
		split = NO;
	} else {
		self.bibleView.view.frame = CGRectMake(0,0, self.view.bounds.size.width/2, self.view.bounds.size.height);
		self.secbibleView.view.hidden = NO;
		self.secbibleView.passageTitle.hidden = NO;

		split = YES;
	}

}

- (void) memverse:(id)ignored {
	[self hideToolBar:YES];

	VersesViewController * myView = [[VersesViewController alloc] initWithDelegate:self.bibleView Data:memory] ;
	myView.title = @"Memory Verses"; 
	[self.navigationController pushViewController:myView animated:YES];

}


#pragma mark UIViewController delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}


@end

