#import "VersesData.h"

@interface BookmarkData : VersesData {
}

- (void) addToBookmarks:(NSString *) bookname Book:(int) book Chapter:(int) chap Verses:(NSArray *) ver Text:(NSString*) txt;
@end

