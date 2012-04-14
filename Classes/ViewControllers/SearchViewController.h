#import "VersesViewController.h"

#define CELL_SPACING 4

#define VERSE_LABEL_HEIGHT 10 
#define VERSE_LABEL_FONT_SIZE 10

#define CELLTEXTVIEW 300
#define CELLLABELVIEW 301

@interface SearchViewController : VersesViewController <UIWebViewDelegate, UISearchBarDelegate>
{
    NSMutableArray *searchData;
    NSArray * searchResults;
    UIActivityIndicatorView * myLoading;
 }

@end
