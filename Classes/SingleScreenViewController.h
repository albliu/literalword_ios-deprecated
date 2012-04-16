#import "BibleViewController.h"
#import "VersesDataBase/VersesDataBase.h"
#import "ViewControllers/ViewControllers.h"
#import "NotesUtils/NotesUtils.h"

@interface SingleScreenViewController: UIViewController <BibleViewDelegate> {
	BibleViewController * _bibleView;
	SearchViewController * _searchView;

	NotesData * notes;
	HistoryData * history;
	BookmarkData * bookmarks;
	MemoryVersesData * memory;

}

@property (nonatomic, retain) BibleViewController * bibleView;
@property (nonatomic, retain) SearchViewController * searchView;

@end

