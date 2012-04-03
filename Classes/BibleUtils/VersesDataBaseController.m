#import "VersesDataBaseController.h"

@implementation VerseEntry 

@synthesize book = _book;
@synthesize chapter = _chapter;
@synthesize verses = _verses;
@synthesize text = _text;
@synthesize rowid = _rowid;

- (id) initWithBook:(NSString *) bk Chapter:(int) chp Verses:(NSString *) ver Text:(NSString *)txt ID:(int) rid {
	self.book = bk;
	self.text = txt;
	self.rowid = rid;
	self.verses = ver;
	self.chapter = chp;

	return self;
}

@end


@implementation VersesDataBaseController
@synthesize dbPath = _dbPath;

- (NSString *) dbPath {
	if (_dbPath == nil) {
		_dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@VERSES_DB];
	}
	return _dbPath;
}

+ (NSString *) CreateTableString:(const char *) table {

	return [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %s (%s  integer primary key autoincrement, %s text, %s text not null, %s integer, %s text not null, %s text not null);",
		table,
		KEY_ROWID, 
		VERSES_TITLE, 
		VERSES_BOOK_ROWID, 
		VERSES_CHAPTERS_ROWID, 
		VERSES_NUM_ROWID, 
		VERSES_TEXT_ROWID ]; 

}

- (id) initDataBase {
	sqlite3 *myDB;
	BOOL databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:self.dbPath];

	if (sqlite3_open([self.dbPath UTF8String], &myDB) == SQLITE_OK) {
		if (!databaseAlreadyExists) {
			NSString * createMem = [self.class CreateTableString:DATABASE_MEMVERSE_TABLE];
			NSString * createBookmark = [self.class CreateTableString:DATABASE_BOOKMARK_TABLE];
			char * error;

			if (sqlite3_exec(myDB, [createMem UTF8String], NULL, NULL, &error) == SQLITE_OK) {

				if (sqlite3_exec(myDB, [createBookmark UTF8String], NULL, NULL, &error) == SQLITE_OK) {
					NSLog(@"Database and tables created.");
				} else {
					NSLog(@"error creating memory table\n");
				}
			} else {
				NSLog(@"error creating bookmark table\n");
			}

			[createMem release];
			[createBookmark release];
		}
		sqlite3_close(myDB);
	}
	return self;
}

- (void) addVerseTo:(NSString *) dbase Book:(NSString *) book Chapter:(NSString *) chap Verses:(NSString *) ver Text:(NSString *) text {
	const char * insert_sql = [[NSString stringWithFormat:@"INSERT INTO %@ (%s, %s, %s, %s) Values (\"%@\",%@,\"%@\",\"%@\")",dbase,
				VERSES_BOOK_ROWID,VERSES_CHAPTERS_ROWID, VERSES_NUM_ROWID, VERSES_TEXT_ROWID,
				book, chap, ver, text] UTF8String];


	sqlite3 *database = nil;
	sqlite3_stmt    *statement;

	if (sqlite3_open([self.dbPath UTF8String], &database) == SQLITE_OK) {
		if(sqlite3_prepare_v2(database, insert_sql, -1, &statement, NULL) == SQLITE_OK) { 

			if (sqlite3_step(statement) != SQLITE_DONE) {
				NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
			}
			sqlite3_finalize(statement);
		} else {
			NSLog(@"error preparing statement : %s\n", sqlite3_errmsg(database));
		}
		sqlite3_close(database);
	} else {
		NSLog(@"error opening database\n");
	}
	NSLog(@"addVerse");

}

- (NSArray *) findVersesFrom:(NSString *)dbase {

	NSMutableArray *result = nil;
	sqlite3 *database = nil;
	sqlite3_stmt    *statement;

	if (sqlite3_open([self.dbPath UTF8String], &database) == SQLITE_OK) {

		const char * select_sql = [[NSString stringWithFormat:
			@"SELECT %s, %s, %s, %s, %s FROM %@", 
			VERSES_BOOK_ROWID,VERSES_CHAPTERS_ROWID, VERSES_NUM_ROWID, VERSES_TEXT_ROWID, KEY_ROWID,
			dbase] UTF8String];

		NSLog(@"%s", select_sql);

		if(sqlite3_prepare_v2(database, select_sql, -1, &statement, NULL) == SQLITE_OK) { 

			result = [NSMutableArray array];
			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				VerseEntry * entry = [[VerseEntry alloc] 
					initWithBook:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 0)] 
					Chapter: sqlite3_column_int(statement, 1) 
					Verses: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,2)] 
					Text: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,3)] 
					ID: sqlite3_column_int(statement, 4)];	

				[result addObject:entry];
				[entry release];

			}
			sqlite3_finalize(statement);
		}
        	sqlite3_close(database);
	}
	return result;
}
- (VerseEntry *) findVerse:(NSString *)dbase Row:(int) row_id {


	VerseEntry *result = nil;
	sqlite3 *database = nil;
	sqlite3_stmt    *statement;

	if (sqlite3_open([self.dbPath UTF8String], &database) == SQLITE_OK) {

		const char * select_sql = [[NSString stringWithFormat:
			@"SELECT %s, %s, %s, %s, %s FROM %@ WHERE %s = %d", 
			VERSES_BOOK_ROWID,VERSES_CHAPTERS_ROWID, VERSES_NUM_ROWID, VERSES_TEXT_ROWID, KEY_ROWID,
			dbase, KEY_ROWID, row_id] UTF8String];

		NSLog(@"%s", select_sql);

		if(sqlite3_prepare_v2(database, select_sql, -1, &statement, NULL) == SQLITE_OK) { 

			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				result = [[VerseEntry alloc] 
					initWithBook:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 0)] 
					Chapter: sqlite3_column_int(statement, 1) 
					Verses: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,2)] 
					Text: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,3)] 
					ID:sqlite3_column_int(statement, 4) ];	

			}
			sqlite3_finalize(statement);
		}
        	sqlite3_close(database);
	}
	return result;
}

