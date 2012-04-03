#import <BibleUtils/BibleUtils.h>

#define HISTORY_MAX 30

@interface HistoryViewController: UITableViewController {
	NSMutableArray * _myHistory;
	VersesDataBaseController * _myDB;
}
@property (nonatomic, copy) NSMutableArray * myHistory;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) VersesDataBaseController * myDB;

- (id) initWithDelegate:(id) bibleView;
-(void) addToHistory:(NSString *) bookname Book:(int) book Chapter:(int) chap;

@end
