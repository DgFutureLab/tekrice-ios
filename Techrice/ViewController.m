#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()

@end

@implementation ViewController{
    GMSMapView *mapView_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"techricelogo.png"]];
    titleImageView.frame = CGRectMake(-72, -30, 149, 44);
    UIView *titleView = [[UIView alloc] init];
    [titleView addSubview:titleImageView];
    self.navigationItem.titleView = titleView;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.1 alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.14404025
                                                            longitude:139.988354
                                                                 zoom:18.5];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    mapView_.mapType = kGMSTypeSatellite;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    UIImage *iconImage = [UIImage imageNamed:@"darkgreen.png"];
    
    GMSMarker *marker1 = [[GMSMarker alloc] init];
    marker1.position = CLLocationCoordinate2DMake(35.143945, 139.988236);
    //    marker1.title = @"Node1";
    //    marker1.snippet = @"techrice";
    marker1.icon = iconImage;
    marker1.map = mapView_;
    
    GMSMarker *marker2 = [[GMSMarker alloc] init];
    marker2.position = CLLocationCoordinate2DMake(35.143951, 139.988560);
    //    marker2.title = @"Node2";
    //    marker2.snippet = @"techrice";
    marker2.icon = iconImage;
    marker2.map = mapView_;
    
    GMSMarker *marker3 = [[GMSMarker alloc] init];
    marker3.position = CLLocationCoordinate2DMake(35.144150, 139.988486);
    //    marker3.title = @"Node3";
    //    marker3.snippet = @"techrice";
    marker3.icon = iconImage;
    marker3.map = mapView_;
    
    GMSMarker *marker4 = [[GMSMarker alloc] init];
    marker4.position = CLLocationCoordinate2DMake(35.144115, 139.988134);
    //    marker4.title = @"Node4";
    //    marker4.snippet = @"techrice";
    marker4.icon = iconImage;
    marker4.map = mapView_;
    
    markers = @[marker1, marker2, marker3, marker4];
    
    UIImageView *tabBarSampleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBar_sample.png"]];
    tabBarSampleView.frame = CGRectMake(0, 520, 320, 50);
    [self.view addSubview:tabBarSampleView];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    NSLog(@"tapMarker");
    ConditionViewController *conditionViewController = [[ConditionViewController alloc] init];
    [self.navigationController pushViewController:conditionViewController animated:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
