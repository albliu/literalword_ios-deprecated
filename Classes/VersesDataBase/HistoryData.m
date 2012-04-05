#import "HistoryData.h"

@implementation HistoryData

- (int) existsInHistory:(int) book Chapter:(int) chapter {

	int i;
	VerseEntry * tmp;
	for ( i = 0; i < [self.myVerses count]; i++ ) {
		tmp = [self.myVerses objectAtIndex:i];
		if ((tmp.book_index == book ) &&
			(tmp.chapter == chapter)) return i;

	}

	return -1;
}

- (void) addToList:(VerseEntry *) ver {

	ver.rowid = [self.myDB addVerse:ver.book_index Chapter:ver.chapter Verses:ver.verses Text:ver.text];
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

- (void) addToHistory:(int) book Chapter:(int) chap {
		
	int exist = [self existsInHistory:book Chapter:chap];
	if (exist != -1) [self removeFromList:exist];

	[self addToVerses:book Chapter:chap Verses:nil Text:nil];	

	if ([self.myVerses count] > HISTORY_MAX) [self removeFromList:HISTORY_MAX]; 

}

- (VerseEntry *) lastPassage {
	if ([self.myVerses count] == 0) return nil;
	return [self.myVerses objectAtIndex:0];
}

@end
