#import "BibleViewController.h"
#import <ViewControllers/ViewControllers.h>

@implementation BibleViewController

@synthesize gestures=_gestures;
@synthesize webView=_webView;
@synthesize fontscale=_fontscale;
@synthesize passage=_passage;
@synthesize hlaction=_hlaction;
@synthesize selectMenu=_selectMenu;

-(UIButton *) hlaction {
	if (_hlaction == nil) {
		_hlaction = [UIButton buttonWithType:UIButtonTypeContactAdd];
		[_hlaction addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchDown];
		_hlaction.frame = CGRectMake(self.view.bounds.size.width - 55, self.view.bounds.size.height - 55, 50, 50);
		_hlaction.hidden = YES;
		_hlaction.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin) | (UIViewAutoresizingFlexibleTopMargin);	
	}
	return _hlaction;
}



-(MyGestureRecognizer *) gestures {
	if (_gestures == nil) {
		_gestures = [MyGestureRecognizer alloc];
	}
	return _gestures; 

}

-(PassageSelector *) selectMenu {
	if (_selectMenu == nil)  {
		_selectMenu = [[PassageSelector alloc] initWithViewWidth:self.view.bounds.size.width Delegate:self ];
		_hlaction.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin) | (UIViewAutoresizingFlexibleRightMargin);	
	}
	return _selectMenu;

}

-(UIWebView *) webView{
	if (_webView == nil) { 
		_webView = [[UIWebView alloc] initWithFrame:[self.view bounds]];
		_webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	}
	[_webView setDelegate:self];
	return _webView;

}

-(UIButton *) passage {

	if (_passage == nil) {
		_passage = [[UIButton alloc] initWithFrame:CGRectMake(0,0,100,30)];
		[_passage setTitle:@"LiteralWord" forState:UIControlStateNormal];
		[_passage addTarget:self action:@selector(passagemenu:) forControlEvents:UIControlEventTouchUpInside];
		[_passage sizeToFit];
	}
	return _passage;

}

- (CGFloat)fontscale
{
    if (!_fontscale) {
	_fontscale = 1.0;
    } 
    return _fontscale;
}

- (void) setFontscale:(CGFloat) newscale {

	_fontscale = (_fontscale < WEBVIEW_MIN_SCALE) ? WEBVIEW_MIN_SCALE : (_fontscale > WEBVIEW_MAX_SCALE ) ? WEBVIEW_MAX_SCALE : newscale;
}

- (id)init {
	self = [super init];
	if (self) {
		curr_book = 0;
		curr_chapter = 1;	
	}
	return self;
}


- (void)loadView {

	[super loadView];
	
		
	[self.view addSubview:self.webView];
	[self.view addSubview:self.selectMenu.selectMenu];
	[self.view addSubview:self.hlaction];	


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

	UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 44.01f)];
	tools.clearsContextBeforeDrawing = NO;
	tools.clipsToBounds = NO;
	tools.barStyle = -1;
	tools.autoresizingMask = (UIViewAutoresizingFlexibleHeight);	

	toolbarItems = [[NSMutableArray alloc] initWithCapacity:1];

	UIBarButtonItem *myhistory = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"history.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showhistory:)];
	myhistory.width = 35.0f;
	[toolbarItems addObject:myhistory];
	[myhistory release];

	UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark:)];
	bookmark.width = 35.0f;
	[toolbarItems addObject:bookmark];
	[bookmark release];

	[tools setItems:toolbarItems animated:NO]; 
	[toolbarItems release];
	
	UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
	[tools release];

	self.navigationItem.leftBarButtonItem = twoButtons;
	[twoButtons release];
}

- (void) viewDidLoad {

	[super viewDidLoad];

	history = [[HistoryData alloc] init];
	bookmarks = [[BookmarkData alloc] init];
	memory = [[MemoryVersesData alloc] init];

	self.navigationController.navigationBar.tintColor = [UIColor SHEET_BLUE ];
	self.navigationItem.titleView = self.passage;
	
	[self setUpToolBar];
	
	[self.gestures initWithDelegate:self View:self.webView];	

	// load last passage
	VerseEntry * last = [history lastPassage];
	if (last) [self selectedbook:last.book_index chapter:last.chapter];
	else [self loadPassage];
}


- (void)dealloc {
	[self.selectMenu release];	
	[self.webView release]; 
	[self.passage release]; 
	[history release]; 
	[super dealloc];
}

#pragma mark UIViewController delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}


#pragma mark bibleView Delegate

