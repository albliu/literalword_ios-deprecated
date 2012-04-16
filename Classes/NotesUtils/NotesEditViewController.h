//
//  NotesEditViewController.h
//  LiteralWord
//
//  Created by Albert Liu on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesDbController.h"

#define NOTES_TOOLBAR_HEIGHT 35 
#define TITLE_MAX_CHAR 25
#define NEW_NOTE -1
@protocol NotesEditDelegate
- (void) saveNote: (NSString *) title Body:(NSString *) body ID:(int) i;
@end


@interface NotesEditViewController : UIViewController<UIWebViewDelegate, UIAlertViewDelegate, UITextViewDelegate> {
	int currNote_id;
	UIWebView *_editView;
	id <NotesEditDelegate> myDelegate;

	CGRect myinitFrame;
}

@property (nonatomic, retain) UIWebView *editView;
@property (nonatomic, assign) id <NotesEditDelegate> myDelegate;

- (id) initWithFrame: (CGRect) f;
- (void) newNote;
- (void) loadNote:(NoteEntry *) note;
@end
