//
//  SettingValueViewController.h
//  Techrice
//
//  Created by 藤賀 雄太 on 11/18/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SettingValueViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *picker;
    AppDelegate *appDelegate;
}


@end
