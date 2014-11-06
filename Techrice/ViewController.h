//
//  ViewController.h
//  Techrice
//
//  Created by 藤賀 雄太 on 9/18/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DetailViewController.h"
#import "AppDelegate.h"
@interface ViewController : UIViewController<GMSMapViewDelegate, UITabBarControllerDelegate>{
@private
    NSArray *markers;
    GMSCameraPosition *camera;
    AppDelegate *appDelegate;
}

@end
