#import "BibleViewController.h"


@implementation BibleViewController

@synthesize history=_history;
@synthesize gestures=_gestures;
@synthesize bibleHtml=_bibleHtml;
@synthesize bibleDB=_bibleDB;
@synthesize webView=_webView;
@synthesize fontscale=_fontscale;
@synthesize passage=_passage;
@synthesize hlaction=_hlaction;
@synthesize selectMenu=_selectMenu;

//function declaration

-(UIBarButtonItem *) hlaction {
	if (_hlaction == nil) {
		_hlaction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
		_hlaction.style = UIBarButtonItemStyleBordered;
	}
	return _hlaction;
}

-(HistoryViewController *) history {
	if (_history == nil) {
		_history = [[HistoryViewController alloc] initWithDelegate:self];
	}
	return _history;
}

-(MyGestureRecognizer *) gestures {
	if (_gestures == nil) {
		_gestures = [MyGestureRecognizer alloc];
	}
	return _gestures; 

}

-(PassageSelector *) selectMenu {
	if (_selectMenu == nil)  {
		_selectMenu = [[PassageSelector alloc] initWithViewWidth:self.view.bounds.size.width Delegate:self BibleDB:self.bibleDB];
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

-(BibleHtmlGenerator *) bibleHtml {

	if (_bibleHtml== nil) {
		 _bibleHtml = [[BibleHtmlGenerator alloc] initWithDB: self.bibleDB Scale:self.fontscale]; 
	
	}
	return _bibleHtml;


}

-(BibleDataBaseController *) bibleDB {

	if (_bibleDB == nil) {
		NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"nasb.db"];
		 _bibleDB = [[BibleDataBaseController alloc] initDataBase: [path UTF8String]];
	}

	return _bibleDB;


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
	[self.bibleHtml setScale:_fontscale];
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
	[self.view addSubview:self.selectMenu.view];
	

}

- (void) setUpToolBar {

	NSMutableArray * toolbarItems = [[NSMutableArray alloc] initWithCapacity:5];
	UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(search:)];
	[toolbarItems addObject:search];
	[search release];

	UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(bookmark:)];
	[toolbarItems addObject:bookmark];
	[bookmark release];

	UIBarButtonItem *notes = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(notes:)];
	notes.style = UIBarButtonItemStyleBordered;
	[toolbarItems addObject:notes];
	[notes release];

	UIBarButtonItem *history = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"history.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(history:)];
	[toolbarItems addObject:history];
	[history release];

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


}

- (void) viewDidLoad {

	[super viewDidLoad];
	self.navigationController.navigationBar.tintColor = [UIColor SHEET_BLUE ];
	self.navigationItem.titleView = self.passage;
	
	[self setUpToolBar];

	UIBarButtonItem *showToolbar = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showToolBar:)];
	self.navigationItem.leftBarButtonItem = showToolbar;
	[showToolbar release];

	
	//Action Button


	[self.gestures initWithDelegate:self View:self.webView];	

	[self loadPassage];
}


- (void)dealloc {
	[self.selectMenu release];	
	[self.webView release];	
	[self.bibleDB release];	
	[self.bibleHtml release];	
	[self.passage release];	
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
		if ( [obj intValue] > 0) self.navigationItem.rightBarButtonItem = self.hlaction;
		else if ( [obj intValue] == 0) self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void) nextPassage {
	int maxBook = [self.bibleDB maxBook];	
	int max = [[self.bibleDB getBookChapterCountAt:curr_book] intValue];
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
			curr_chapter = [[self.bibleDB getBookChapterCountAt:curr_book] intValue];
		}
	} else curr_chapter--;

	[self loadPassage];


}


- (void) clearhighlights {

	NSString *jsString = [[NSString alloc] initWithFormat:@"highlightedVerses();"];
	NSString *obj = [self.webView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];
	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:obj delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

	jsString = [[NSString alloc] initWithFormat:@"clearhighlight();"];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

	self.navigationItem.rightBarButtonItem = nil;
}

- (void) selectedbook:(int) bk chapter:(int) ch  {
		//commit
		curr_book = bk;
		curr_chapter = ch;
		[self loadPassage];


}

-(void) changeFontSize:(CGFloat) scale;  {

	self.fontscale *= scale;
	NSUInteger textFontSize	= (100 * self.fontscale);
	NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", textFontSize];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString];
	[jsString release];

}

- (void) loadPassage {

	NSString * name = [self.bibleDB getBookNameAt:curr_book];

	[self.history addToHistory:name Book:curr_book Chapter:curr_chapter];

	[self.passage setTitle:[NSString stringWithFormat:@"%@ %d", name, curr_chapter] forState:UIControlStateNormal];
	[self.passage sizeToFit];

	self.navigationItem.rightBarButtonItem = nil;
	
	[self.webView loadHTMLString:[self.bibleHtml loadHtmlBook:[name UTF8String] chapter:curr_chapter style:DEFAULT_VIEW] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

  

#pragma mark -- rootView helpers
-(void) hideToolBar:(BOOL) hide {
	if (hide) {
		[self.navigationController setToolbarHidden:YES];
		self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain ;
	} else {
		 [self.navigationController setToolbarHidden:NO];
		self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleDone ;

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

- (void) history:(id)ignored {
	[self hideToolBar:YES];

	[self.navigationController pushViewController:self.history animated:YES];

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

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}
- (void) bookmark:(id)ignored {
	[self hideToolBar:YES];
	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}

- (void) action:(id)ignored {
	[self hideToolBar:YES];

	[self clearhighlights];
}


-(void) showToolBar:(id)ignored {

	[self hideToolBar:!(self.navigationController.toolbarHidden)];
	
}

@end
