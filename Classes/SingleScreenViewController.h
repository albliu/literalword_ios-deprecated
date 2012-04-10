#import "BibleViewController.h"
#import "VersesDataBase/VersesDataBase.h"

@interface SingleScreenViewController: UIViewController <BibleViewDelegate> {
	BibleViewController * _bibleView;


	HistoryData * history;
	BookmarkData * bookmarks;
	MemoryVersesData * memory;

}

@property (nonatomic, retain) BibleViewController * bibleView;

@end

