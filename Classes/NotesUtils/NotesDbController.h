#import "sqlite3.h"


#define NOTES_TABLE "notes"
#define NOTES_DB "myNotes.db"

#define KEY_ROWID "_id"
#define KEY_TITLE "title" 
#define KEY_BODY "body"

@interface NoteEntry : NSObject {
}

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * body;
@property (nonatomic) int rowid;

- (id) initWithTitle :(NSString *) t Body:(NSString *) b ID:(int) rid;
@end 

@interface NotesDbController: NSObject {
}


+ (void) openDataBase;
+ (void) closeDataBase;

- (int) addNote:(const char *) title Body:(const char *) body; 
- (NSArray *) findAllNotes; 
- (void) deleteNote: (int) row_id;
- (void) deleteAllNotes;
- (NoteEntry *) findNote: (int) row_id; 

@end


