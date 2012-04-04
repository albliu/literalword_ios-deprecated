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
	return nil;
}

- (void) addToBookmarks:(NSString *) bookname Book:(int) book Chapter:(int) chap Verses:(NSArray *) ver Text:(NSString *) txt {

	[self addToVerses:bookname Book:book Chapter:chap Verses:[self formatVerses:ver] Text:txt];	
}

@end
