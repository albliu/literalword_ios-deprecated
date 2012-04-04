#import "MemoryVerseViewController.h"
#import "BibleViewController.h"


@implementation MemoryVerseViewController

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    // Set up the cell...
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	VerseEntry * entry = [self.myData.myVerses objectAtIndex:[indexPath row]];

	cell.textLabel.text = [NSString stringWithFormat:@"%@ %d:%@", entry.book, entry.chapter, entry.verses ];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	VerseEntry * entry = [self.myData.myVerses objectAtIndex:[indexPath row]];

	[[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"MemoryVerses"] message: [NSString stringWithFormat:@"%@ %d:%@", entry.book, entry.chapter, entry.verses] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease] show];
}

@end
