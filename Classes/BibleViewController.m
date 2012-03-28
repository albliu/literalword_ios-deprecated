#import "BibleViewController.h"
#import "UIUtils/UIUtils.h"

@implementation BibleViewController

@synthesize bibleHtml=_bibleHtml;
@synthesize bibleDB=_bibleDB;
@synthesize webView=_webView;
@synthesize fontscale=_fontscale;

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
		curr_book = 18;
		curr_chapter = 1;	
	}
	return self;
}


- (void)loadView {

	[super loadView];

	
	[self.view addSubview:self.webView];
	

}

-(void) changeFontSize {

	NSUInteger textFontSize	= (100 * self.fontscale);
	NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", textFontSize];
	[self.webView stringByEvaluatingJavaScriptFromString:jsString];
	[jsString release];

}

- (void) loadPassage {
	NSString * name = [self.bibleDB getBookNameAt:curr_book];
	UINavbarButton * passage = [[UINavbarButton alloc] initWithTitle:[NSString stringWithFormat:@"%@ %d", name, curr_chapter] style:UIBarStyleDefault target:self action:@selector(passagemenu:)];
	self.navigationItem.titleView = passage;
	[passage release];
	[self.webView loadHTMLString:[self.bibleHtml loadHtmlBook:[name UTF8String] chapter:curr_chapter style:DEFAULT_VIEW] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void) viewDidLoad {

	[super viewDidLoad];

	/* toolbar */
	UIToolbar * leftButtons = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100 ,44 )];
	leftButtons.barStyle = -1; // clear background

	UIToolbar * rightButtons = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
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

	
	UIPinchGestureRecognizer *myPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
	myPinch.delegate = self;
	[self.webView addGestureRecognizer:myPinch];

	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(swipeRightAction:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	swipeRight.delegate = self;
	[self.webView addGestureRecognizer:swipeRight];
 
	UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	swipeLeft.delegate = self;
	[self.webView addGestureRecognizer:swipeLeft];
	[self loadPassage];
}


- (void)dealloc {
	[self.webView release];	
	[self.bibleDB release];	
	[self.bibleHtml release];	
	[super dealloc];
}

#pragma mark UIViewController delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}

/*#pragma mark UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self changeFontSize];

}
*/
#pragma mark Gestures

- (void)pinch:(UIPinchGestureRecognizer *)gesture {

	NSLog(@"Pinch");

	self.fontscale *= gesture.scale;
	gesture.scale = 1;
	[self changeFontSize];
}


- (void)swipeLeftAction:(id)ignored
{
	NSLog(@"Swipe Left");

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
 
- (void)swipeRightAction:(id)ignored
{
	NSLog(@"Swipe Right");
	if (curr_chapter == 1) {
		if (curr_book > 0 ) {
			curr_book--;
			curr_chapter = [[self.bibleDB getBookChapterCountAt:curr_book] intValue];
		}
	} else curr_chapter--;

	[self loadPassage];
}
#pragma mark GestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark Button reactions

- (void)passagemenu:(id)ignored {
	NSLog(@"switch passage");
	[[[[UIAlertView alloc] initWithTitle:@"Change Passage?" message:@"Do you really want to change the passage?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];

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
