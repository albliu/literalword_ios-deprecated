#define MYBUTTON_HEIGHT 40

@interface SelectorViewController: UIViewController {
}
@property (nonatomic, assign) id rootview;

-(id) initWithRootView:(id) view; 
- (void) dismissMyView;

-(UIButton *) generateButton:(const char *) t selector:(SEL) sel frame:(CGRect) f; 
- (void) loadClearView; 

@end
