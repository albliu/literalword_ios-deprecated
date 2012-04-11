#import "VersesViewController.h"

#define CELLWEBVIEW 300
#define CELLLABELVIEW 301

#define SEARCH_RESULTS_FONT_SCALE 100
#define VERSE_LABEL_HEIGHT 8 
#define VERSE_LABEL_FONT_SIZE 10
@interface SearchViewController : VersesViewController <UIWebViewDelegate, UISearchBarDelegate>
{
    NSArray *searchData;
}

@end
