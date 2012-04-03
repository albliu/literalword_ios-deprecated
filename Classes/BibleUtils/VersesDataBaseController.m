#import "VersesDataBaseController.h"

@implementation VersesDataBaseController
@synthesize dbPath = _dbPath;

- (NSString *) dbPath {
	if (_dbPath == nil) {
		_dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@VERSES_DB];
	}
	return _dbPath;
}

- (id) initDataBase {
	sqlite3 *myDB;
	BOOL databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:self.dbPath];

	if (sqlite3_open([self.dbPath UTF8String], &myDB) == SQLITE_OK) {
		if (!databaseAlreadyExists) {
			NSString * createMem = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXIST %s (_id  integer primary key autoincrement, %s text, %s text not null, %s integer, %s text not null, %s text not null);", DATABASE_MEMVERSE_TABLE,VERSES_TITLE, VERSES_BOOK_ROWID, VERSES_CHAPTERS_ROWID, VERSES_NUM_ROWID, VERSES_TEXT_ROWID ]; 
			NSString * createBookmark = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXIST %s (_id  integer primary key autoincrement, %s text, %s text not null, %s integer, %s text not null, %s text not null);", DATABASE_BOOKMARK_TABLE,VERSES_TITLE, VERSES_BOOK_ROWID, VERSES_CHAPTERS_ROWID, VERSES_NUM_ROWID, VERSES_TEXT_ROWID ]; 
			char * error;

			if (sqlite3_exec(myDB, [createMem UTF8String], NULL, NULL, &error) == SQLITE_OK) {

				if (sqlite3_exec(myDB, [createBookmark UTF8String], NULL, NULL, &error) == SQLITE_OK) {
					NSLog(@"Database and tables created.");
				} else {
					NSLog(@"error creating table\n");
				}
			} else {
				NSLog(@"error creating table\n");
			}


		}
	}
	sqlite3_close(myDB);
	return self;
}

- (void) addVerseTo:(NSString *) database {
	NSLog(@"addVerse");
}

@end 
