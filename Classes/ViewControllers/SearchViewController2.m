#import "SearchViewController2.h"
#import "BibleViewController.h"
#import "../BibleUtils/BibleDataBaseController.h"


@implementation SearchViewController2

#pragma mark - View lifecycle
- (void) loadView {
    [super loadView];

    UISearchBar * mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SEARCH_BAR_HEIGHT)];
    mySearchBar.delegate = self;
    [mySearchBar becomeFirstResponder];
 
    [self.view addSubview:mySearchBar];
    [mySearchBar release];

    myTable = [[UIWebView alloc] initWithFrame:CGRectMake(0, SEARCH_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - SEARCH_BAR_HEIGHT)];
    myTable.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    [self.view addSubview:myTable];

    myLoading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    myLoading.center = self.view.center;
    [self.view addSubview:myLoading];


}

- (void)viewDidLoad
{
    [super viewDidLoad];


}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

	[searchBar resignFirstResponder];

     [myTable loadHTMLString:[BibleDataBaseController searchStringToHtml:[searchBar.text UTF8String]] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

}

- (void)dealloc {
    [myTable release];
    [myLoading release];
    [super dealloc];
}

@end




