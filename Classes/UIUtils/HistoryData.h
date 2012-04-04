#import <BibleUtils/BibleUtils.h>
#import "sqlite3.h"

#define HISTORY_MAX 30

@interface HistoryData : NSObject {
	NSMutableArray * _myHistory;
	VersesDataBaseController * myDB;
}

@property (nonatomic, retain) NSMutableArray * myHistory;

- (void) addToHistory:(NSString *) bookname Book:(int) book Chapter:(int) chap;
- (void) addToList:(VerseEntry *) ver; 
- (void) removeFromList:(int) index; 
- (void) clear;
@end

