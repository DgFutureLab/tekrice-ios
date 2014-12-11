#define DISTANCE_TO_GROUND 100

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
@public
    int minimumWaterLevel;
    int currentSite;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSArray *nodeArray;
@property (nonatomic,retain) NSArray *distanceArray;

-(NSArray*)getDistance:(NSNumber*)nodeId parameter:(NSString*)parameter;
-(NSArray*)getNodeArray;
@end
