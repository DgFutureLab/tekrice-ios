#define CHART_POINTS_MAX 6

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
    UILabel *distanceLabel;
    NSDate *requestDate;
    int howManyDays;
@public
    int nodeId;
}
@end
