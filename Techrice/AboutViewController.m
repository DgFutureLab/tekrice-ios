//
//  AboutViewController.m
//  Techrice
//
//  Created by 藤賀 雄太 on 12/5/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    textView.editable = NO;
    [textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:28]];
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    textView.text = @"Techrice is an open data sensor network based in Kamogawa, Japan. Techrice wants to help local farmers monitoring rice fields water levels.\n\nStar topology sensor network designed using Freaklabs open hardware. Hatake (畑) is the Japanese name for \"rice field\".\n\nThis is an open source / open hardware collaboration by Freaklabs( http://www.freaklabs.org/ ), Hacker Farm and Future Lab( http://www.fljapan.com/about ).";
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
