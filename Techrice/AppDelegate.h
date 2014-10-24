//
//  AppDelegate.h
//  Techrice
//
//  Created by 藤賀 雄太 on 9/18/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

#define THRESHOLD 80

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSArray *nodeArray;
@property (nonatomic,retain) NSArray *distanceArray;

-(float)getDistance:(NSNumber*)nodeId;
-(NSArray*)getNodeArray;
@end
