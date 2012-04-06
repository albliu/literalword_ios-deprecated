#define VERSES_TABLE_WIDTH 250
#define VERSES_TABLE_HEIGHT 300
#define VERSES_CELL_SIDE 50
#define VERSES_TABLE_BORDER 5

@interface VerseSelector: UIViewController <UITableViewDelegate, UITableViewDataSource> {
	CGRect frame;
	int rows;
	int ver;
	UITableView * _tableView;
}
@property (nonatomic, assign) id rootview;
@property (nonatomic, retain) UITableView * tableView;

-(VerseSelector *) initWithViewFrame:(CGRect) rect Delegate:(id) del Verses:(int) v;
-(void) showMyView; 
-(void) dismissMyView;
@end
