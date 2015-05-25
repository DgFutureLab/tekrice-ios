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
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    mapView_.mapType = kGMSTypeSatellite;
    path = [GMSMutablePath path];
    self.view = mapView_;
    
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
        _minimumWaterLevel = 0;
        _currentSite = [[[[appDelegate getData:@"sites"] objectForKey:@"objects"][0] objectForKey:@"id"] intValue];
        _demo = false;
    }else{
        NSLog(@"%@", settingData);
        _currentSite = [[settingData objectForKey:@"site"] intValue];
        _minimumWaterLevel = [[settingData objectForKey:@"minimumWaterLevel"] intValue];
        _demo = [[settingData objectForKey:@"demo"] boolValue];
    }
    NSLog(@"read from setting data:_currentSite%d - _minimumWaterLevel%d", _currentSite, _minimumWaterLevel);
    
    appDelegate->currentSite = _currentSite;
    appDelegate->minimumWaterLevel = _minimumWaterLevel;
    appDelegate->demo = _demo;
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"ViewController: viewWillAppear");
    self.tabBarController.delegate = self;
    [self performSelectorInBackground:@selector(setMarker) withObject:nil];
}

-(NSMutableArray *)getDummyData{
    NSMutableArray *outputArray = [NSMutableArray array];
    [outputArray addObject:[self setDummyData:42.2 latitude:35.14404025 longitude:139.988354 id:0]];
    [outputArray addObject:[self setDummyData:10.2 latitude:35.14354 longitude:139.988104 id:1]];
    return outputArray;
}

- (NSDictionary *)setDummyData:(float)value
                      latitude:(float)latitude
                     longitude:(float)longitude
                            id:(int)ID{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    [mutableDictionary setObject:@"distance" forKey:@"alias"];
    NSDictionary *valueDictionary = @{@"value":[NSNumber numberWithFloat:value]};
    [mutableDictionary setObject:valueDictionary forKey:@"latest_reading"];
    [mutableArray addObject:mutableDictionary];
    NSDictionary *dictionary = @{@"sensors":mutableArray,
                                 @"latitude":[NSNumber numberWithFloat:latitude],
                                 @"longitude":[NSNumber numberWithFloat:longitude],
                                 @"id":[NSNumber numberWithInt:ID]};
    return dictionary;
}

// get marker's data and marker's image using setMarkerColor function
- (void) setMarker{
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary *currentSiteData = [appDelegate getData:[NSString stringWithFormat:@"site/%d", appDelegate->currentSite]];
    if ([currentSiteData valueForKey:@"objects"] && [[currentSiteData valueForKey:@"objects"] count] > 0 && [[currentSiteData valueForKey:@"objects"][0] objectForKey:@"nodes"]) {
        nodeArray = [[currentSiteData valueForKey:@"objects"][0] objectForKey:@"nodes"];
//      nodeArray = [self getDummyData]; //dummy
        appDelegate.nodeArray = nodeArray;
        [self setMarkerColor];
    }
}

// set marker's color to red or green
- (void)setMarkerColor{
    NSLog(@"setMarkerColor");
    // Creates a marker in the center of the map.
    UIImage *iconImage = [UIImage imageNamed:@"darkgreen.png"];
    UIImage *iconImageProblem = [UIImage imageNamed:@"allred.png"];
    [path removeAllCoordinates];
    // Google Maps SDK must happend on the main thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [mapView_ clear];
    for (int i =0; i<nodeArray.count; i++) {
        NSArray *sensors =[NSArray arrayWithArray:[nodeArray[i] valueForKey:@"sensors"]];
        for (int j=0; j<sensors.count; j++) {
            if ([[sensors[j] valueForKey:@"alias"] isEqualToString:@"water_level"] && ![[nodeArray[i] valueForKey:@"latitude"] isEqual:[NSNull null]] && ![[nodeArray[i] valueForKey:@"longitude"] isEqual:[NSNull null]] && ![[sensors[j] valueForKey:@"latest_reading"] isEqual:[NSNull null]] && ![[sensors[j] valueForKey:@"latest_reading"] isEqual:@""]) {
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    marker.position = CLLocationCoordinate2DMake([[nodeArray[i] valueForKey:@"latitude"] doubleValue], [[nodeArray[i] valueForKey:@"longitude"] doubleValue]);
                    [path addCoordinate:marker.position];
                    NSLog(@"added a coordinate to GMSMutablePath and now count is %lu", path.count);
                    if (DISTANCE_TO_GROUND-[[[sensors[j] valueForKey:@"latest_reading"] valueForKey:@"value"] floatValue] > appDelegate->minimumWaterLevel) {
                        marker.icon = iconImage;
                    }else{
                        marker.icon = iconImageProblem;
                    }
                    marker.userData = [nodeArray[i] valueForKey:@"id"];
                    marker.map = mapView_;
                    [self updateCameraToFitMarkers];
            }else{
                NSLog(@"Did not add a marker on the map. The reasons is below:");
                if ([[sensors[j] valueForKey:@"latest_reading"] isEqual:@""]) {
                    NSLog(@"Latest reading value is \"\"");
                }
                if([[sensors[j] valueForKey:@"latest_reading"] isEqual:[NSNull null]]){
                    NSLog(@"Latest reading value is null");
                }
                if([[nodeArray[i] valueForKey:@"latitude"] isEqual:[NSNull null]]){
                    NSLog(@"Latitude is null");
                }
                if ([[nodeArray[i] valueForKey:@"longitude"] isEqual:[NSNull null]]) {
                    NSLog(@"Longitude is null");
                }
                if (![[sensors[j] valueForKey:@"alias"] isEqualToString:@"water_level"]) {
                    NSLog(@"No alias named water_level:%@", [sensors[j] valueForKey:@"alias"]);
                }
                NSLog(@"------------------------------------------------------");
            }
        }
    }
    }];
}

- (void)updateCameraToFitMarkers{
    NSLog(@"update camera to fit markers %lu", path.count);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(150, 50, 100, 50)];
    //Accessing UI Thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [mapView_ moveCamera:update];
    }];
}

// go to setting view
- (void)settingButtonTapped{
    NSLog(@"settingButtonTapped");
    SettingTableViewController *settingTableViewController = [[SettingTableViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingTableViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

// when tab bar tapped, map should be go to center of the site.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self updateCameraToFitMarkers];
}

// when marker is tapped, go to detail view
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    if (appDelegate->demo) {
        NSLog(@"tapMarker and go to demo detail view");
        ConditionViewController *conditionViewController = [[ConditionViewController alloc] init];
        for (int i = 0; i<nodeArray.count; i++) {
            if ([nodeArray[i] valueForKey:@"id"] == marker.userData) {
                conditionViewController->nodeData = nodeArray[i];
            }
        }
        conditionViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:conditionViewController animated:YES];
    }else{
        NSLog(@"tapMarker and go to detail view for node id %d", [marker.userData intValue]);
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        detailViewController->nodeId = [marker.userData intValue];
        for (int i = 0; i<nodeArray.count; i++) {
            if ([nodeArray[i] valueForKey:@"id"] == marker.userData) {
                detailViewController->nodeData = nodeArray[i];
            }
        }
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    return YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
