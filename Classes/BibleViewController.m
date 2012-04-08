#import "BibleViewController.h"
#import <ViewControllers/ViewControllers.h>

@implementation BibleViewController

@synthesize webView=_webView;
@synthesize fontscale=_fontscale;

-(UIButton *) hlactionbutton {
	UIButton * _hlaction = [UIButton buttonWithType:UIButtonTypeContactAdd];
	[_hlaction addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchDown];
	_hlaction.frame = CGRectMake(self.view.bounds.size.width - BUTTON_SIZE - BUTTON_OFFSET , self.view.bounds.size.height - BUTTON_OFFSET, BUTTON_SIZE, BUTTON_SIZE);
	_hlaction.hidden = YES;
	_hlaction.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin) | (UIViewAutoresizingFlexibleTopMargin);	
	_hlaction.tag = HLACTIONBUTTON; 

	hlaction = _hlaction;

	return _hlaction;
}


-(UIWebView *) webView{
	if (_webView == nil) { 
		_webView = [[UIWebView alloc] initWithFrame:[self.view bounds]];
		_webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[_webView setDelegate:self];
	}
	return _webView;

}


- (CGFloat)fontscale
{
    if (!_fontscale) {
	CGFloat prev = [[NSUserDefaults standardUserDefaults] floatForKey:@SCALE_DEFAULT_TAG]; 
	if (prev != 0)
		_fontscale = prev;
	else
		_fontscale = 1.0;
    } 
    return _fontscale;
}

- (void) setFontscale:(CGFloat) newscale {

	_fontscale = (_fontscale < WEBVIEW_MIN_SCALE) ? WEBVIEW_MIN_SCALE : (_fontscale > WEBVIEW_MAX_SCALE ) ? WEBVIEW_MAX_SCALE : newscale;
	[[NSUserDefaults standardUserDefaults] setFloat:newscale forKey:@SCALE_DEFAULT_TAG];
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

	[self.view addSubview:[self hlactionbutton]];	
	// verse button
	UIButton * verse = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_OFFSET, self.view.bounds.size.height - BUTTON_SIZE - BUTTON_OFFSET, BUTTON_SIZE,BUTTON_SIZE)];
	[verse addTarget:self action:@selector(verseselector:) forControlEvents:UIControlEventTouchUpInside];
	[verse setImage:[UIImage imageNamed:@"verse.png"] forState:UIControlStateNormal]; 
	verse.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin) | (UIViewAutoresizingFlexibleTopMargin);	
	[self.view addSubview:verse];
	[verse release];	

	UIButton * leftpassage = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2 - TOUCH_HEIGHT, TOUCH_WIDTH, TOUCH_HEIGHT * 2)];
	[leftpassage addTarget:self action:@selector(prevPassage) forControlEvents:UIControlEventTouchUpInside];
	[leftpassage setBackgroundColor:[UIColor clearColor]];
	leftpassage.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin) | (UIViewAutoresizingFlexibleTopMargin) | (UIViewAutoresizingFlexibleBottomMargin);	 
	[self.view addSubview:leftpassage];
	[leftpassage release];	      


	UIButton * rightpassage = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - TOUCH_WIDTH, self.view.bounds.size.height/2 - TOUCH_HEIGHT, TOUCH_WIDTH, TOUCH_HEIGHT * 2)];
	[rightpassage addTarget:self action:@selector(nextPassage) forControlEvents:UIControlEventTouchUpInside];
	[rightpassage setBackgroundColor:[UIColor clearColor]];
	rightpassage.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin) | (UIViewAutoresizingFlexibleTopMargin) | (UIViewAutoresizingFlexibleBottomMargin);	 
	[self.view addSubview:rightpassage];
	[rightpassage release];        



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


	self.navigationController.navigationBar.tintColor = [UIColor SHEET_BLUE ];
	UIButton * _passage = [UIButton buttonWithType:UIButtonTypeCustom ];
	[_passage setTitle:@"LiteralWord" forState:UIControlStateNormal];
	[_passage addTarget:self action:@selector(passagemenu:) forControlEvents:UIControlEventTouchUpInside];
	[_passage sizeToFit];

	self.navigationItem.titleView = _passage;

}

