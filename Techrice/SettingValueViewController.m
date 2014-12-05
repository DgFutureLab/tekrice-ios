//
//  SettingValueViewController.m
//  Techrice
//
//  Created by 藤賀 雄太 on 11/18/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import "SettingValueViewController.h"


@interface SettingValueViewController ()

@end

@implementation SettingValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    //    picker
    picker = [[UIPickerView alloc]init];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [picker selectRow:appDelegate->distanceThreshold inComponent:0 animated:NO];
    [self.view addSubview:picker];
    NSDictionary *attributeDictionary = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributeDictionary];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return 100.0;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component{
            return [NSString stringWithFormat:@"%ldcm", row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    appDelegate->distanceThreshold = (int)[pickerView selectedRowInComponent:component];
    
}

@end
