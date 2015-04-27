#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DetailViewController.h"
#import "AppDelegate.h"
@interface ViewController : UIViewController<GMSMapViewDelegate, UITabBarControllerDelegate>{
@private
    NSArray *markers;
    GMSCameraPosition *camera;
    GMSMutablePath *path;
    AppDelegate *appDelegate;
    NSArray *nodeArray;
    NSDictionary *settingData;
    
    int _minimumWaterLevel;
    int _currentSite;
    bool _demo;
}

@end
