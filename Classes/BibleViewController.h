#import "BibleUtils/BibleUtils.h"
#import "UIUtils/UIUtils.h"
#import "MyGestureRecognizer.h"

#define SHEET_BLUE colorWithRed:0.21 green:0.39 blue:0.545 alpha:1.0
#define WEBVIEW_MIN_SCALE 0.5 
#define WEBVIEW_MAX_SCALE 3.0

@interface BibleViewController: UIViewController <UIWebViewDelegate> {
	int curr_book;
	int curr_chapter;
	HistoryViewController *_history;
	MyGestureRecognizer *_gestures;
	BibleDataBaseController *_bibleDB;
	BibleHtmlGenerator *_bibleHtml;
	PassageSelector * _selectMenu;
	UIWebView *_webView;
	UIButton *_passage;
	UIBarButtonItem *_hlaction;
	CGFloat _fontscale;
}

@property (nonatomic, retain) HistoryViewController *history;
@property (nonatomic, retain) MyGestureRecognizer *gestures;
@property (nonatomic, retain) BibleDataBaseController *bibleDB;
@property (nonatomic, retain) BibleHtmlGenerator *bibleHtml;
@property (nonatomic, retain) PassageSelector * selectMenu;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIButton *passage;
@property (nonatomic, retain) UIBarButtonItem *hlaction;
@property (nonatomic, assign) CGFloat fontscale;

- (void) nextPassage;
- (void) prevPassage;
- (void) selectedbook:(int) bk chapter:(int) ch;

- (void) changeFontSize:(CGFloat) scale; 
- (void) loadPassage;
- (void) clearhighlights;
- (void) highlightX:(float) x Y:(float) y;

- (void) showMainView;
@end
