#import "HistoryData.h"

@implementation HistoryData

- (int) existsInHistory:(NSString *) bookname Chapter:(int) chapter {

	int i;
	VerseEntry * tmp;
	for ( i = 0; i < [self.myVerses count]; i++ ) {
		tmp = [self.myVerses objectAtIndex:i];
		if (([tmp.book isEqualToString:bookname]) &&
			(tmp.chapter == chapter)) return i;

	}

	return -1;
}

- (void) addToList:(VerseEntry *) ver {

	ver.rowid = [self.myDB addVerse:ver.book Chapter:[NSString stringWithFormat:@"%d", ver.chapter] Verses:ver.verses Text:ver.text];
	[self.myVerses insertObject:ver atIndex:0];
}

- (id) init {

    self.myDB = [[VersesDataBaseController alloc] initDataBase:DATABASE_HISTORY_TABLE];

    self.myVerses = [[NSMutableArray alloc] initWithCapacity: HISTORY_MAX];
    NSArray * tmp =  [self.myDB findAllVerses];

    // we need to reverse the inital array since most recently added should be on top		    
    int i = [tmp count] - 1;
    for ( ; i >= 0; i--) [self.myVerses addObject:[tmp objectAtIndex:i]];
		
    [tmp release];
    return self;
}

- (void) addToHistory:(NSString *) bookname Book:(int) book Chapter:(int) chap {
		
	int exist = [self existsInHistory:bookname Chapter:chap];
	if (exist != -1) [self removeFromList:exist];

	[self addToVerses:bookname Book:book Chapter:chap Verses:nil Text:nil];	

	if ([self.myVerses count] > HISTORY_MAX) [self removeFromList:HISTORY_MAX]; 

}

- (VerseEntry *) lastPassage {
	if ([self.myVerses count] == 0) return nil;
	return [self.myVerses objectAtIndex:0];
}

@end
