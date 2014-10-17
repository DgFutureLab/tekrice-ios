//
//  DetailViewController.m
//  Techrice
//
//  Created by 藤賀 雄太 on 10/15/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate getNodeArray];
    [self performSelectorInBackground:@selector(getDistance) withObject:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *view = [self customView];
    glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"test1.png"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:view];
    [self.view addSubview:glassScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)customView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 705)];
    
    // distance
    appDelegate = appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [distanceLabel setText:[NSString stringWithFormat:@"%.0fcm", currentDistance]];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [distanceLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120]];
    [distanceLabel setShadowColor:[UIColor blackColor]];
    [distanceLabel setShadowOffset:CGSizeMake(1, 1)];
    [view addSubview:distanceLabel];
    
    // humidity
    UIView *box1 = [[UIView alloc] initWithFrame:CGRectMake(5, 140, 310, 125)];
    box1.layer.cornerRadius = 3;
    box1.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    UILabel *humidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [humidityLabel setText:[NSString stringWithFormat:@"%.0d%%", 45]];
    [humidityLabel setTextColor:[UIColor whiteColor]];
    [humidityLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32]];
    [humidityLabel setShadowColor:[UIColor blackColor]];
    [humidityLabel setShadowOffset:CGSizeMake(1, 1)];
    [box1 addSubview:humidityLabel];
    [view addSubview:box1];
    
    // wind speed
    UIView *box2 = [[UIView alloc] initWithFrame:CGRectMake(5, 270, 310, 300)];
    box2.layer.cornerRadius = 3;
    box2.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    UILabel *windSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [windSpeedLabel setText:[NSString stringWithFormat:@"%.0dm/s", 2]];
    [windSpeedLabel setTextColor:[UIColor whiteColor]];
    [windSpeedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32]];
    [windSpeedLabel setShadowColor:[UIColor blackColor]];
    [windSpeedLabel setShadowOffset:CGSizeMake(1, 1)];
    [box2 addSubview:windSpeedLabel];
    // windmill - base
    UIImageView *windSpeedImageViewPole = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"windmill_pole.png"]];
    windSpeedImageViewPole.frame = CGRectMake(35, 20, 5, 30);
    [box2 addSubview:windSpeedImageViewPole];
    // windminll - fan
    UIImageView *windSpeedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"windmill_fan.png"]];
    windSpeedImageView.frame = CGRectMake(17, 0, 40, 40);
    [self runSpinAnimationOnView:windSpeedImageView duration:0.05 rotations:1 repeat:MAXFLOAT];
    [box2 addSubview:windSpeedImageView];
    [view addSubview:box2];
    
    // tempereture
    UIView *box3 = [[UIView alloc] initWithFrame:CGRectMake(5, 575, 310, 125)];
    box3.layer.cornerRadius = 3;
    box3.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    UILabel *temperetureLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [temperetureLabel setText:[NSString stringWithFormat:@"%.0d℃", 24]];
    [temperetureLabel setTextColor:[UIColor whiteColor]];
    [temperetureLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32]];
    [temperetureLabel setShadowColor:[UIColor blackColor]];
    [temperetureLabel setShadowOffset:CGSizeMake(1, 1)];
    [box3 addSubview:temperetureLabel];
    // tempereture - thermometer
    UIProgressView *temperatureProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    temperatureProgressView.frame = CGRectMake(20, 25, 30, 10);
    temperatureProgressView.progressTintColor = [UIColor redColor];
    temperatureProgressView.transform = CGAffineTransformMakeRotation( -90.0f * M_PI / 180.0f );
    [temperatureProgressView setProgress:1.0 animated:YES];
    [box3 addSubview:temperatureProgressView];
    UIImageView *thermometerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thermometer.png"]];
    thermometerImageView.frame = CGRectMake(10, 0, 50, 50);
    [box3 addSubview:thermometerImageView];
    [view addSubview:box3];
    
    return view;
}

- (void)getDistance{
    currentDistance = [appDelegate getDistance];
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end