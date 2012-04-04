#import "HistoryData.h"

@implementation HistoryData
@synthesize myHistory=_myHistory;

- (int) existsInHistory:(VerseEntry *) entry {

	int i;
	VerseEntry * tmp;
	for ( i = 0; i < [self.myHistory count]; i++ ) {
		tmp = [self.myHistory objectAtIndex:i];
		if (([tmp.book isEqualToString:entry.book]) &&
			(tmp.chapter == entry.chapter)) return i;

	}

	return -1;
}

- (id) init {

    myDB = [[VersesDataBaseController alloc] initDataBase:DATABASE_HISTORY_TABLE];

    self.myHistory = [[NSMutableArray alloc] initWithCapacity: HISTORY_MAX];
    NSArray * tmp =  [myDB findAllVerses];

    // we need to reverse the inital array since most recently added should be on top		    
    int i = [tmp count] - 1;
    for ( ; i >= 0; i--) [self.myHistory addObject:[tmp objectAtIndex:i]];
		
    [tmp release];
    return self;
}
- (void) clear {
	[myDB deleteAllVerses];
	[self.myHistory removeAllObjects];
}

- (void) removeFromList:(int) index {

	VerseEntry * ver = [self.myHistory objectAtIndex:index];
	[self.myHistory removeObjectAtIndex:index];
	[myDB deleteVerse:ver.rowid];	
}

- (void) addToList:(VerseEntry *) ver {

	[self.myHistory insertObject:ver atIndex:0];
	[myDB addVerse:ver.book Chapter:[NSString stringWithFormat:@"%d", ver.chapter] Verses:ver.verses Text:ver.text];
}


- (void) addToHistory:(NSString *) bookname Book:(int) book Chapter:(int) chap {
		
	VerseEntry * entry = [[VerseEntry alloc] initWithBook:bookname 
						Chapter:chap Verses:nil Text:nil ID:-1];
	int exist = [self existsInHistory:entry];
	if (exist != -1) [self removeFromList:exist];

	[self addToList:entry];
	[entry release];	
	if ([self.myHistory count] > HISTORY_MAX) [self removeFromList:HISTORY_MAX]; 

}

- (void) dealloc {
	[myDB release];	
	[self.myHistory release];
	[super dealloc];
}

@end
