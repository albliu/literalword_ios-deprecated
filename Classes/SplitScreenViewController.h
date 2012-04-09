#import "BibleViewController.h"
#import "VersesDataBase/VersesDataBase.h"

@interface SplitScreenViewController: UIViewController <BibleViewDelegate> {
	BibleViewController * _bibleView;
//	BibleViewController * _secBibleView;


	HistoryData * history;
	BookmarkData * bookmarks;
	MemoryVersesData * memory;

}

@property (nonatomic, retain) BibleViewController * bibleView;
//@property (nonatomic, retain) BibleViewController * secBibleView;

@end

