#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface TableViewController : UITableViewController<UITabBarControllerDelegate>{
    NSArray *nodeArray;
    NSMutableArray *displayDataArray;
    AppDelegate *appDelegate;
    UISegmentedControl *seg;
    int numberOfRows;
}

@end
