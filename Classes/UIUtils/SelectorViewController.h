#define MYBUTTON_HEIGHT 40

@protocol SelectorViewDelegate
- (void) selectedbook:(int) bk chapter:(int) ch;
- (void) SelectorViewDismissed;
- (void) gotoVerse:(int) v; 
@end

@interface SelectorViewController: UIViewController {
	CGRect myframe;
	id <SelectorViewDelegate> rootview;
}
@property (nonatomic, assign) id <SelectorViewDelegate> rootview;

-(id) initWithFrame: (CGRect) f RootView:(id) myview; 
- (void) dismissMyView;

-(UIButton *) generateButton:(const char *) t selector:(SEL) sel frame:(CGRect) f; 
- (void) loadClearView; 

@end
