#import "SelectorViewController.h"
#import "BibleViewController.h"

#define VERSES_TABLE_SHORT 200 
#define VERSES_TABLE_LONG 200
#define VERSES_CELL_SIDE 40
#define VERSES_TABLE_BORDER 5

@interface VerseSelector: SelectorViewController <UITableViewDelegate, UITableViewDataSource> {
	CGRect frame;
	int myHeight;
	int myWidth;
	int cols;
	int rows;
	int ver;
}

-(VerseSelector *) initWithRootView:(id) del Verses:(int) v;
@end
