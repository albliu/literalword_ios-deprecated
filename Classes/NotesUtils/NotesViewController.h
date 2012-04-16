#import "NotesData.h"
#import "NotesEditViewController.h"

@interface NotesViewController: UITableViewController<NotesEditDelegate> {
	NotesData * _myData;
    NotesEditViewController * _myedit;
}
@property (nonatomic, retain) NotesData * myData;
@property (nonatomic, retain) NotesEditViewController * myedit;

- (id) initWithNotes:(NotesData *) data;
@end
