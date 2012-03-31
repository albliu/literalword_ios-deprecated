
@interface MyGestureRecognizer: NSObject<UIGestureRecognizerDelegate> {
}

@property (nonatomic, assign) id delegate;
-(MyGestureRecognizer *) initWithDelegate:(id) delegate View:(UIView *) view;
	

@end
