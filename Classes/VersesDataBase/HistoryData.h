#import "VersesData.h"

#define HISTORY_MAX 30

@interface HistoryData : VersesData {
}

- (void) addToHistory:(int) book Chapter:(int) chap;
- (VerseEntry *) lastPassage; 
@end

