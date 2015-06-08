#define THRESHOLD 55

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "UICountingLabel.h"
@interface ConditionViewController : UIViewController{
@private
    AppDelegate *appDelegate;
    UIImageView *conditionImageViewRice, *conditionImageViewWater;
    bool goodCondition;
    UICountingLabel *distanceLabel;
    
    //debug
    UISlider *slider;
    NSDictionary *latestWaterLevelData;
    float latestWaterLevel;
    bool enableUpdating;
@public
    NSDictionary *nodeData;
}

@end
