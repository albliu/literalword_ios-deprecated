#import "BibleUtils/BibleUtils.h"

#define PASSAGESELECTOR_WIDTH 320 
#define PASSAGESELECTOR_HEIGHT 216

@interface PassageSelector: UIViewController <UIPickerViewDelegate> {
	int select_book;
	int select_chapter;
	int frame_width;
	UIPickerView *_selectMenu;
}
@property (nonatomic, retain) UIPickerView *selectMenu;
@property (nonatomic, assign) id bibleview;

-(id) initWithBook:(int) book Chapter:(int) chapter View:(id) v Width:(int) width; 

- (void) dismiss;
@end
