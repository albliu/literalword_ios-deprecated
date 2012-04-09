#import "BibleHtmlGenerator.h"


@implementation BibleHtmlGenerator

+ (NSString *) loadHtmlBookWithVerse: (int)ver Highlights:(NSArray *) hlights Book: (const char *) book chapter:(int) chap scale:(float)myScale style:(reading_style) myStyle {
	NSString * passageHtml = [self.class header:myStyle scale:myScale];
	passageHtml = [passageHtml stringByAppendingString:[self.class bodyHeader:ver Highlights:hlights]];
	passageHtml = [passageHtml stringByAppendingString:[self.class  
		passageMod:[self.class passage:[BibleDataBaseController findBook:book chapter:chap]]]]; 

	passageHtml = [passageHtml stringByAppendingString:[self.class tail]];
	
	return passageHtml;	
}


+ (NSString *) loadHtmlBook:(const char *) book chapter:(int) chap scale:(float)myScale style:(reading_style) myStyle {

	return [self.class loadHtmlBookWithVerse: -1 Highlights:nil Book:book chapter:chap scale:myScale style:myStyle];
}

#pragma mark -- HTML Helper class

+ (NSString * ) header:(reading_style) myStyle scale:(float) myscale {

	NSUInteger font = 100 * myscale;
	NSString * passageHtml = [NSString stringWithUTF8String: "<!DOCTYPE html><head><link href=\"body.css\" rel=\"stylesheet\" type=\"text/css\" />"];
		
	if (myStyle == LITERARY_VIEW)
		passageHtml = [passageHtml stringByAppendingString:[NSString stringWithUTF8String: "<link href=\"literary.css\" rel=\"stylesheet\" type=\"text/css\" />"]];
	else if (myStyle == STUDY_VIEW)
		passageHtml = [passageHtml stringByAppendingString:[NSString stringWithUTF8String: "<link href=\"study.css\" rel=\"stylesheet\" type=\"text/css\" />"]];
	else 
		passageHtml = [passageHtml stringByAppendingString:[NSString stringWithUTF8String: "<link href=\"default.css\" rel=\"stylesheet\" type=\"text/css\" />"]];
	
	passageHtml = [passageHtml stringByAppendingString:[NSString stringWithFormat:@"<meta name = \"viewport\" content = \"width = device-width\"><style type=\"text/css\">body {-webkit-text-size-adjust:%d%%;}</style>",font]];
	
	passageHtml = [passageHtml stringByAppendingString:[NSString stringWithUTF8String: "</head><script language=\"javascript\" type=\"text/javascript\" src=\"jumpTo.js\"></script>"]];

	return passageHtml;

}
+ (NSString * ) bodyHeader: (int) ver Highlights:(NSArray *) hlights {
	NSString * body = [NSString stringWithFormat:@"<body onload=\"jumpToElement('%d');", ver];

	if (hlights) {
		for (int i = 0; i < [hlights count]; i++) {
			body = [body stringByAppendingString:[NSString stringWithFormat:@"highlight('%d');", [[hlights objectAtIndex:i] intValue]]];
		}
	}
	body = [body stringByAppendingString:[NSString stringWithUTF8String:"\">"]];
	return body;	
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
