#import "BibleViewController.h"
#import "VersesDataBase/VersesDataBase.h"


#define BORDER_OFFSET 2
@interface SplitScreenViewController: UIViewController <BibleViewDelegate> {
	BibleViewController * _bibleView;
	BibleViewController * _secbibleView;


	HistoryData * history;
	BookmarkData * bookmarks;
	MemoryVersesData * memory;

	BOOL split;
}

@property (nonatomic, retain) BibleViewController * bibleView;
@property (nonatomic, retain) BibleViewController * secbibleView;

@end

