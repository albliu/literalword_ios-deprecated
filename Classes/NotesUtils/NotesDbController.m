#import "NotesDbController.h"

@implementation NoteEntry 

@synthesize title = _title;
@synthesize body = _body;
@synthesize rowid = _rowid;

- (id) initWithTitle :(NSString *) t Body:(NSString *) b ID:(int) rid {

	id ret = [self init];
	self.title = t;
	self.body = b;
	self.rowid = rid;

	return ret; 
}

@end



@implementation NotesDbController

static sqlite3 *database = nil;


+ (NSString *) CreateTableString {

	return [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %s (%s integer primary key autoincrement, %s text not null, %s text not null);",
		NOTES_TABLE,
		KEY_ROWID, 
		KEY_TITLE, 
		KEY_BODY 
		]; 

}

+ (void) openDataBase {

	NSString * dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@NOTES_DB];

	BOOL databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];

	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		if (!databaseAlreadyExists) {
			char * error;

			if (sqlite3_exec(database, [[self.class CreateTableString] UTF8String], NULL, NULL, &error) == SQLITE_OK) {
				NSLog(@"Database and tables created.");
			} else {
				NSLog(@"error creating notes table %s\n", error);
			}
		}
	} else {
		sqlite3_close(database);
	}

}

+ (void) closeDataBase {
	if(database) sqlite3_close(database);
}

- (int) addNote:(const char *) title Body:(const char *) body
{ 

	const char * insert_sql = [[NSString stringWithFormat:@"INSERT INTO %s (%s, %s) Values (\"%s\",\"%s\")", NOTES_TABLE,
				KEY_TITLE,KEY_BODY,
				title, body] UTF8String];

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

- (NSArray *) findAllNotes {

	NSMutableArray *result = nil;
	sqlite3_stmt	*statement;


		const char * select_sql = [[NSString stringWithFormat:
			@"SELECT %s, %s, %s FROM %s", 
			KEY_ROWID, KEY_TITLE, KEY_BODY,
			NOTES_TABLE] UTF8String];

		NSLog(@"%s", select_sql);

		if(sqlite3_prepare_v2(database, select_sql, -1, &statement, NULL) == SQLITE_OK) { 

			result = [[NSMutableArray alloc] initWithCapacity:1];
			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				NoteEntry * entry = [[NoteEntry alloc] 
					initWithTitle: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,1)] 
					Body: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,2)] 
					ID: sqlite3_column_int(statement, 0)];	

				[result addObject:entry];
				[entry release];

			}
			sqlite3_finalize(statement);
		}
	return [result autorelease];
}
- (NoteEntry *) findNote:(int) row_id {


	NoteEntry *result = nil;
	sqlite3_stmt	*statement;

		const char * select_sql = [[NSString stringWithFormat:
			@"SELECT %s, %s FROM %s WHERE %s = %d", 
			KEY_TITLE, KEY_BODY,
			NOTES_TABLE, KEY_ROWID, row_id] UTF8String];

		NSLog(@"%s", select_sql);

		if(sqlite3_prepare_v2(database, select_sql, -1, &statement, NULL) == SQLITE_OK) { 

			while(sqlite3_step(statement) == SQLITE_ROW) {
				
				result = [[NoteEntry alloc] 
					initWithTitle: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,1)] 
					Body: [NSString stringWithFormat:@"%s", sqlite3_column_text(statement,2)] 
					ID: sqlite3_column_int(statement, 0)];	

			}
			sqlite3_finalize(statement);
		}
	return [result autorelease];
}

- (void) deleteNote:(int) row_id {

	sqlite3_stmt	*statement;


		const char * delete_sql = [[NSString stringWithFormat:
			@"DELETE FROM %s WHERE %s = %d", 
			NOTES_TABLE, KEY_ROWID, row_id ] UTF8String];

		NSLog(@"%s", delete_sql);

		if(sqlite3_prepare_v2(database, delete_sql, -1, &statement, NULL) == SQLITE_OK) { 

			 if (sqlite3_step(statement) != SQLITE_DONE) {
				NSLog(@"Error while deleting data. '%s'", sqlite3_errmsg(database));
			}
			sqlite3_finalize(statement);
		}

}

- (void) deleteAllNotes {

	char * error;



		const char * delete_cmd = [[NSString stringWithFormat:@"DROP TABLE IF EXISTS %s", NOTES_TABLE] UTF8String];
		if (sqlite3_exec(database, delete_cmd, NULL, NULL, &error) == SQLITE_OK) {
			NSString * createTable = [self.class CreateTableString];
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

        [super dealloc];
}


@end 
