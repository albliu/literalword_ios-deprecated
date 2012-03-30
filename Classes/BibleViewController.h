#import "BibleUtils/BibleUtils.h"
#import "UIUtils/UIUtils.h"

#define SHEET_BLUE colorWithRed:0.21 green:0.39 blue:0.545 alpha:1.0
#define WEBVIEW_MIN_SCALE 0.5 
#define WEBVIEW_MAX_SCALE 3.0

@interface BibleViewController: UIViewController <UIWebViewDelegate,UIGestureRecognizerDelegate,UIPickerViewDelegate> {
	int curr_book;
	int curr_chapter;
}

@property (nonatomic, retain) BibleDataBaseController *bibleDB;
@property (nonatomic, retain) BibleHtmlGenerator *bibleHtml;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIButton *passage;
@property (nonatomic, retain) UIPickerView *selectMenu;
@property (nonatomic, assign) CGFloat fontscale;
//- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
