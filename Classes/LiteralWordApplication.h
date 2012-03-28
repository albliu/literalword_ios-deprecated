#import "BibleViewController.h"

@interface NavViewController: UINavigationController {
}
@end

@interface LiteralWordApplication: NSObject <UIApplicationDelegate> {
	UIWindow *_window;
	NavViewController *_viewController;
	BibleViewController * _bibleView;
}
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) NavViewController* rootview; 
@property (nonatomic, retain) BibleViewController *bibleView;
@end

