@interface NavViewController : UINavigationController {
}

@end

@interface LiteralWordApplication: NSObject <UIApplicationDelegate> {
	UIWindow *_window;
	NavViewController * _rootview;
}
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) NavViewController * rootview;
@end

