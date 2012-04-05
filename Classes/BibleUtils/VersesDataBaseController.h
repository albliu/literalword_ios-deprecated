#import "VerseEntry.h"
#import "sqlite3.h"


#define DATABASE_BOOKMARK_TABLE "bookmarks"
#define DATABASE_MEMVERSE_TABLE "memoryverses"
#define DATABASE_HISTORY_TABLE "history"


#define KEY_ROWID "_id"
#define VERSES_DB "Verses.db"
#define VERSES_TITLE "titag" 
#define VERSES_TABLE "verses"
#define VERSES_BOOK_ROWID "book"
#define VERSES_NUM_ROWID "num_verse"
#define VERSES_TEXT_ROWID "verse"
#define VERSES_CHAPTERS_ROWID "chapter"
#define VERSES_HEADER_TAG "header"


@interface VersesDataBaseController: NSObject {
	NSString * dbase;
}


- (id) initDataBase:(const char *) name;
+ (void) openDataBase;
+ (void) closeDataBase;

- (int) addVerse:(int) book Chapter:(int) chap Verses:(NSString *) ver Text:(NSString *) text; 
- (NSArray *) findAllVerses; 
- (void) deleteVerse: (int) row_id;
- (void) deleteAllVerses;
- (VerseEntry *) findVerse: (int) row_id; 

@end


