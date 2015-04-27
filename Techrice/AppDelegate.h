#define DISTANCE_TO_GROUND 100

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
@public
    int minimumWaterLevel;
    int currentSite;
    bool demo;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSArray *nodeArray;
@property (nonatomic,retain) NSArray *distanceArray;

-(NSDictionary*)getData:(NSString*)parameter;

@end
