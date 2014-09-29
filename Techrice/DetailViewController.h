#import <UIKit/UIKit.h>
#import "JBChartView/JBChartView.h"
#import "JBChartView/JBLineChartView.h"
#import "MCPercentageDoughnutView.h"
#import "AppDelegate.h"

@interface DetailViewController : UIViewController{
    AppDelegate *appDelegate;
    UILabel *distanceLabel;
    NSTimer *timer;
}

@end
