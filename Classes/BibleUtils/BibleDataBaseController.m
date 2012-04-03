#import "BibleDataBaseController.h"
#import "NasbDataBaseHeaders.h"

@implementation QueryResults 

@synthesize verse = _verse;
@synthesize header = _header;
@synthesize passage = _passage;
@synthesize text = _text;

- (const char *) passage {
	if (self.text == nil) return "";
	return [self.text UTF8String];

}

- (id) initWithVerse:(int) ver Passage:(const unsigned char *)txt Header:(int) head {
	self.verse = ver;
	self.text = [NSString stringWithFormat:@"%s", txt];
	self.header = head;

	return self;
}

@end
@implementation BookName 

@synthesize name = _name;
@synthesize count = _count;

- (id) initWithName:(NSString *) book Count:(NSNumber *) n {
	self.name = book;
	self.count = n;
	return self;
}

@end

@implementation BibleDataBaseController
@synthesize dbPath = _dbPath;
@synthesize books = _books;
static int maxBooks;

- (int) getBookIndex:(NSString *)name  {
	return [self.books indexOfObject:name];

}

- (NSString *) getBookNameAt:(int) idx {
	BookName* bk = [self.books objectAtIndex:idx];
	if (bk == nil) return nil;
	return bk.name; 
}

- (NSNumber *) getBookChapterCountAt:(int) idx {
	BookName* bk = [self.books objectAtIndex:idx];
	if (bk == nil) return nil;
	return bk.count; 

}
- (id) initDataBase:(const char *) dbpath {
	self.dbPath = [NSString stringWithFormat:@"%s", dbpath]; 
	self.books = [self listBibleContents];
	maxBooks = [self.books count];
	return self;
}

-(int) maxBook {
	return maxBooks;
}
- (NSArray *) listBibleContents {

	sqlite3_stmt    *statement;
	sqlite3 *bibleDB;
	NSMutableArray *result = nil;

	if (sqlite3_open([self.dbPath UTF8String], &bibleDB) == SQLITE_OK)
	{
		NSString *querySQL = [NSString stringWithFormat: 
			@"SELECT %@,%@ FROM %@",
			@BOOK_HUMAN_ROWID, @BOOK_CHAPTERS_ROWID,
			@BOOKS_TABLE 
			];

		const char *query_stmt = [querySQL UTF8String];
		if(sqlite3_prepare_v2(bibleDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
			result = [NSMutableArray array];
			while(sqlite3_step(statement) == SQLITE_ROW) {
				const unsigned char *text = sqlite3_column_text(statement, 0);
				int nChap = sqlite3_column_int(statement, 1);
				BookName * books =[[BookName alloc] initWithName:[NSString stringWithFormat:@"%s", text] Count: [NSNumber numberWithInt:nChap]];
				[result addObject:books];
				[books release];
				
			}
			sqlite3_finalize(statement);
		}
        	sqlite3_close(bibleDB);
	} 


	return result;

}

- (NSArray *) findBook: (const char *) book chapter: (int) chap {

	sqlite3_stmt    *statement;
	sqlite3 *bibleDB;
	NSMutableArray *result = nil;
	if (sqlite3_open([self.dbPath UTF8String], &bibleDB) == SQLITE_OK)
	{
		NSString *querySQL = [NSString stringWithFormat: 
			@"SELECT %@,%@,%@,%@ FROM %@ WHERE %@ = \"%@\" AND %@ = %@",
			@KEY_ROWID, @VERSES_HEADER_TAG, @VERSES_NUM_ROWID, @VERSES_TEXT_ROWID, 
			@VERSES_TABLE, 
			@VERSES_BOOK_ROWID, [NSString stringWithFormat:@"%s", book],
			@VERSES_CHAPTERS_ROWID, [NSNumber numberWithInt:chap] 
			];

		const char *query_stmt = [querySQL UTF8String];
		if(sqlite3_prepare_v2(bibleDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
			result = [NSMutableArray array];
			while(sqlite3_step(statement) == SQLITE_ROW) {
/*				for (int i=0; i<sqlite3_column_count(statement); i++) {
					int colType = sqlite3_column_type(statement, i);
					id value;
					if (colType == SQLITE_TEXT) {
						const unsigned char *text = sqlite3_column_text(statement, 3);
						value = [NSString stringWithFormat:@"%s", text];
					} else if (colType == SQLITE_INTEGER) {
						int col = sqlite3_column_int(statement, 2);
						value = [NSNumber numberWithInt:col];
					} else if (colType == SQLITE_NULL) {
						value = [NSNull null];
					} else {
						NSLog(@"[SQLITE] UNKNOWN DATATYPE");
					}
 
				}
*/
				const unsigned char *text = sqlite3_column_text(statement, 3);
				int ver = sqlite3_column_int(statement, 2);
				int head = sqlite3_column_int(statement, 1);
				QueryResults * obj = [[QueryResults alloc] initWithVerse: ver 
						Passage: text 
						Header:head];
				[result addObject:obj];
				[obj release];	
			}
			sqlite3_finalize(statement);
		}
        	sqlite3_close(bibleDB);
	} 


	return result;
}

- (NSArray *) findString:(const char *) string {

	return nil;
}

@end 
