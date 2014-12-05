#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SettingValueViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *picker;
    AppDelegate *appDelegate;
}


@end
