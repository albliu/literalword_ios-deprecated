#import "VerseEntry.h"
#import "BibleDataBaseController.h"

#define COM_DEL ","
#define DASH_DEL "-"

@implementation VerseEntry 

@synthesize book = _book;
@synthesize book_index = _book_index;
@synthesize chapter = _chapter;
@synthesize verses = _verses;
@synthesize text = _text;
@synthesize rowid = _rowid;

- (id) initWithBook:(int) bk Chapter:(int) chp Verses:(NSString *) ver Text:(NSString *)txt ID:(int) rid {
	self.text = txt;
	self.rowid = rid;
	self.verses = ver;
	self.chapter = chp;
	self.book_index = bk; 
	self.book = [BibleDataBaseController getBookNameAt:bk];

	return self;
}


+ (NSString *) VerseArrayToString: (NSArray *) arr {
	if (!arr) return nil;

	int lastV = [[arr objectAtIndex:0] intValue];
	BOOL dash = NO;
	NSString * ret = [NSString stringWithFormat:@"%d", lastV];
	
	for (int i = 1; i < [arr count]; i++) {

		int v = [[arr objectAtIndex:i] intValue];
		if (!dash) {
			if ((v - lastV) == 1) {
				ret = [ret stringByAppendingString:[NSString stringWithFormat:@"%s", DASH_DEL]];
				dash = YES;	
			} else {
				ret = [ret stringByAppendingString:[NSString stringWithFormat:@"%s%d", COM_DEL, v]];
			}			
		} else {
			if ((v - lastV) != 1) {
				ret = [ret stringByAppendingString:[NSString stringWithFormat:@"%d%s%d",lastV, COM_DEL, v]];
				dash = NO;
			} // else just keep going
		}
		lastV = v;
	}

	if (dash) ret = [ret stringByAppendingString:[NSString stringWithFormat:@"%d",lastV]];
	return ret;

}

// this array will be autoreleased
+ (NSArray *) VerseStringToArray: (NSString *) str {
	// We assume the NSArray is in sorted order
	if (!str) return nil;
	int j;
	NSMutableArray * ret = [[[NSMutableArray alloc] initWithCapacity:1] autorelease]; 
	
	// this array will be autotreleased
	NSArray * comm = [str componentsSeparatedByString:@COM_DEL];

	for (NSString * obj in comm) {
		// this array will be autotreleased
		NSArray * dash = [obj componentsSeparatedByString:@DASH_DEL];
		if ([dash count] == 1) {
			[ret addObject:[dash objectAtIndex:0]];
		} else if ([dash count] == 2) {

			for (j = [[dash objectAtIndex:0] intValue]; j <= [[dash objectAtIndex:1] intValue]; j ++) {
				[ret addObject:[NSString stringWithFormat:@"%d", j]];
			} 

		} else {
			NSLog(@"verse string is not in correct format");
			return nil;
		}
	}
	return ret;
}

@end

