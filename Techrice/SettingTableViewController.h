#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"
@interface SettingTableViewController : UITableViewController<MFMailComposeViewControllerDelegate>{
    AppDelegate *appDelegate;
    NSDictionary *settingData;
    NSDictionary *sites;
    int selectedSiteId;
    int mininumWaterLevel;
    bool demo;
}

@end
