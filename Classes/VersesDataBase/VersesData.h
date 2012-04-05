#import <BibleUtils/BibleUtils.h>
#import "sqlite3.h"


@interface VersesData : NSObject {
	NSMutableArray * _myVerses;
	VersesDataBaseController * _myDB;
}

@property (nonatomic, retain) NSMutableArray * myVerses;
@property (nonatomic, retain) VersesDataBaseController * myDB;

- (void) addToVerses:(int) book Chapter:(int) chap Verses:(NSString *) ver Text:(NSString *) txt; 
- (void) addToList:(VerseEntry *) ver; 
- (void) removeFromList:(int) index; 
- (void) clear;
@end

