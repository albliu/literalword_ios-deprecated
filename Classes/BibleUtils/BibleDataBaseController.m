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
static NSArray * books;
static int maxBooks;
static sqlite3 *bibleDB;

+ (int) getBookIndex:(NSString *)name  {
	for (int i = 0; i < [books count]; i++) {
		BookName * tmp = [books objectAtIndex:i];
		if ([name isEqualToString:tmp.name]) return i;
	}
	
	return 0;
}

+ (NSString *) getBookNameAt:(int) idx {
	BookName* bk = [books objectAtIndex:idx];
	if (bk == nil) return nil;
	return bk.name; 
}

+ (NSNumber *) getBookChapterCountAt:(int) idx {
	BookName* bk = [books objectAtIndex:idx];
	if (bk == nil) return nil;
	return bk.count; 

}
+ (void) initBibleDataBase {
	NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"nasb.db"];


	if (sqlite3_open([path UTF8String], &bibleDB) != SQLITE_OK)
	{

		[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error!"] message:[NSString stringWithFormat:@"Cannot open nasb database"] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];
        	sqlite3_close(bibleDB);
	}



	books = [self.class listBibleContents];
	maxBooks = [books count];
}

+(int) maxBook {
	return maxBooks;
}
+ (NSArray *) listBibleContents {

	sqlite3_stmt    *statement;
	NSMutableArray *result = nil;

		NSString *querySQL = [NSString stringWithFormat: 
			@"SELECT %@,%@ FROM %@",
			@BOOK_HUMAN_ROWID, @BOOK_CHAPTERS_ROWID,
			@BOOKS_TABLE 
			];

		const char *query_stmt = [querySQL UTF8String];
		if(sqlite3_prepare_v2(bibleDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
			result = [[NSMutableArray alloc] initWithCapacity:1];
			while(sqlite3_step(statement) == SQLITE_ROW) {
				const unsigned char *text = sqlite3_column_text(statement, 0);
				int nChap = sqlite3_column_int(statement, 1);
				BookName * books =[[BookName alloc] initWithName:[NSString stringWithFormat:@"%s", text] Count: [NSNumber numberWithInt:nChap]];
				[result addObject:books];
				[books release];
				
			}
			sqlite3_finalize(statement);
		}


	return result;

}

+ (NSArray *) findBook: (const char *) book chapter: (int) chap {

	sqlite3_stmt    *statement;
	NSMutableArray *result = nil;
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


	return result;
}

+(int) getVerseCount:(const char *) book chapter: (int) chap {
//SELECT COUNT(*) FROM verses WHERE book='Revelation' AND chapter = 3 AND header = 0
	int result = -1;
	sqlite3_stmt    *statement;
	NSString *querySQL = [NSString stringWithFormat: 
		@"SELECT COUNT (*) FROM %s WHERE %s = '%s' AND %s = %d AND %s = 0",
		VERSES_TABLE, 
		VERSES_BOOK_ROWID, book,
		VERSES_CHAPTERS_ROWID, chap,
		VERSES_HEADER_TAG ];

	const char *query_stmt = [querySQL UTF8String];
	if(sqlite3_prepare_v2(bibleDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
		while(sqlite3_step(statement) == SQLITE_ROW) {
			result = sqlite3_column_int(statement, 0);
		}
		sqlite3_finalize(statement);
	}

	return result;
}

+ (NSArray *) findString:(const char *) string {

	return nil;
}

+ (void) closeBibleDataBase{ 
	if (bibleDB) sqlite3_close(bibleDB);
	[books release];
}
@end 
