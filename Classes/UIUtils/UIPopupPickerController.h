
@interface UIPopupPickerController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
}
@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) NSArray *list;

@end
