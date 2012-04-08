#import "BookmarkData.h"

@implementation BookmarkData

- (int) existsInData:(int) book Chapter:(int) chapter Verse: (NSString *) ver{

	int i;
	VerseEntry * tmp;
	for ( i = 0; i < [self.myVerses count]; i++ ) {
		tmp = [self.myVerses objectAtIndex:i];
		if ((tmp.book_index == book ) &&
			(tmp.chapter == chapter) &&
			 ([tmp.verses intValue] == [ver intValue])) return i;

	}

	return -1;
}

- (id) init {

    self.myDB = [[VersesDataBaseController alloc] initDataBase:DATABASE_BOOKMARK_TABLE];
    NSArray * tmp =  [self.myDB findAllVerses];
    self.myVerses = [tmp mutableCopy];
    [tmp release];
		
    return self;
}


- (void) addToBookmarks:(int) book Chapter:(int) chap Verses:(NSArray *) ver Text:(NSString *) txt {

	
	// if multiple verses are selected, only the first 1 is added to bookmarks

	int exist = [self existsInData:book Chapter:chap Verse: [ver objectAtIndex:0]];
	if (exist != -1) [self removeFromList:exist];  

	[self addToVerses:book Chapter:chap Verses:[ver objectAtIndex:0] Text:txt];	   
}

@end
