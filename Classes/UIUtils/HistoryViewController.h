#define HISTORY_MAX 30

@interface HistoryViewController: UITableViewController {
}
@property (nonatomic, retain) NSMutableArray * myHistory;
@property (nonatomic, assign) id delegate;

- (id) initWithDelegate:(id) bibleView;
-(void) addToHistory:(NSString *) bookname Book:(int) book Chapter:(int) chap;

@end
