//
//  NotesViewController.h
//  LiteralWord
//
//  Created by Albert Liu on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesViewController : UIViewController {
    
	UIWebView *_editView;
}

@property (nonatomic, retain) UIWebView *editView;
@end