- (void) highlightX:(float) x Y:(float) y {
	NSString *jsString = [[NSString alloc] initWithFormat:@"highlightPoint(%f,%f);", x, y];
	NSString *obj = [self.webView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

	if ( [obj length ] != 0) {
		if ( [obj intValue] > 0) self.hlaction.hidden = NO;
		else if ( [obj intValue] == 0) self.hlaction.hidden = YES;
	}
}

- (void) nextPassage {
	int maxBook = [BibleDataBaseController maxBook];	
	int max = [[BibleDataBaseController getBookChapterCountAt:curr_book] intValue];
	if (curr_chapter >= max) {
		if (curr_book < maxBook ) {
			curr_chapter = 1;
			curr_book++;
		}
	} else curr_chapter++;
	[self loadPassage];


}

- (void) prevPassage {

	if (curr_chapter == 1) {
		if (curr_book > 0 ) {
			curr_book--;
			curr_chapter = [[BibleDataBaseController getBookChapterCountAt:curr_book] intValue];
		}
	} else curr_chapter--;

	[self loadPassage];


}

- (NSArray *) gethighlights {

	NSString *jsString = [[NSString alloc] initWithFormat:@"highlightedVerses();"];
	NSString *obj = [self.webView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

	return [obj componentsSeparatedByString: @":"];


}

- (void) clearhighlights {
	NSString *jsString = [[NSString alloc] initWithFormat:@"clearhighlight();"];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

	self.hlaction.hidden = YES;

}

- (void) selectedbook:(int) bk chapter:(int) ch  {
		//commit
		curr_book = bk;
		curr_chapter = ch;
		[self loadPassage];


}


-(void) changeFontSize:(CGFloat) scale;  {

	self.fontscale *= scale;
	NSUInteger textFontSize = (100 * self.fontscale);
	NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", textFontSize];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString];
	[jsString release];

}

- (void) loadPassage {

	[history addToHistory:curr_book Chapter:curr_chapter];

	NSString * name = [BibleDataBaseController getBookNameAt:curr_book];
	[self.passage setTitle:[NSString stringWithFormat:@"%@ %d", name, curr_chapter] forState:UIControlStateNormal];
	[self.passage sizeToFit];

	self.hlaction.hidden = YES;

	[self.webView loadHTMLString:[BibleHtmlGenerator loadHtmlBook:[name UTF8String] chapter:curr_chapter scale: self.fontscale style:DEFAULT_VIEW] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

  

#pragma mark -- rootView helpers
-(void) hideToolBar:(BOOL) hide {
	if (hide) {
		[self.navigationController setToolbarHidden:YES];
		self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain ;
	} else {
		 [self.navigationController setToolbarHidden:NO];
		self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone ;

	}

}

- (void) showMainView {

	if (self.selectMenu.hidden == NO) [self.selectMenu hideSelector];	

	[self hideToolBar:YES];
}

#pragma mark Button reactions

- (void)passagemenu:(id)ignored {
	NSLog(@"switch passage");

	if (self.selectMenu.hidden == YES) {
		[self.selectMenu showSelector:curr_book withChapter:curr_chapter];
	} else {
		[self.selectMenu hideSelector];
	}
}

- (void) search:(id)ignored {
	[self hideToolBar:YES];

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}

- (void) showhistory:(id)ignored {
	[self hideToolBar:YES];

	HistoryViewController * historyView = [[HistoryViewController alloc] initWithDelegate: self Data:history] ;
	historyView.title = @"History"; 
	[self.navigationController pushViewController:historyView animated:YES];

}
- (void) notes:(id)ignored {
	[self hideToolBar:YES];

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}
- (void) fullscreen:(id)ignored {
	[self hideToolBar:YES];

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}

- (void) memverse:(id)ignored {
	[self hideToolBar:YES];

	VersesViewController * myView = [[VersesViewController alloc] initWithDelegate: self Data:memory] ;
	myView.title = @"Memory Verses"; 
	[self.navigationController pushViewController:myView animated:YES];

}
- (void) bookmark:(id)ignored {
	[self hideToolBar:YES];

	VersesViewController * myView = [[VersesViewController alloc] initWithDelegate: self Data:bookmarks] ;
	myView.title = @"Bookmarks"; 
	[self.navigationController pushViewController:myView animated:YES];

}

- (void) action:(id)ignored {
	[self hideToolBar:YES];

	[[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self 
		cancelButtonTitle:@"Cancel" 
		otherButtonTitles:@ACTION_MEMORY, @ACTION_BOOKMARK, @ACTION_CLEAR, nil] show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
     
	if([title isEqualToString:@ACTION_MEMORY])
	{
		NSLog(@"Added to memory verses");
		[memory addToMemoryVerses:curr_book Chapter:curr_chapter Verses:[self gethighlights] Text:nil];   
		[self clearhighlights];
	}
	else if([title isEqualToString:@ACTION_BOOKMARK])
	{
		NSLog(@"Added to bookmarks");
		[bookmarks addToBookmarks:curr_book Chapter:curr_chapter Verses:[self gethighlights] Text:nil];   
		[self clearhighlights];
	}	
	else if([title isEqualToString:@ACTION_CLEAR])
	{
		[self clearhighlights];
	}
}

-(void) showToolBar:(id)ignored {

	[self hideToolBar:!(self.navigationController.toolbarHidden)];
	
}

@end
