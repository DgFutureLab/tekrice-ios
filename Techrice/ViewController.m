#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SettingTableViewController.h"
@interface ViewController ()

@end

@implementation ViewController{
    GMSMapView *mapView_;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.tabBarController.delegate = self;
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"techricelogo.png"]];
    titleImageView.frame = CGRectMake(-72, -30, 149, 44);
    UIView *titleView = [[UIView alloc] init];
    [titleView addSubview:titleImageView];
    self.navigationItem.titleView = titleView;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.1 alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Hard code
    camera = [GMSCameraPosition cameraWithLatitude:35.14404025
                                         longitude:139.988354
                                              zoom:18.5];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    mapView_.mapType = kGMSTypeSatellite;
    path = [GMSMutablePath path];
    self.view = mapView_;
    [self performSelectorInBackground:@selector(setMarker) withObject:nil];

    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    [self.view addSubview:tabBar];
    
    //add setting button
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonTapped)];
    settingButton.title = @"\u2699";
    settingButton.tintColor = [UIColor whiteColor];
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingButton setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = settingButton;
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    settingData = [defaults objectForKey:@"cache/setting"];
    if (!settingData) {
        NSLog(@"%@", @"ViewController_viewDidLoad: no setting data in cache");
    }else{
        NSLog(@"%@", settingData);
    }
    _currentSite = [[settingData objectForKey:@"site"] intValue];
    _minimumWaterLevel = [[settingData objectForKey:@"minimumWaterLevel"] intValue];
    
    appDelegate->currentSite = _currentSite;
    appDelegate->minimumWaterLevel = _minimumWaterLevel;
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
    self.tabBarController.delegate = self;
    [self setMarkerColor];
}

- (void) setMarker{
    NSLog(@"ViewController-setMarker");
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    nodeArray = [[[appDelegate getData:@"site/1"] valueForKey:@"objects"][0] objectForKey:@"nodes"];
    appDelegate.nodeArray = nodeArray;
    [self setMarkerColor];

    // update camera
    NSLog(@"update camera to fit markers %lu", path.count);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [mapView_ moveCamera:update];
}

- (void)setMarkerColor{
    NSLog(@"setMarkerColor");
    // Creates a marker in the center of the map.
    UIImage *iconImage = [UIImage imageNamed:@"darkgreen.png"];
    UIImage *iconImageProblem = [UIImage imageNamed:@"allred.png"];
    for (int i =0; i<nodeArray.count; i++) {
        NSArray *sensors =[NSArray arrayWithArray:[nodeArray[i] valueForKey:@"sensors"]];
        for (int j=0; j<sensors.count; j++) {
            if ([[sensors[j] valueForKey:@"alias"] isEqualToString:@"distance"] && ![[nodeArray[i] valueForKey:@"latitude"] isEqual:[NSNull null]] && ![[nodeArray[i] valueForKey:@"longitude"] isEqual:[NSNull null]] && ![[sensors[j] valueForKey:@"latest_reading"] isEqual:[NSNull null]] && ![[sensors[j] valueForKey:@"latest_reading"] isEqual:@""]) {
                // Google Maps SDK must happend on the main thread
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    marker.position = CLLocationCoordinate2DMake([[nodeArray[i] valueForKey:@"latitude"] doubleValue], [[nodeArray[i] valueForKey:@"longitude"] doubleValue]);
                    [path addCoordinate:marker.position];
                    if (DISTANCE_TO_GROUND-[[[sensors[j] valueForKey:@"latest_reading"] valueForKey:@"value"] floatValue] > appDelegate->minimumWaterLevel) {
                        marker.icon = iconImage;
                    }else{
                        marker.icon = iconImageProblem;
                    }
                    marker.userData = [nodeArray[i] valueForKey:@"id"];
                    marker.map = mapView_;
                }];
            }
        }
    }
}

- (void)settingButtonTapped{
    NSLog(@"settingButtonTapped");
    SettingTableViewController *settingTableViewController = [[SettingTableViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingTableViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self backToCenterButtonTapped];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    NSLog(@"tapMarker");
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController->nodeId = marker.userData;
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
    return YES;
}

- (void)backToCenterButtonTapped{
    camera = [GMSCameraPosition cameraWithLatitude:35.14404025
                                         longitude:139.988354
                                              zoom:18.5];
    [mapView_ animateToCameraPosition:camera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
