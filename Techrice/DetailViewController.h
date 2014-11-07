//
//  DetailViewController.h
//  Techrice
//
//  Created by 藤賀 雄太 on 10/15/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTGlassScrollView.h"
#import "AppDelegate.h"
#import "PNChart.h"
@interface DetailViewController : UIViewController{

@private
    BTGlassScrollView *glassScrollView;
    AppDelegate *appDelegate;
    NSArray *distanceArray;
    float lastDistance;
    UILabel *distanceLabel, *boxDistanceLabel;
    PNLineChart * lineChartDistance;
    UIView *view;
    UIView *box0;
@public
    int nodeId;
}
@end
