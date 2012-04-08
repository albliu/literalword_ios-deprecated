#define MYBUTTON_HEIGHT 40

@interface SelectorViewController: UIViewController {
	CGRect myframe;
}
@property (nonatomic, assign) id rootview;

-(id) initWithFrame: (CGRect) f RootView:(id) myview; 
- (void) dismissMyView;

-(UIButton *) generateButton:(const char *) t selector:(SEL) sel frame:(CGRect) f; 
- (void) loadClearView; 

@end
