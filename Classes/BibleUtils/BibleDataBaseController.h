#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface QueryResults : NSObject {
}

@property (nonatomic) int verse;
@property (nonatomic) int header;
@property (nonatomic, assign) NSString * text;
@property (nonatomic, assign) const char * passage;
- (id) initWithVerse:(int) ver Passage:(const unsigned char *)txt Header:(int) head;
@end

@interface BookName : NSObject {
}
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSNumber * count;
- (id) initWithName:(NSString *) book Count:(NSNumber *) n;
@end


@interface BibleDataBaseController: NSObject {

}

+ (int) getBookIndex:(NSString *) name;
+ (NSString *) getBookNameAt:(int) idx;
+ (NSNumber *) getBookChapterCountAt:(int) idx;
+ (int) getVerseCount:(const char *) book chapter: (int) chap;
+ (int) maxBook;

+ (void) initBibleDataBase;
+ (void) closeBibleDataBase;

// returns books and chapters in the bible
+ (NSArray *) listBibleContents;

// finds a passage given bookname and chapter
+ (NSArray *) findBook: (const char *) book chapter: (int) chap; 

// returns passage that inlucde the string
+ (NSArray *) searchString:(const char *) string; 
@end
