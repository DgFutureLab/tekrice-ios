#define THRESHOLD 55

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "AppDelegate.h"
@interface ConditionViewController : UIViewController{
@private
    AppDelegate *appDelegate;
    UIImageView *conditionImageViewRice, *conditionImageViewWater;
    bool goodCondition;
    UILabel *distanceLabel;
    
    //debug
    UISlider *slider;
    NSDictionary *latestWaterLevelData;
    float latestWaterLevel;
@public
    NSDictionary *nodeData;
}

@end
