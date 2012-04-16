//
//  NotesEditViewController.h
//  LiteralWord
//
//  Created by Albert Liu on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define NOTES_TOOLBAR_HEIGHT 35 

#import <UIKit/UIKit.h>
#import "NotesDbController.h"

@protocol NotesEditDelegate
- (void) saveNote: (NSString *) title Body:(NSString *) body;
@end


@interface NotesEditViewController : UIViewController<UIWebViewDelegate> {
	NoteEntry * initNote;    
	UIWebView *_editView;
	id <NotesEditDelegate> myDelegate;
}

@property (nonatomic, retain) UIWebView *editView;
@property (nonatomic, assign) id <NotesEditDelegate> myDelegate;

- (void) newNote;
- (void) loadNote:(NoteEntry *) note;
@end
