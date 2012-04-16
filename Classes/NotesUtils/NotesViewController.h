#import "NotesData.h"
#import "NotesEditViewController.h"

@interface NotesViewController: UITableViewController<NotesEditDelegate> {
	NotesData * _myData;
}
@property (nonatomic, retain) NotesData * myData;

- (id) initWithNotes:(NotesData *) data;
@end
