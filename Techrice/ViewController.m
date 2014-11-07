#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()

@end

@implementation ViewController{
    GMSMapView *mapView_;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.delegate = self;
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
    
    camera = [GMSCameraPosition cameraWithLatitude:35.14404025
                                         longitude:139.988354
                                              zoom:18.5];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    mapView_.mapType = kGMSTypeSatellite;
    self.view = mapView_;
    [self performSelectorInBackground:@selector(setMarker) withObject:nil];

    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    [self.view addSubview:tabBar];
}

- (void) setMarker{
    NSLog(@"setMarker");
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *nodeArray =  [appDelegate getNodeArray];
    // Creates a marker in the center of the map.
    UIImage *iconImage = [UIImage imageNamed:@"darkgreen.png"];
    UIImage *iconImageProblem = [UIImage imageNamed:@"allred.png"];
    NSLog(@"%@", nodeArray);
    for (int i =0; i<nodeArray.count; i++) {
        NSArray *sensors =[NSArray arrayWithArray:[nodeArray[i] valueForKey:@"sensors"]];
        for (int j=0; j<sensors.count; j++) {
            if ([[sensors[j] valueForKey:@"alias"] isEqualToString:@"distance"]) {
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake([[nodeArray[i] valueForKey:@"latitude"] doubleValue], [[nodeArray[i] valueForKey:@"longitude"] doubleValue]);
                if ([[[sensors[j] valueForKey:@"latest_reading"] valueForKey:@"value"] floatValue] > THRESHOLD) {
                    marker.icon = iconImage;
                }else{
                    marker.icon = iconImageProblem;
                }
                marker.userData = [nodeArray[i] valueForKey:@"id"];
                marker.map = mapView_;
            }
        }
    }
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
