#import "BibleUtils/BibleUtils.h"
#import "UIUtils/UIUtils.h"
#import "MyGestureRecognizer.h"

#define SCALE_DEFAULT_TAG "myscale"

#define TOUCH_HEIGHT 100
#define TOUCH_WIDTH 50
#define SHEET_BLUE colorWithRed:0.0 green:0.0 blue:0.235 alpha:1.0
#define WEBVIEW_MIN_SCALE 0.5 
#define WEBVIEW_MAX_SCALE 3.0

#define BUTTON_SIZE 45 
#define BUTTON_OFFSET 5

#define ACTION_CLEAR "Clear Highlights"
#define ACTION_MEMORY "Add To Memory List"
#define ACTION_BOOKMARK "Add To Bookmarks"


enum {
	BIBLEWEBVIEW,
	HLACTIONBUTTON,
	BOOKMARKBUTTON,

};

@protocol BibleViewDelegate
- (VerseEntry *) initPassage;
- (void) addToHist:(int) book Chapter:(int) chapter;
- (void) addToMem:(int) book Chapter:(int) chapter Verses:(NSArray *) ver Text:(NSString *) txt;
- (void) addToBmarks:(int) book Chapter:(int) chapter Verses:(NSArray *) ver;
- (void) lockScreen;
- (void) unLockScreen;
@end


@interface BibleViewController: UIViewController <SelectorViewDelegate,UIWebViewDelegate, UIAlertViewDelegate> {
	int curr_book;
	int curr_chapter;
	float fontscale;
	CGRect myFrame;
	
	MyGestureRecognizer *gestures;

	id <BibleViewDelegate> myDelegate;
	UIWebView *_webView;
	UIButton * hlaction;
	UIButton * bmaction;
	UIButton * _passageTitle;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIButton * passageTitle;
@property (nonatomic, assign) id <BibleViewDelegate> myDelegate;

- (id)initWithFrame:(CGRect) f; 

- (void) nextPassage;
- (void) prevPassage;
- (void) selectedbook:(int) bk chapter:(int) ch verse:(int) ver; 
- (void) selectedbook:(int) bk chapter:(int) ch verse:(int) ver highlights:(NSArray *) hlights; 

- (void) changeFontSize:(float) scale; 
- (void) loadPassage;
- (void) loadPassageWithVerse:(int) ver Highlights:(NSArray *) hlights;
- (void) clearhighlights;
- (void) highlightX:(float) x Y:(float) y;

@end
