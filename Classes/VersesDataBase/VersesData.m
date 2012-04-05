#import "VersesData.h"

@implementation VersesData
@synthesize myVerses=_myVerses;
@synthesize myDB=_myDB;

- (id) init {
    self.myDB = nil;
    self.myVerses = [[NSMutableArray alloc] initWithCapacity:10];
		
    return self;
}


- (void) clear {
	[self.myDB deleteAllVerses];
	[self.myVerses removeAllObjects];
}

- (void) removeFromList:(int) index {

	VerseEntry * ver = [self.myVerses objectAtIndex:index];
	[self.myVerses removeObjectAtIndex:index];
	[self.myDB deleteVerse:ver.rowid];	
}

- (void) addToList:(VerseEntry *) ver {

	ver.rowid = [self.myDB addVerse:ver.book_index Chapter:ver.chapter Verses:ver.verses Text:ver.text];
	[self.myVerses addObject:ver];
}


- (void) addToVerses:(int) book Chapter:(int) chap Verses:(NSString *) ver Text:(NSString *) txt {
		
	VerseEntry * entry = [[VerseEntry alloc] initWithBook:book 
						Chapter:chap Verses:ver Text:txt ID:-1];
	[self addToList:entry];
	[entry release];	

}

- (void) dealloc {
	[self.myDB release];	
	[self.myVerses release];
	[super dealloc];
}



@end
