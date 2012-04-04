#import <BibleUtils/BibleUtils.h>
#import "sqlite3.h"

#define HISTORY_MAX 30

@interface HistoryData : NSObject {
	NSMutableArray * _myHistory;
	VersesDataBaseController * _myDB;
}

@property (nonatomic, retain) NSMutableArray * myHistory;
@property (nonatomic, retain) VersesDataBaseController * myDB;

- (void) addToHistory:(NSString *) bookname Book:(int) book Chapter:(int) chap;
- (void) addToList:(VerseEntry *) ver; 
- (void) removeFromList:(int) index; 
- (void) clear;
@end