- (void) viewDidLoad {

	[super viewDidLoad];

	history = [[HistoryData alloc] init];
	bookmarks = [[BookmarkData alloc] init];
	memory = [[MemoryVersesData alloc] init];

	
	[self setUpToolBar];
	
	gestures = [[MyGestureRecognizer alloc] initWithDelegate:self View:self.webView];

	// load last passage
	VerseEntry * last = [history lastPassage];
	if (last) [self selectedbook:last.book_index chapter:last.chapter];
	else [self loadPassage];
}


- (void)dealloc {
	[self.webView release]; 
	[history release]; 
	[bookmarks release];
	[memory release];
	[gestures release];
	[super dealloc];
}

#pragma mark UIViewController delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}


#pragma mark bibleView Delegate
- (void) gotoVerse:(int) v {
	NSString *jsString = [[NSString alloc] initWithFormat:@"jumpToElement('%d');", v];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

}

- (void) highlightX:(float) x Y:(float) y {
	NSString *jsString = [[NSString alloc] initWithFormat:@"highlightPoint(%f,%f);", x, y];
	NSString *obj = [self.webView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

	if ( [obj length ] != 0) {
		if ( [obj intValue] > 0) hlaction.hidden = NO;
		else if ( [obj intValue] == 0) hlaction.hidden = YES;
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

	hlaction.hidden = YES;

}

- (void) selectedbook:(int) bk chapter:(int) ch verse:(int) ver highlights:(NSArray *) hlights {

		curr_book = bk;
		curr_chapter = ch;
		[self loadPassageWithVerse:ver Highlights:hlights];
}

- (void) selectedbook:(int) bk chapter:(int) ch verse:(int) ver {
		[self selectedbook:bk chapter:ch verse: ver highlights:nil];

}


- (void) selectedbook:(int) bk chapter:(int) ch  {
		[self selectedbook:bk chapter:ch verse: -1];
}



-(void) changeFontSize:(CGFloat) scale;  {

	self.fontscale *= scale;
	NSUInteger textFontSize = (100 * self.fontscale);
	NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", textFontSize];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString];
	[jsString release];

}

- (void) loadPassageWithVerse:(int) ver Highlights:(NSArray *) hlights {

	[history addToHistory:curr_book Chapter:curr_chapter];

	NSString * name = [BibleDataBaseController getBookNameAt:curr_book];
	UIButton * passageTitle = (UIButton *) self.navigationItem.titleView;
	[passageTitle setTitle:[NSString stringWithFormat:@"%@ %d", name, curr_chapter] forState:UIControlStateNormal];

	hlaction.hidden = YES;

	[self.webView loadHTMLString:[BibleHtmlGenerator loadHtmlBookWithVerse:ver Highlights:hlights Book:[name UTF8String] chapter:curr_chapter scale: self.fontscale style:DEFAULT_VIEW] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void) loadPassage {
	[self loadPassageWithVerse:-1 Highlights:nil];

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



#pragma mark Button reactions

- (void)passagemenu:(id)ignored {
	NSLog(@"switch passage");

	PassageSelector * selectMenu = [[PassageSelector alloc] initWithFrame: self.view.bounds RootView: self Book:curr_book Chapter:curr_chapter ]; 
	[self.view addSubview:selectMenu.view];

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

	BookmarkViewController * myView = [[BookmarkViewController alloc] initWithDelegate: self Data:bookmarks] ;
	myView.title = @"Bookmarks"; 
	[self.navigationController pushViewController:myView animated:YES];

}
- (void) verseselector:(id) ignored {
	
	VerseSelector *	verseMenu = [[VerseSelector alloc] initWithFrame: self.view.bounds RootView:self Verses:[BibleDataBaseController getVerseCount:[[BibleDataBaseController getBookNameAt:curr_book] UTF8String] chapter:curr_chapter]]; 
	[self.view addSubview:verseMenu.view];
	// verseMenu will autorelease when we remove from SUper View, so we shoudln't release here

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

-(void) allowNavigationController:(BOOL) b {
	if (b) 
		self.navigationController.navigationBar.userInteractionEnabled = YES;
	else
		self.navigationController.navigationBar.userInteractionEnabled = NO;

}
- (void) showMainView {

	[self hideToolBar:YES];
}
@end
