#import "UIPopupPickerController.h"

@implementation UIPopupPickerController
@synthesize list = _list, picker= _picker;

- (void)loadView {
	[super loadView];
	[self.view addSubview:self.picker];

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

- (void)dealloc {
    [self.picker release];
    [self.list release];
    [super dealloc];
}

/*
- (IBAction)doDoneButton:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
*/

#pragma mark -
#pragma mark UIPickerView DataSource methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{ return 1; }

- (NSInteger)pickerView: (UIPickerView *)pView numberOfRowsInComponent: (NSInteger) component
{ return [self.list count]; }

#pragma mark UIPickerView Delegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString * title =  [self.list objectAtIndex:row];
    return title;
}
@end
