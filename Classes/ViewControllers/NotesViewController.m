//
//  NotesViewController.m
//  LiteralWord
//
//  Created by Albert Liu on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotesViewController.h"

@interface NotesViewController ()

@end

@implementation NotesViewController

@synthesize editView;   

-(UIWebView *) editView{
	if (_editView == nil) { 
		_editView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NOTES_TOOLBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
		_editView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		//[_editView setDelegate:self];
	}
	return _editView;

}

- (void) setupToolBar:(UIToolbar *) toolbar {

	UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStyleBordered target:self action:@selector(save:)];
	save.width = NOTES_TOOLBAR_HEIGHT;
	UIBarButtonItem *bold = [[UIBarButtonItem alloc] initWithTitle:@"B" style:UIBarButtonItemStyleBordered target:self action:@selector(bold:)];
	bold.width = NOTES_TOOLBAR_HEIGHT;
	UIBarButtonItem *italics = [[UIBarButtonItem alloc] initWithTitle:@"i" style:UIBarButtonItemStyleBordered target:self action:@selector(italics:)];
	italics.width = NOTES_TOOLBAR_HEIGHT;
	[toolbar setItems:[NSArray arrayWithObjects:save,bold, italics, nil]];	

	[bold release];
	[save release];
	[italics release];

	

}


- (void)loadView {

	[super loadView];

	[self.view addSubview:self.editView];

	UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, NOTES_TOOLBAR_HEIGHT)]; 
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth );
	[self.view addSubview:toolbar]; 
	[self setupToolBar:toolbar];
	[toolbar release];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.editView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"document" ofType:@"html"]isDirectory:NO]]];	
    [self.navigationController setToolbarHidden:YES];
	UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clear:)];

	self.navigationItem.rightBarButtonItem = clear;
	[clear release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void) bold:(id) ignored {

	NSString *jsString = [[NSString alloc] initWithUTF8String:"editor.bold()"];
	[self.editView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

}

- (void) italics: (id) ignored {

	NSString *jsString = [[NSString alloc] initWithUTF8String:"editor.italic()"];
	[self.editView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

}

- (void) save:(id) ignored {

	NSString *jsString = [[NSString alloc] initWithUTF8String:"editor.getHTML()"];
	NSString * obj = [self.editView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];

	[[[[UIAlertView alloc] initWithTitle: [NSString stringWithUTF8String:"saving"] message:obj delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] autorelease] show];
	

}
- (void) clear:(id) ignored {

	NSString *jsString = [[NSString alloc] initWithUTF8String:"editor.setHTML(' ')"];
	[self.editView stringByEvaluatingJavaScriptFromString:jsString];  
	[jsString release];
}
@end
