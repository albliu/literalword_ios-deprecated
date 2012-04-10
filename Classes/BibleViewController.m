#import "BibleViewController.h"

@implementation BibleViewController

@synthesize myDelegate;
@synthesize webView=_webView;
@synthesize fontscale=_fontscale;
@synthesize passageTitle = _passageTitle;


-(UIButton *) passageTitle {

	if (_passageTitle == nil) {
		_passageTitle = [UIButton buttonWithType:UIButtonTypeCustom ];
		[_passageTitle setTitle:@"LiteralWord" forState:UIControlStateNormal];
		[_passageTitle addTarget:self action:@selector(passagemenu:) forControlEvents:UIControlEventTouchUpInside];
		[_passageTitle sizeToFit];
	}	
	return _passageTitle;

}
-(UIWebView *) webView{
	if (_webView == nil) { 
		_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
		_webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		[_webView setDelegate:self];
	}
	return _webView;

}


- (CGFloat)fontscale
{
    if (!_fontscale) {
	CGFloat prev = [[NSUserDefaults standardUserDefaults] floatForKey:@SCALE_DEFAULT_TAG]; 
	if (prev != prev) 
		_fontscale = 1.0;
	else if (prev != 0)
		_fontscale = prev;
	else
		_fontscale = 1.0;
    } 
    return _fontscale;
}

- (void) setFontscale:(CGFloat) newscale {

	// check for nan
	if (newscale != newscale) return;

	_fontscale = (_fontscale < WEBVIEW_MIN_SCALE) ? WEBVIEW_MIN_SCALE : (_fontscale > WEBVIEW_MAX_SCALE ) ? WEBVIEW_MAX_SCALE : newscale;
	[[NSUserDefaults standardUserDefaults] setFloat:newscale forKey:@SCALE_DEFAULT_TAG];
}

- (id)initWithFrame:(CGRect) f {
	self = [self init];
	myFrame = f;
	if (self) {
		curr_book = 0;
		curr_chapter = 1;	
	}
	return self;
}

#pragma mark UIViewController delegate
/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // we support rotation in this view controller
    return YES;
}
*/

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

	return [obj componentsSeparatedByString: @"++"];


}

- (NSString *) gethighlighttexts {

	NSString *jsString = [[NSString alloc] initWithFormat:@"highlightedVersesText();"];
	NSString *obj = [self.webView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

	return obj;


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

	[[self myDelegate] addToHist:curr_book Chapter:curr_chapter];

	NSString * name = [BibleDataBaseController getBookNameAt:curr_book];
	[self.passageTitle setTitle:[NSString stringWithFormat:@"%@ %d", name, curr_chapter] forState:UIControlStateNormal];
	[self.passageTitle sizeToFit];

	hlaction.hidden = YES;

	[self.webView loadHTMLString:[BibleHtmlGenerator loadHtmlBookWithVerse:ver Highlights:hlights Book:[name UTF8String] chapter:curr_chapter scale: self.fontscale style:DEFAULT_VIEW] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void) loadPassage {
	[self loadPassageWithVerse:-1 Highlights:nil];

}

#pragma mark Selector Views

- (void) SelectorViewDismissed {
	[[self myDelegate] unLockScreen];

}

- (void)passagemenu:(id)ignored {
	NSLog(@"switch passage");

	[[self myDelegate] lockScreen];
	PassageSelector * selectMenu = [[PassageSelector alloc] initWithFrame: self.view.bounds RootView: self Book:curr_book Chapter:curr_chapter ]; 
	[self.view addSubview:selectMenu.view];

}

- (void) verseselector:(id) ignored {
	
	[[self myDelegate] lockScreen];
	VerseSelector * verseMenu = [[VerseSelector alloc] initWithFrame: self.view.bounds RootView:self Verses:[BibleDataBaseController getVerseCount:[[BibleDataBaseController getBookNameAt:curr_book] UTF8String] chapter:curr_chapter]]; 
	[self.view addSubview:verseMenu.view];

}

#pragma mark Button reactions


- (void) addbookmark:(id)ignored {
	NSLog(@"Added to bookmarks");

	NSString *jsString = [[NSString alloc] initWithFormat:@"getTopElement();"];
	NSString *obj = [self.webView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

	[[self myDelegate] addToBmarks:curr_book Chapter:curr_chapter Verses: [NSArray arrayWithObject:obj]];   
}


- (void) action:(id)ignored {

	[[[UIAlertView alloc] initWithTitle:nil message:nil delegate:self 
		cancelButtonTitle:@"Cancel" 
		otherButtonTitles:@ACTION_MEMORY, 
				@ACTION_CLEAR, nil] show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
     
	if([title isEqualToString:@ACTION_MEMORY])
	{
		NSLog(@"Added to memory verses");
		[[self myDelegate] addToMem:curr_book Chapter:curr_chapter Verses:[self gethighlights] Text:[self gethighlighttexts]];   
		[self clearhighlights];
	}
	else if([title isEqualToString:@ACTION_CLEAR])
	{
		[self clearhighlights];
	}
}

#pragma mark --
#pragma mark set up Views

-(UIButton *) hlactionbutton {
	UIButton * _hlaction = [UIButton buttonWithType:UIButtonTypeContactAdd];
	[_hlaction addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchDown];
	_hlaction.frame = CGRectMake(self.view.bounds.size.width - BUTTON_SIZE - BUTTON_OFFSET , self.view.bounds.size.height - BUTTON_SIZE - BUTTON_OFFSET, BUTTON_SIZE, BUTTON_SIZE);
	_hlaction.hidden = YES;
	_hlaction.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin) | (UIViewAutoresizingFlexibleTopMargin);	
	_hlaction.tag = HLACTIONBUTTON; 

	hlaction = _hlaction;

	return _hlaction;
}

-(UIButton *) bmbutton {
	UIButton * _bmaction = [UIButton buttonWithType:UIButtonTypeCustom];
	[_bmaction setImage:[UIImage imageNamed:@"addbookmark.png"] forState:UIControlStateNormal]; 
	[_bmaction addTarget:self action:@selector(addbookmark:) forControlEvents:UIControlEventTouchDown];
	_bmaction.frame = CGRectMake(self.view.bounds.size.width - BUTTON_SIZE - BUTTON_OFFSET , 0, BUTTON_SIZE, BUTTON_SIZE);
	_bmaction.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin) | (UIViewAutoresizingFlexibleBottomMargin); 
	_bmaction.tag = BOOKMARKBUTTON; 

	bmaction = _bmaction;

	return _bmaction;
}

- (void)loadView {

	[super loadView];

	self.view.frame = myFrame;	
		
	[self.view addSubview:self.webView];

	[self.view addSubview:[self hlactionbutton]];	
	[self.view addSubview:[self bmbutton]]; 
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

- (void) viewDidLoad {

	[super viewDidLoad];

	gestures = [[MyGestureRecognizer alloc] initWithDelegate:self View:self.webView];

	// load last passage
	VerseEntry * last = [[self myDelegate] initPassage];
	if (last) [self selectedbook:last.book_index chapter:last.chapter];
	else [self loadPassage];
}


- (void)dealloc {
	[self.webView release]; 
	[gestures release];
	[super dealloc];
}


@end
