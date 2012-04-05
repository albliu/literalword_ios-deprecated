@interface VerseEntry : NSObject {
}

@property (nonatomic, copy) NSString * book;
@property (nonatomic) int book_index;
@property (nonatomic) int chapter;
@property (nonatomic) int rowid;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * verses;

- (id) initWithBook:(int) bk Chapter:(int) chp Verses:(NSString *) ver Text:(NSString *)txt ID:(int) rid;

+ (NSString *) VerseArrayToString: (NSArray *) arr;
+ (NSArray *) VerseStringToArray: (NSString *) str;

@end

