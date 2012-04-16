#import "NotesData.h"

@implementation NotesData

@synthesize myNotes = _myNotes;
@synthesize myDB = _myDB;

- (id) init {
    self.myDB = nil;
    self.myNotes = [[NSMutableArray alloc] initWithCapacity:10];
		
    return self;
}


- (void) clear {
	[self.myDB deleteAllNotes];
	[self.myNotes removeAllObjects];
}

- (void) removeFromList:(int) index {

	NoteEntry * note = [self.myNotes objectAtIndex:index];
	[self.myNotes removeObjectAtIndex:index];
	[self.myDB deleteNote:note.rowid];	
}

- (void) addToList:(NoteEntry *) note {

	note.rowid = [self.myDB addNote:[note.title UTF8String] Body:[note.body UTF8String]];
	[self.myNotes addObject:note];
}


- (void) addNewNote:(NSString *) title Body:(NSString *) body {
		
	NoteEntry * entry = [[NoteEntry alloc] initWithTitle:title Body: body ID:-1];
	[self addToList:entry];
	[entry release];	

}

- (void) dealloc {
	[self.myDB release];	
	[self.myNotes release];
	[super dealloc];
}


@end