- (void) deleteVerse:(NSString *)dbase Row:(int) row_id {

	sqlite3 *database = nil;
	sqlite3_stmt    *statement;

	if (sqlite3_open([self.dbPath UTF8String], &database) == SQLITE_OK) {

		const char * delete_sql = [[NSString stringWithFormat:
			@"DELETE FROM %@ WHERE %s = %d", 
			dbase, KEY_ROWID, row_id ] UTF8String];

		NSLog(@"%s", delete_sql);

		if(sqlite3_prepare_v2(database, delete_sql, -1, &statement, NULL) == SQLITE_OK) { 

			 if (sqlite3_step(statement) != SQLITE_DONE) {
				NSLog(@"Error while deleting data. '%s'", sqlite3_errmsg(database));
			}
			sqlite3_finalize(statement);
		}
        	sqlite3_close(database);
	}

}

- (void) deleteAllVerses:(NSString *)dbase {

	sqlite3 *database = nil;
	sqlite3_stmt    *statement;
	char * error;


	if (sqlite3_open([self.dbPath UTF8String], &database) == SQLITE_OK) {

		const char * delete_cmd = [[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", dbase] UTF8String];
		if (sqlite3_exec(database, delete_cmd, NULL, NULL, &error) == SQLITE_OK) {
			NSString * createTable = [self.class CreateTableString:[dbase UTF8String]];
			if (sqlite3_exec(database, [createTable UTF8String], NULL, NULL, &error) == SQLITE_OK) {
				NSLog(@"Database and tables cleared.");
			} else {
				NSLog(@"error creating table\n");
			}
			[createTable release];
		} else {
			NSLog(@"error deleting table\n");
		}

		sqlite3_close(database);
	}

}

#pragma mark --
#pragma mark Memory table 
- (void) addVerseToMemory:(NSString *) book Chapter:(NSString *) chap Verses:(NSString *) ver Text:(NSString *) text {
	[self addVerseTo:@DATABASE_MEMVERSE_TABLE Book:book Chapter:chap Verses:ver Text:text];
}

- (NSArray *) findAllMemoryVerses {
	return [self findVersesFrom:@DATABASE_MEMVERSE_TABLE];
}

- (void) deleteMemoryVerse: (int) row_id {
	[self deleteVerse:@DATABASE_MEMVERSE_TABLE Row:row_id];
}

- (void) deleteAllMemoryVerse {
	[self deleteAllVerses:@DATABASE_MEMVERSE_TABLE];
}
- (VerseEntry *) findMemoryVerse: (int) row_id {
	return [self findVerse:@DATABASE_MEMVERSE_TABLE Row:row_id];
}


#pragma mark BOokmark table 
- (void) addVerseToBookMark:(NSString *) book Chapter:(NSString *) chap Verses:(NSString *) ver Text:(NSString *) text {
	[self addVerseTo:@DATABASE_BOOKMARK_TABLE Book:book Chapter:chap Verses:ver Text:text];
}

- (NSArray *) findAllBookmarks {
	return [self findVersesFrom:@DATABASE_BOOKMARK_TABLE];
}

- (void) deleteBookmarkVerse: (int) row_id {
	[self deleteVerse:@DATABASE_BOOKMARK_TABLE Row:row_id];
}

- (void) deleteAllBookmarkVerse {
	[self deleteAllVerses:@DATABASE_BOOKMARK_TABLE];
}

- (VerseEntry *) findBookmarkVerse: (int) row_id {
	return [self findVerse:@DATABASE_BOOKMARK_TABLE Row:row_id];

}
@end 
