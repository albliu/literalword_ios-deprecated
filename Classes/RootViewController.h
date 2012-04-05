#import "BibleViewController.h"

@interface NavViewController: UINavigationController {
	BibleViewController * _bibleView;
}

@property (nonatomic, retain) BibleViewController *bibleView;

- (id) initRootView;
@end

