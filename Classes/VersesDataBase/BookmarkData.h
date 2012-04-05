#import "VersesData.h"

@interface BookmarkData : VersesData {
}

- (void) addToBookmarks:(int) book Chapter:(int) chap Verses:(NSArray *) ver Text:(NSString*) txt;
@end

