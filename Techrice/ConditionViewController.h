#define THRESHOLD 55

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "AppDelegate.h"
@interface ConditionViewController : UIViewController{
    AppDelegate *appDelegate;
    UIImageView *conditionImageViewRice, *conditionImageViewWater;
    bool goodCondition;
    float lastDistance;
    
    NSTimer *timer;
}

@end
