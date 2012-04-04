#import "VersesDataBase/VersesData.h"

@interface VersesViewController: UITableViewController {
	VersesData * _myData;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) VersesData * myData;

- (id) initWithDelegate:(id) bibleView Data:(VersesData *) data;
@end
