//
//  AppDelegate.h
//  Techrice
//
//  Created by 藤賀 雄太 on 9/18/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(float)getDistance;
@end
