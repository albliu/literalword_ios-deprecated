#import "BibleDataBaseController.h"

typedef enum {
	DEFAULT_VIEW,
	LITERARY_VIEW,
	STUDY_VIEW
} reading_style;

@interface BibleHtmlGenerator: NSObject {
}

+ (NSString *) loadHtmlBook:(const char *) book chapter:(int) chap scale:(CGFloat)myScale style:(reading_style) myStyle;


//static functions
+ (NSString * ) header:(reading_style) myStyle scale:(CGFloat) myscale;
+ (NSString * ) tail;
+ (NSString * ) passage:(NSArray *) results;
+ (NSString * ) passageMod:(NSString *) passage;

@end
