#import "BibleViewController.h"
#import "ViewControllers/ViewControllers.h"
#import "VersesDataBase/VersesDataBase.h"


#define BORDER_OFFSET 2
@interface SplitScreenViewController: UIViewController <BibleViewDelegate> {
	BibleViewController * _bibleView;
	BibleViewController * _secbibleView;
	SearchViewController * _searchView;
	NotesViewController * _notesView;

	HistoryData * history;
	BookmarkData * bookmarks;
	MemoryVersesData * memory;

}

@property (nonatomic, retain) BibleViewController * bibleView;
@property (nonatomic, retain) BibleViewController * secbibleView;
@property (nonatomic, retain) SearchViewController * searchView;
@property (nonatomic, retain) NotesViewController * notesView;

@end

