#import "VersesData.h"

@interface MemoryVersesData : VersesData {
}

- (void) addToMemoryVerses:(int) book Chapter:(int) chap Verses:(NSArray *) ver Text:(NSString*) txt;
@end

