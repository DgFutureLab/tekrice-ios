//
//  AppDelegate.m
//  Techrice
//
//  Created by 藤賀 雄太 on 9/18/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "TableViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyD02od1MXyqSOzrvMI-W_Je4kk_huiwC3I"];
    
    
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
//    navigationController1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cat" image:[UIImage imageNamed:@"darkgreen.png"] selectedImage:[UIImage imageNamed:@"darkgreen.png"]];
    navigationController1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:[[TableViewController alloc] init]];
    navigationController2.tabBarItem =[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    
    NSArray *tabs = [NSArray arrayWithObjects:navigationController1, navigationController2, nil];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    [tabBarController setViewControllers:tabs animated:NO];
    [self.window addSubview:tabBarController.view];
    self.window.rootViewController = tabBarController;

    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(float)getDistance{
    NSLog(@"getditance");
    // get data
    NSString *url = @"http://128.199.191.249/reading/node_2/distance";
    //NSURLからNSURLRequestを作る
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //サーバーとの通信を行う
    NSData *json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (json != nil) {
        //ローカルに保存
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result forKey:@"test"];
        BOOL successful = [defaults synchronize];
        if (successful) {
//            NSLog(@"%@", @"データの保存に成功しました。");
        }
        //JSONをパース
        NSArray *array = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        float distance =  [[[[array valueForKey:@"data"] valueForKey:@"value"] objectAtIndex:0] floatValue];
        NSLog(@"return distance:%f", distance);
        return distance;
    }else{
        NSLog(@"getdistance failed");
        return 0;
    }
}

-(NSArray*)getNodeArray{
    NSLog(@"getLocationArray");
    NSString *url = @"http://128.199.191.249/node/all";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (json != nil) {
        //JSONをパース
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = [dictionary objectForKey:@"objects"];
        self.nodeArray = array;
        NSMutableArray *mutableDistanceArray = [NSMutableArray array];
        for (int i=0; i<array.count-1; i++) {
            [mutableDistanceArray addObject:[[[array objectAtIndex:i] valueForKey:@"sensors"][0] valueForKey:@"latest_reading"]];
        }
        self.distanceArray = [NSArray arrayWithArray:mutableDistanceArray];
        return array;
    }else{
        NSArray *array;
        return array;
    }
}

@end
