//
//  AppDelegate.h
//  Techrice
//
//  Created by 藤賀 雄太 on 9/18/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#define DISTANCE_TO_GROUND 100

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
@public
    int distanceThreshold;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSArray *nodeArray;
@property (nonatomic,retain) NSArray *distanceArray;

-(NSArray*)getDistance:(NSNumber*)nodeId parameter:(NSString*)parameter;
-(NSArray*)getNodeArray;
@end
