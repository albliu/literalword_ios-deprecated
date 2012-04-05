#import "VersesDataBaseController.h"

@implementation VersesDataBaseController

static sqlite3 *database = nil;


+ (NSString *) CreateTableString:(const char *) table {

	return [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %s (%s  integer primary key autoincrement, %s text, %s integer, %s integer, %s text not null, %s text not null);",
		table,
		KEY_ROWID, 
		VERSES_TITLE, 
		VERSES_BOOK_ROWID, 
		VERSES_CHAPTERS_ROWID, 
		VERSES_NUM_ROWID, 
		VERSES_TEXT_ROWID ]; 

}

+ (void) openDataBase {

	NSString * dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@VERSES_DB];

	BOOL databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];

	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		if (!databaseAlreadyExists) {
			NSString * createHist = [self.class CreateTableString:DATABASE_HISTORY_TABLE];
			NSString * createMem = [self.class CreateTableString:DATABASE_MEMVERSE_TABLE];
			NSString * createBMark = [self.class CreateTableString:DATABASE_BOOKMARK_TABLE];
			char * error;

			if (sqlite3_exec(database, [createHist UTF8String], NULL, NULL, &error) == SQLITE_OK) {
				NSLog(@"Database and tables created.");
			} else {
				NSLog(@"error creating history table %s\n", error);
			}

			if (sqlite3_exec(database, [createBMark UTF8String], NULL, NULL, &error) == SQLITE_OK) {
				NSLog(@"Database and tables created.");
			} else {
				NSLog(@"error creating Bookmark table %s\n", error);
			}

			if (sqlite3_exec(database, [createMem UTF8String], NULL, NULL, &error) == SQLITE_OK) {
				NSLog(@"Database and tables created.");
			} else {
				NSLog(@"error creating Memory Verse table %s\n", error);
			}
			[createHist release];
			[createMem release];
			[createBMark release];
		}
	} else {
		sqlite3_close(database);
	}

}

+ (void) closeDataBase {
	if(database) sqlite3_close(database);
}

- (id) initDataBase :(const char *) name {

	[super init];
	dbase = [[NSString alloc] initWithFormat:@"%s",name];

	return self;
}

- (int) addVerse:(int) book Chapter:(int) chap Verses:(NSString *) ver Text:(NSString *) text {
	const char * insert_sql = [[NSString stringWithFormat:@"INSERT INTO %@ (%s, %s, %s, %s) Values (%d,%d,\"%@\",\"%@\")", dbase,
				VERSES_BOOK_ROWID,VERSES_CHAPTERS_ROWID, VERSES_NUM_ROWID, VERSES_TEXT_ROWID,
				book, chap, ver, text] UTF8String];

	int ret_id = -1;
	sqlite3_stmt	*statement;

	if(sqlite3_prepare_v2(database, insert_sql, -1, &statement, NULL) == SQLITE_OK) { 

		if (sqlite3_step(statement) != SQLITE_DONE) {
			NSLog(@"Error while inserting data. '%s'", sqlite3_errmsg(database));
		} else {
			ret_id = sqlite3_last_insert_rowid(database);	
		}

		sqlite3_finalize(statement);
	} else {
		NSLog(@"error preparing statement : %s\n", sqlite3_errmsg(database));
	}

	return ret_id;
}

- (NSArray *) findAllVerses {

	NSMutableArray *result = nil;
	sqlite3_stmt	*statement;


		const char * select_sql = [[NSString stringWithFormat:
			@"SELECT %s, %s, %s, %s, %s FROM %@", 
			VERSES_BOOK_ROWID,VERSES_CHAPTERS_ROWID, VERSES_NUM_ROWID, VERSES_TEXT_ROWID, KEY_ROWID,
			dbase] UTF8String];

		NSLog(@"%s", select_sql);

		if(sqlite3_prepare_v2(database, select_sql, -1, &statement, NULL) == SQLITE_OK) { 

			result = [[NSMutableArray alloc] initWithCapacity:1];
			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				VerseEntry * entry = [[VerseEntry alloc] 
					initWithBook: sqlite3_column_int(statement, 0) 
					Chapter: sqlite3_column_int(statement, 1) 
					Verses: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,2)] 
					Text: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,3)] 
					ID: sqlite3_column_int(statement, 4)];	

				[result addObject:entry];
				[entry release];

			}
			sqlite3_finalize(statement);
		}
	return result;
}
- (VerseEntry *) findVerse:(int) row_id {


	VerseEntry *result = nil;
	sqlite3_stmt	*statement;

		const char * select_sql = [[NSString stringWithFormat:
			@"SELECT %s, %s, %s, %s, %s FROM %@ WHERE %s = %d", 
			VERSES_BOOK_ROWID,VERSES_CHAPTERS_ROWID, VERSES_NUM_ROWID, VERSES_TEXT_ROWID, KEY_ROWID,
			dbase, KEY_ROWID, row_id] UTF8String];

		NSLog(@"%s", select_sql);

		if(sqlite3_prepare_v2(database, select_sql, -1, &statement, NULL) == SQLITE_OK) { 

			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				result = [[VerseEntry alloc] 
					initWithBook: sqlite3_column_int(statement, 0) 
					Chapter: sqlite3_column_int(statement, 1) 
					Verses: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,2)] 
					Text: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,3)] 
					ID:sqlite3_column_int(statement, 4) ];	

			}
			sqlite3_finalize(statement);
		}
	return result;
}

- (void) deleteVerse:(int) row_id {

	sqlite3_stmt	*statement;


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

}

- (void) deleteAllVerses {

	char * error;



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


}


- (void) dealloc {

        [dbase release];
        [super dealloc];
}


@end 
