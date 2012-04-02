#import "BibleDataBaseController.h"

typedef enum {
	DEFAULT_VIEW,
	LITERARY_VIEW,
	STUDY_VIEW
} reading_style;

@interface BibleHtmlGenerator: NSObject {
	CGFloat _scale;
}

@property (nonatomic, retain) BibleDataBaseController * nasbbible;

- (BibleHtmlGenerator *) initWithDB: (BibleDataBaseController *) db Scale:(CGFloat) s; 
- (NSString *) loadHtmlBook:(const char *) book chapter:(int) chap style:(reading_style) myStyle;
- (CGFloat) getScale;
- (void) setScale:(CGFloat) scale;

// returns books and chapters in the bible
- (NSArray *) listBibleContents;

//static functions
+ (NSString * ) header:(reading_style) myStyle scale:(CGFloat) myscale;
+ (NSString * ) tail;
+ (NSString * ) passage:(NSArray *) results;
+ (NSString * ) passageMod:(NSString *) passage;

@end
