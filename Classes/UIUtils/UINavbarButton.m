//
//  UINavbarButton.m
//
//  Created by Achim Heynen on 17.10.10.
//  Copyright (c) 2010 Achim Heynen Software-Entwicklung. All rights reserved.
//  www.onedollarapp.com
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "UINavbarButton.h"

#define kUINavbarButtonCapWidth 7.0
#define kUINavbarButtonHeight 30.0

@implementation UINavbarButton

- (id)initWithWidth:(CGFloat)width style:(UIBarStyle)style target:(id) target action:(SEL)action {
    [self initWithFrame:CGRectMake(0.0, 0.0, width, kUINavbarButtonHeight)];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13.0]];
    [self.titleLabel setShadowColor:[UIColor blackColor]];
    [self.titleLabel setShadowOffset:CGSizeMake(0.0, -1.0)];

    UIImage *backgroundImage = nil;
    if (style == UIBarStyleBlack || style == UIBarStyleBlackOpaque || style == UIBarStyleBlackTranslucent) {
        backgroundImage = [[[UIImage imageNamed:@"navbar_button_black.png"] stretchableImageWithLeftCapWidth:kUINavbarButtonCapWidth topCapHeight:0.0] retain];
    } else {
        backgroundImage = [[[UIImage imageNamed:@"navbar_button_gray.png"] stretchableImageWithLeftCapWidth:kUINavbarButtonCapWidth topCapHeight:0.0] retain];
    }
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [backgroundImage release];
    
    return self;
}

- (id)initWithImage:(UIImage *)image style:(UIBarStyle)style target:(id) target action:(SEL)action {
    [self initWithWidth:(image.size.width + 2 * kUINavbarButtonCapWidth) style:style target:target action:action];
    
    [self setImage:image forState:UIControlStateNormal];
    
    return self;
}

- (id)initWithTitle:(NSString *)title style:(UIBarStyle)style target:(id) target action:(SEL)action {
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13.0]];
    [label setShadowOffset:CGSizeMake(0.0, -1.0)];
    [label setText:title];
    [label sizeToFit];
    
    [self initWithWidth:(label.bounds.size.width + 2 * kUINavbarButtonCapWidth) style:style target:target action:action];
    [label release];
    
    [self setTitle:title forState:UIControlStateNormal];
    
    return self;
}


@end
