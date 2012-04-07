#import "BookmarkData.h"

@implementation BookmarkData

- (id) init {

    self.myDB = [[VersesDataBaseController alloc] initDataBase:DATABASE_BOOKMARK_TABLE];
    NSArray * tmp =  [self.myDB findAllVerses];
    self.myVerses = [tmp mutableCopy];
    [tmp release];
		
    return self;
}

- (int) existsInVerses:(VerseEntry *) ver {
	return -1;
}


- (NSString *) formatVerses:(NSArray *) arr {
	return [VerseEntry VerseArrayToString:arr];
}

- (void) addToBookmarks:(int) book Chapter:(int) chap Verses:(NSArray *) ver Text:(NSString *) txt {

	// if multiple verses are selected, only the first 1 is added to bookmarks
	NSArray * newArr;
	if ([ver count] > 1)
		newArr = [NSArray arrayWithObjects:[ver objectAtIndex:0], nil];
	else 
		newArr = ver;

	[self addToVerses:book Chapter:chap Verses:[self formatVerses:newArr] Text:txt];	
}

@end
