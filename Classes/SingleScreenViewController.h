#import "BibleViewController.h"
#import "VersesDataBase/VersesDataBase.h"
#import <ViewControllers/ViewControllers.h>

@interface SingleScreenViewController: UIViewController <BibleViewDelegate> {
	BibleViewController * _bibleView;
	SearchViewController * _searchView;


	HistoryData * history;
	BookmarkData * bookmarks;
	MemoryVersesData * memory;

}

@property (nonatomic, retain) BibleViewController * bibleView;
@property (nonatomic, retain) SearchViewController * searchView;

@end

