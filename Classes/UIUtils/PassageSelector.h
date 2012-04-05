#import "BibleUtils/BibleUtils.h"

#define PASSAGESELECTOR_WIDTH 320 
#define PASSAGESELECTOR_HEIGHT 216

@interface PassageSelector: NSObject <UIPickerViewDelegate>{
	int select_book;
	int select_chapter;
	int frame_width;
	UIPickerView *_selectMenu;
}
@property (nonatomic, retain) UIPickerView *selectMenu;
@property (nonatomic, assign) UIView *view;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL hidden;

-(PassageSelector *) initWithViewWidth:(int) width Delegate:(id) del ;
-(void) showSelector:(int) book withChapter:(int) chapter;
-(void) hideSelector;
@end
