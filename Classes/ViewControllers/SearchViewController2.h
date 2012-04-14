#import "VersesViewController.h"

#define CELL_SPACING 4
#define SEARCH_BAR_HEIGHT 40
#define LOAD_REFRESH_RATE 50 
#define VERSE_LABEL_HEIGHT 10 
#define VERSE_LABEL_FONT_SIZE 10

@interface SearchViewController2 : UIViewController <UIWebViewDelegate, UISearchBarDelegate>
{
    UIWebView * myTable;
    NSArray * searchResults;
    UIActivityIndicatorView * myLoading;
 }

@end
