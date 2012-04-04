#import "VersesDataBase/HistoryData.h"

@interface HistoryViewController: UITableViewController {
	HistoryData * _myData;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) HistoryData * myData;

- (id) initWithDelegate:(id) bibleView Data:(HistoryData *) data;
@end
