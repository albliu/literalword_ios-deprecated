#import "BibleUtils/BibleUtils.h"
#import "UIUtils/UIUtils.h"
#import "VersesDataBase/VersesDataBase.h"
#import "MyGestureRecognizer.h"

#define SHEET_BLUE colorWithRed:0.0 green:0.0 blue:0.235 alpha:1.0
#define WEBVIEW_MIN_SCALE 0.5 
#define WEBVIEW_MAX_SCALE 3.0

#define ACTION_CLEAR "Clear Highlights"
#define ACTION_MEMORY "Add To Memory List"
#define ACTION_BOOKMARK "Add To Bookmarks"

@interface BibleViewController: UIViewController <UIWebViewDelegate, UIAlertViewDelegate> {
	int curr_book;
	int curr_chapter;
	HistoryData * history;
	BookmarkData * bookmarks;
	MemoryVersesData * memory;


	MyGestureRecognizer *_gestures;
	PassageSelector * _selectMenu;
	UIWebView *_webView;
	UIButton *_passage;
	UIButton *_hlaction;
	CGFloat _fontscale;
}

@property (nonatomic, retain) MyGestureRecognizer *gestures;
@property (nonatomic, retain) PassageSelector * selectMenu;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIButton *passage;
@property (nonatomic, retain) UIButton *hlaction;
@property (nonatomic, assign) CGFloat fontscale;

- (void) nextPassage;
- (void) prevPassage;
- (void) selectedbook:(int) bk chapter:(int) ch;
- (void) selectedbookname:(const char *) bk chapter:(int) ch;

- (void) changeFontSize:(CGFloat) scale; 
- (void) loadPassage;
- (void) clearhighlights;
- (void) highlightX:(float) x Y:(float) y;

- (void) showMainView;
@end
