#import "AppDelegate.h"

#import "ViewController.h"
#import "TableViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Google Map setting
    [GMSServices provideAPIKey:@"AIzaSyD02od1MXyqSOzrvMI-W_Je4kk_huiwC3I"];
    // Map view
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    navigationController1.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Map", nil)  image:[UIImage imageNamed:@"pin.png"] tag:1];
    // List View
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:[[TableViewController alloc] init]];
    navigationController2.tabBarItem =[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"List", nil) image:[UIImage imageNamed:@"list.png"] tag:0];
    // TabBar setting
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.7 alpha:1.0]];;
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

-(NSDictionary *)getData:(NSString*)parameter{
    NSLog(@"AppDelegate-getData");
    // get data
    NSString *url;
    if (parameter) {
        url = [@"http://128.199.120.30/" stringByAppendingString: parameter];
    }else{
        url = @"http://128.199.120.30/nodes";
    }
    //NSURLからNSURLRequestを作る
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //サーバーとの通信を行う
    NSData *json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (json != nil) {
        //ローカルに保存
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:result];
        if ([[result valueForKey:@"status"] intValue] != 429) {
            [defaults setObject:dataSave forKey:[@"cache/node/" stringByAppendingString:parameter]];
            BOOL successful = [defaults synchronize];
            if (successful) {
                NSLog(@"AppDelegate-getDistance: saved data successfully.");
            }
            return result;
        }else{
            //too many requests
            NSLog(@"error: %@", result);
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[@"cache/node/" stringByAppendingString:parameter]];
            NSDictionary *savedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (savedDictionary) {
                return savedDictionary;
            } else {
                NSLog(@"AppDelegate-getDistance: %@", @"no data in cache.");
                return 0;
            }
        }
    }else{
        NSLog(@"AppDelegate-getDistance: getdistance failed");
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[@"cache/node/" stringByAppendingString:parameter]];
        NSDictionary *savedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (savedDictionary) {
            return savedDictionary;
        } else {
            NSLog(@"AppDelegate-getDistance: %@", @"no data in cache.");
            return 0;
        }
    }
}

@end
