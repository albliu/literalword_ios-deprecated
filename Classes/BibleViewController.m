#import "BibleViewController.h"

@implementation BibleViewController

@synthesize gestures=_gestures;
@synthesize bibleHtml=_bibleHtml;
@synthesize bibleDB=_bibleDB;
@synthesize webView=_webView;
@synthesize fontscale=_fontscale;
@synthesize passage=_passage;
@synthesize selectMenu=_selectMenu;


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


- (void) viewDidLoad {

	[super viewDidLoad];
	self.navigationController.navigationBar.tintColor = [UIColor SHEET_BLUE ];
	self.navigationItem.titleView = self.passage;
	/* toolbar */
	UIToolbar * leftButtons = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 70 ,40 )];
	leftButtons.barStyle = -1; // clear background

	UIToolbar * rightButtons = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
	rightButtons.barStyle = -1; // clear background

	NSMutableArray * lButtons = [[NSMutableArray alloc] initWithCapacity:2];
	NSMutableArray * rButtons = [[NSMutableArray alloc] initWithCapacity:2];

	UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
	search.style = UIBarButtonItemStyleBordered;
	UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmark:)];
	bookmark.style = UIBarButtonItemStyleBordered;
	UIBarButtonItem *notes = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(notes:)];
	notes.style = UIBarButtonItemStyleBordered;
	UIBarButtonItem *memoryverse = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(memverse:)];
	memoryverse.style = UIBarButtonItemStyleBordered;
//	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//	UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
/*
	UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(action:)];
	action.style = UIBarButtonItemStyleBordered;
	UIBarButtonItem *fullscreen = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(fullscreen:)];
	fullscreen.style = UIBarButtonItemStyleBordered;
	[lButtons addObject:action];
	[rButtons addObject:fullscreen];
*/

	[rButtons addObject:notes];
	[rButtons addObject:search];

	[lButtons addObject:memoryverse];
	[lButtons addObject:bookmark];

	[rightButtons setItems:rButtons animated:NO];
	[leftButtons setItems:lButtons animated:NO];

	[rButtons release];
	[lButtons release];

	UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:leftButtons];
	UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:rightButtons];
	[leftButtons release];
	[rightButtons release];
	
	self.navigationItem.rightBarButtonItem = right;
	self.navigationItem.leftBarButtonItem = left;
	[left release];
	[right release];


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
	NSLog(@"%d\n", [obj intValue]);
//	[[[[UIAlertView alloc] initWithTitle:jsString message:obj delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];


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

	NSString * jsString = [[NSString alloc] initWithFormat:@"clearhighlight();"];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString]; 
	[jsString release]; 


}

- (void) selectedbook:(int) bk chapter:(int) ch {
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
	[self.passage setTitle:[NSString stringWithFormat:@"%@ %d", name, curr_chapter] forState:UIControlStateNormal];
	[self.passage sizeToFit];

	
	[self.webView loadHTMLString:[self.bibleHtml loadHtmlBook:[name UTF8String] chapter:curr_chapter style:DEFAULT_VIEW] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void) showMainView {

	if (self.selectMenu.hidden == NO) [self.selectMenu hideSelector];	
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

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}

- (void) bookmark:(id)ignored {

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}
- (void) notes:(id)ignored {

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}
- (void) fullscreen:(id)ignored {

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}

- (void) memverse:(id)ignored {

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}
- (void) action:(id)ignored {

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s", __FUNCTION__] message:@"implement me" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

}
@end
