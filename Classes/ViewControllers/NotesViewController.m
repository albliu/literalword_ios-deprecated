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
		_editView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		_editView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		//[_editView setDelegate:self];
	}
	return _editView;

}


- (void)loadView {

	[super loadView];

	[self.view addSubview:self.editView];

}

- (void) setupToolBar {

	NSMutableArray * toolbarItems = [[NSMutableArray alloc] initWithCapacity:1];
	UIBarButtonItem *bold = [[UIBarButtonItem alloc] initWithTitle:@"B" style:UIBarButtonItemStyleBordered target:self action:@selector(bold:)];
	[toolbarItems addObject:bold];
	[bold release];


	UIBarButtonItem *italics = [[UIBarButtonItem alloc] initWithTitle:@"i" style:UIBarButtonItemStyleBordered target:self action:@selector(italics:)];
	[toolbarItems addObject:italics];
	[italics release];

	[self setToolbarItems:toolbarItems];
	[toolbarItems release];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.editView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"document" ofType:@"html"]isDirectory:NO]]];	
    [self setupToolBar];
    [self.navigationController setToolbarHidden:NO];

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

@end
