#define THRESHOLD 55

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "UICountingLabel.h"
#import "CAKeyframeAnimation+AHEasing.h"

@interface ConditionViewController : UIViewController{
@private
    AppDelegate *appDelegate;
    UIImageView *conditionImageViewRice, *conditionImageViewWater;
    bool goodCondition;
    UICountingLabel *distanceLabel;
    BOOL animating;
    
    //debug
    UISlider *slider;
    NSDictionary *latestWaterLevelData;
    float latestWaterLevel;
    float oldWaterLevel;
    bool enableUpdating;
@public
    NSDictionary *nodeData;
}

@end
