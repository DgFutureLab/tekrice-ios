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
- (void)getDistance:(NSDictionary*) args;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = [NSString stringWithFormat:@"Node ID:%d", nodeId];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate getNodeArray];
    NSNumber *nodeIdNumber = [NSNumber numberWithInt:nodeId];
    NSString *parameter = @"date_range=1week";
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:nodeIdNumber, @"nodeIdNumber", parameter, @"parameter",nil];
//    [self performSelectorInBackground:@selector(getDistance:) withObject:args];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *view = [self customView];
    glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"test1.png"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:view];
    [self.view addSubview:glassScrollView];
    nodeData = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIView *)customView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1500)];
    
    // distance
    appDelegate = appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [distanceLabel setText:[NSString stringWithFormat:@"%.0fcm", 42]];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [distanceLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120]];
    [view addSubview:distanceLabel];
    
    //box: marning left: 5px, bottom 5px | size width: 310, height: 350
    
    UIView *box0 = [[UIView alloc] initWithFrame:CGRectMake(5, 140, 310, 350)];
    box0.layer.cornerRadius = 3;
    box0.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    
    
    boxDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [boxDistanceLabel setText:[NSString stringWithFormat:@"%.0fcm", 42]];
    [boxDistanceLabel setTextColor:[UIColor whiteColor]];
    [boxDistanceLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32]];
    
    //tile - distance
    UILabel *boxDistanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 30)];
    [boxDistanceTitleLabel setTextColor:[UIColor whiteColor]];
    [boxDistanceTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:24]];
    boxDistanceTitleLabel.text = @"Distance";
    [box0 addSubview:boxDistanceTitleLabel];
    
    //underline - distance
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 1;
    [aPath moveToPoint:CGPointMake(5, 35)];
    [aPath addLineToPoint:CGPointMake(305, 35)];
    [aPath closePath];
    [aPath stroke];
    CAShapeLayer *sl = [[CAShapeLayer alloc] initWithLayer:box0.layer];
    sl.fillColor = [UIColor clearColor].CGColor;
    sl.strokeColor = [UIColor whiteColor].CGColor;
    sl.path = aPath.CGPath;
    [box0.layer addSublayer:sl];
    [box0 addSubview:boxDistanceLabel];
    
    //chart - distance
    lineChartDistance = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    lineChartDistance.yLabelFormat = @"%1.1f";
    lineChartDistance.yLabelColor = PNCleanGrey;
    lineChartDistance.xLabelColor = PNCleanGrey;
    lineChartDistance.axisColor = PNLightGrey;
    lineChartDistance.backgroundColor = [UIColor clearColor];
    
    NSLog(@"cool ß%@", nodeData);
    
    [lineChartDistance setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
    lineChartDistance.showCoordinateAxis = YES;
    NSArray * dataArrayDistance = @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2];
    
    PNLineChartData *lineChartDataDistance = [PNLineChartData new];
    lineChartDataDistance.color = PNFreshGreen;
    lineChartDataDistance.itemCount = lineChartDistance.xLabels.count;
    lineChartDataDistance.inflexionPointStyle = PNLineChartPointStyleCycle;
    lineChartDataDistance.getData = ^(NSUInteger index) {
        CGFloat yValue = [dataArrayDistance[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    lineChartDistance.chartData = @[lineChartDataDistance];
    [lineChartDistance strokeChart];
    //    lineChart.delegate = self;
    [box0 addSubview:lineChartDistance];
    [view addSubview:box0];
    
    // humidity
    UIView *box1 = [[UIView alloc] initWithFrame:CGRectMake(5, 495, 310, 350)];
    box1.layer.cornerRadius = 3;
    box1.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    UILabel *humidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [humidityLabel setText:[NSString stringWithFormat:@"%.0d%%", 45]];
    [humidityLabel setTextColor:[UIColor whiteColor]];
    [humidityLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32]];
    [box1 addSubview:humidityLabel];
    [view addSubview:box1];
    
    // wind speed
    UIView *box2 = [[UIView alloc] initWithFrame:CGRectMake(5, 850, 310, 350)];
    box2.layer.cornerRadius = 3;
    box2.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    UILabel *windSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [windSpeedLabel setText:[NSString stringWithFormat:@"%.0dm/s", 2]];
    [windSpeedLabel setTextColor:[UIColor whiteColor]];
    [windSpeedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32]];
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
    UIView *box3 = [[UIView alloc] initWithFrame:CGRectMake(5, 1205, 310, 350)];
    box3.layer.cornerRadius = 3;
    box3.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    UILabel *temperetureLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [temperetureLabel setText:[NSString stringWithFormat:@"%.0d℃", 24]];
    [temperetureLabel setTextColor:[UIColor whiteColor]];
    [temperetureLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32]];
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

- (void)getDistance:(NSDictionary*) args{
    NSNumber *nodeIdNumber = [args valueForKey:@"nodeIdNumber"];
    NSString *parameter = [args valueForKey:@"parameter"];
    distanceArray = [appDelegate getDistance:nodeIdNumber parameter:parameter];
    
    // distance Label
    [distanceLabel setText:[NSString stringWithFormat:@"%.0fcm", [[[[distanceArray valueForKey:@"objects"] lastObject] valueForKey:@"value"] floatValue]]];
    [boxDistanceLabel setText:distanceLabel.text];
    
    // distance chart
//    [lineChartDistance setXLabels:[[distanceArray valueForKey:@"objects"] valueForKey:@"timestamp"]];
//    NSArray * dataArrayDistance = [[distanceArray valueForKey:@"objects"] valueForKey:@"value"];
    
    //how to update??
    [lineChartDistance setXLabels:@[@"foo 1",@"bar 2",@"SEaP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7"]];
    NSArray * dataArrayDistance = @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2];
    
    PNLineChartData *lineChartDataDistance = [PNLineChartData new];
    lineChartDataDistance.color = PNFreshGreen;
    lineChartDataDistance.itemCount = lineChartDistance.xLabels.count;
    lineChartDataDistance.inflexionPointStyle = PNLineChartPointStyleCycle;
    lineChartDataDistance.getData = ^(NSUInteger index) {
        CGFloat yValue = [dataArrayDistance[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    lineChartDistance.chartData = @[lineChartDataDistance];
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