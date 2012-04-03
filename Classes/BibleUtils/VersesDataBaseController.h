#import <Foundation/Foundation.h>
#import "sqlite3.h"

#define VERSES_DB "Verses.db"
#define VERSES_TITLE "titag" 
#define DATABASE_BOOKMARK_TABLE "bookmarks"
#define DATABASE_MEMVERSE_TABLE "memoryverses"
#define VERSES_TABLE "verses"
#define VERSES_BOOK_ROWID "book"
#define VERSES_NUM_ROWID "num_verse"
#define VERSES_TEXT_ROWID "verse"
#define VERSES_CHAPTERS_ROWID "chapter"
#define VERSES_HEADER_TAG "header"

@interface VersesDataBaseController: NSObject {

	NSString * _dbPath;
}
@property (nonatomic, retain) NSString * dbPath;

- (id) initDataBase;
- (void) addVerseTo:(NSString *) database; 

@end
