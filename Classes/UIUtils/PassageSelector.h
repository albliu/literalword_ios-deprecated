#import "BibleUtils/BibleUtils.h"
#define PASSAGESELECTOR_WIDTH 320 
#define PASSAGESELECTOR_HEIGHT 300

@interface PassageSelector: NSObject <UIPickerViewDelegate>{
	int select_book;
	int select_chapter;
	int frame_width;
}
@property (nonatomic, retain) UIPickerView *selectMenu;
@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) BibleDataBaseController *bibleDB;

-(PassageSelector *) initWithViewWidth:(int) width Delegate:(id) del BibleDB:(BibleDataBaseController *)db;
-(void) showSelector:(int) book withChapter:(int) chapter;
-(void) hideSelector;
@end
