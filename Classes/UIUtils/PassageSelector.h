#import "BibleUtils/BibleUtils.h"
#import "SelectorViewController.h"
#define PASSAGESELECTOR_WIDTH 320 
#define PASSAGESELECTOR_HEIGHT 216

@interface PassageSelector: SelectorViewController <UIPickerViewDelegate> {
	int select_book;
	int select_chapter;
	int frame_width;
}

-(id) initWithBook:(int) book Chapter:(int) chapter View:(id) v Width:(int) width; 

@end
