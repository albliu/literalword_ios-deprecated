#import "BibleUtils/BibleUtils.h"
#import "SelectorViewController.h"
#define PASSAGESELECTOR_WIDTH 320 
#define PASSAGESELECTOR_HEIGHT 216

@interface PassageSelector: SelectorViewController <UIPickerViewDelegate> {
	int select_book;
	int select_chapter;
}

-(id) initWithFrame:(CGRect) f RootView:(id) v Book:(int) book Chapter:(int) chapter; 

@end
