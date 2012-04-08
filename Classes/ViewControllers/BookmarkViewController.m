#import "BookmarkViewController.h"
#import "BibleViewController.h"


@implementation BookmarkViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	VerseEntry * entry = [self.myData.myVerses objectAtIndex:[indexPath row]];

	[self.delegate selectedbook:entry.book_index chapter:entry.chapter verse:[entry.verses intValue]];

	[self.navigationController popToRootViewControllerAnimated:YES];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    // Set up the cell...
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	VerseEntry * entry = [self.myData.myVerses objectAtIndex:[indexPath row]];
	if ( [entry.verses intValue] == 0)
	   cell.textLabel.text = [NSString stringWithFormat:@"%@ %d", entry.book, entry.chapter];
	else
	   cell.textLabel.text = [NSString stringWithFormat:@"%@ %d:%@", entry.book, entry.chapter, entry.verses ];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

@end
