#import "BibleHtmlGenerator.h"


@interface BibleHtmlGenerator(HTML_Helper) {
}
+ (NSString * ) header:(reading_style) myStyle scale:(CGFloat) myscale;
+ (NSString * ) tail;
+ (NSString * ) passage:(NSArray *) results;
+ (NSString * ) passageMod:(NSString *) passage;
@end


@implementation BibleHtmlGenerator

@synthesize nasbbible = _nasbbible;

- (BibleHtmlGenerator *) initWithDB: (BibleDataBaseController *) db Scale:(CGFloat) s {
	self.nasbbible = db;
	_scale = s;
	return self;
}


- (NSString *) loadHtmlBook:(const char *) book chapter:(int) chap style:(reading_style) myStyle {
	NSString * passageHtml = [self.class header:myStyle scale:_scale];
	passageHtml = [passageHtml stringByAppendingString:[self.class  
		passageMod:[self.class passage:[self.nasbbible findBook:book chapter:chap]]]]; 

	passageHtml = [passageHtml stringByAppendingString:[self.class tail]];
	
	return passageHtml;	


}

- (CGFloat) getScale {
	return _scale;
}

-(void) setScale:(CGFloat) scale {
	_scale = scale;
}

- (NSArray *) listBibleContents {
	return [self.nasbbible listBibleContents];
}


#pragma mark -- HTML Helper class

+ (NSString * ) header:(reading_style) myStyle scale:(CGFloat) myscale {

	NSUInteger font = 100 * myscale;
	NSString * passageHtml = [NSString stringWithUTF8String: "<!DOCTYPE html><head><link href=\"body.css\" rel=\"stylesheet\" type=\"text/css\" />"];
		
	if (myStyle == LITERARY_VIEW)
		passageHtml = [passageHtml stringByAppendingString:[NSString stringWithUTF8String: "<link href=\"literary.css\" rel=\"stylesheet\" type=\"text/css\" />"]];
	else if (myStyle == STUDY_VIEW)
		passageHtml = [passageHtml stringByAppendingString:[NSString stringWithUTF8String: "<link href=\"study.css\" rel=\"stylesheet\" type=\"text/css\" />"]];
	else 
		passageHtml = [passageHtml stringByAppendingString:[NSString stringWithUTF8String: "<link href=\"default.css\" rel=\"stylesheet\" type=\"text/css\" />"]];
	
	passageHtml = [passageHtml stringByAppendingString:[NSString stringWithFormat:@"<style type=\"text/css\">body {-webkit-text-size-adjust:%d%%;}</style>",font]];
	
	passageHtml = [passageHtml stringByAppendingString:[NSString stringWithUTF8String: "</head><script language=\"javascript\" type=\"text/javascript\" src=\"jumpTo.js\"></script><body>"]];

	return passageHtml;

}

+ (NSString * ) tail {
	NSString * passageHtml = [ NSString stringWithUTF8String: "<br><br><br><cp>New American Standard Bible <br>Copyright (c) 1960, 1962, 1963, 1968, 1971, 1972, 1973, 1975, 1977, 1995 by The Lockman Foundation</cp><br><br /><br /></body>"]; 
	
	return passageHtml;
}

+ (NSString * ) passage:(NSArray *) results {
	NSString * passage = [ NSString stringWithUTF8String: ""];	


	for (QueryResults * ret in results) {
//		printf("head: %d, ver: %d, passage: %s\n", ret.header, ret.verse, ret.passage);
		passage = [passage stringByAppendingFormat:ret.text];		
	}



	return passage;

}
+ (NSString * ) passageMod:(NSString *) passage {
	

	return passage;

}


@end
