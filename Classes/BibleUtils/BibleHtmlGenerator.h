#import "BibleDataBaseController.h"

typedef enum {
	DEFAULT_VIEW,
	LITERARY_VIEW,
	STUDY_VIEW
} reading_style;

@interface BibleHtmlGenerator: NSObject {
}

+ (NSString *) loadHtmlBookWithVerse: (int)ver Highlights:(NSArray *) hlights Book: (const char *) book chapter:(int) chap scale:(float)myScale style:(reading_style) myStyle; 
+ (NSString *) loadHtmlBook:(const char *) book chapter:(int) chap scale:(float)myScale style:(reading_style) myStyle;


//static functions
+ (NSString * ) bodyHeader: (int) ver Highlights:(NSArray *) hlights; 
+ (NSString * ) header:(reading_style) myStyle scale:(float) myscale;
+ (NSString * ) tail;
+ (NSString * ) passage:(NSArray *) results;
+ (NSString * ) passageMod:(NSString *) passage;

@end
