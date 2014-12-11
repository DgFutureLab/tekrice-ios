#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"
@interface SettingTableViewController : UITableViewController<MFMailComposeViewControllerDelegate>{
    AppDelegate *appDelegate;
    NSDictionary *settingData;
    int selectedSite;
    int mininumWaterLevel;
}

@end
