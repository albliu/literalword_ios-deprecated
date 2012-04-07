#import "BookmarkViewController.h"
#import "BibleViewController.h"


@implementation BookmarkViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	VerseEntry * entry = [self.myData.myVerses objectAtIndex:[indexPath row]];

	[self.delegate selectedbook:entry.book_index chapter:entry.chapter verse:[entry.verses intValue]];

	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
