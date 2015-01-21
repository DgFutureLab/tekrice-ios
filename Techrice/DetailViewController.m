#import "DetailViewController.h"
#import "AppDelegate.h"
@interface DetailViewController ()
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.1 alpha:1.0];
    self.title = [NSString stringWithFormat:@"Node ID:%d", nodeId];
    NSDictionary *attributeDictionary = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributeDictionary];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    NSNumber *nodeIdNumber = [NSNumber numberWithInt:nodeId];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *_view = [self customView];
    glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"ricefield.jpg"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:_view];
    [self.view addSubview:glassScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)customView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1200)];
    // distance
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
//    [distanceLabel setText:[NSString stringWithFormat:@"%.0fcm", 42]];
    [distanceLabel setText:@"--cm"];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [distanceLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120]];
    [view addSubview:distanceLabel];
    
    //box: marning left: 5px, bottom 5px | size width: 310, height: 350
    
    // chart - distance
    UIView *box0 = [[UIView alloc] initWithFrame:CGRectMake(5, 140, self.view.frame.size.width-10, 350)];
    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                    box0, @"view",
                                    @"Water Level", @"title",
                                    @"/distance?date_range=1week", @"parameter",
                                    nil];
    [self performSelectorInBackground:@selector(setChartView:) withObject:arguments];
    [view addSubview:box0];
    
    // chart - humidity
    UIView *box1 = [[UIView alloc] initWithFrame:CGRectMake(5, 495, self.view.frame.size.width-10, 350)];
    NSDictionary *arguments2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                    box1, @"view",
                                    @"Humidity", @"title",
                                    @"/humidity?date_range=1week", @"parameter",
                                    nil];
    [self performSelectorInBackground:@selector(setChartView:) withObject:arguments2];
    [view addSubview:box1];
    
    // wind speed
//    UIView *box2 = [[UIView alloc] initWithFrame:CGRectMake(5, 850, 310, 350)];
//    box2.layer.cornerRadius = 3;
//    box2.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
//    UILabel *windSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
//    [windSpeedLabel setText:[NSString stringWithFormat:@"%.0dm/s", 2]];
//    [windSpeedLabel setTextColor:[UIColor whiteColor]];
//    [windSpeedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32]];
//    [box2 addSubview:windSpeedLabel];
//    // windmill - base
//    UIImageView *windSpeedImageViewPole = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"windmill_pole.png"]];
//    windSpeedImageViewPole.frame = CGRectMake(35, 20, 5, 30);
//    [box2 addSubview:windSpeedImageViewPole];
//    // windminll - fan
//    UIImageView *windSpeedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"windmill_fan.png"]];
//    windSpeedImageView.frame = CGRectMake(17, 0, 40, 40);
//    [self runSpinAnimationOnView:windSpeedImageView duration:0.05 rotations:1 repeat:MAXFLOAT];
//    [box2 addSubview:windSpeedImageView];
//    [view addSubview:box2];
    
    // tempereture
    UIView *box3 = [[UIView alloc] initWithFrame:CGRectMake(5, 850, self.view.frame.size.width-10, 350)];
    NSDictionary *arguments3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                box3, @"view",
                                @"Temperature", @"title",
                                @"/temperature?date_range=1week", @"parameter",
                                nil];
    [self performSelectorInBackground:@selector(setChartView:) withObject:arguments3];
    
    // tempereture - thermometer
//    UIProgressView *temperatureProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
//    temperatureProgressView.frame = CGRectMake(20, 25, 30, 10);
//    temperatureProgressView.progressTintColor = [UIColor redColor];
//    temperatureProgressView.transform = CGAffineTransformMakeRotation( -90.0f * M_PI / 180.0f );
//    [temperatureProgressView setProgress:1.0 animated:YES];
//    [box3 addSubview:temperatureProgressView];
//    UIImageView *thermometerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thermometer.png"]];
//    thermometerImageView.frame = CGRectMake(10, 0, 50, 50);
//    [box3 addSubview:thermometerImageView];
    [view addSubview:box3];
    
    return view;
}

- (void)setChartView:(NSDictionary *)arguments{
    NSLog(@"setChartView");
    // get each data from arguments(NSDictionary)
    UIView *view = [arguments objectForKey:@"view"];
    NSString *title = [arguments objectForKey:@"title"];
    NSString *parameter = [arguments objectForKey:@"parameter"];
    
    // view design - background
    view.layer.cornerRadius = 3;
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    
    // view design - tile
    UILabel *boxTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, 30)];
    [boxTitleLabel setTextColor:[UIColor whiteColor]];
    [boxTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:24]];
    boxTitleLabel.text = title;
    [view addSubview:boxTitleLabel];
    
    //view design - underline for title
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 1;
    [aPath moveToPoint:CGPointMake(5, 35)];
    [aPath addLineToPoint:CGPointMake(self.view.frame.size.width-15, 35)];
    [aPath closePath];
    [aPath stroke];
    CAShapeLayer *sl = [[CAShapeLayer alloc] initWithLayer:view.layer];
    sl.fillColor = [UIColor clearColor].CGColor;
    sl.strokeColor = [UIColor whiteColor].CGColor;
    sl.path = aPath.CGPath;
    [view.layer addSublayer:sl];
    
    // chart
    // API call should be once per second
    if ([title isEqualToString:@"Water Level"]){
//        requestDate = [NSDate date];
//        NSLog(@"gaga distance %@", requestDate);
        [NSThread sleepForTimeInterval:0.0];
    }
    else if ([title isEqualToString:@"Humidity"]) {
//        requestDate = [requestDate dateByAddingTimeInterval:1.0];
//        NSLog(@"gaga huimidity %@", requestDate);
//        [NSThread sleepUntilDate:requestDate];
        [NSThread sleepForTimeInterval:1.5];
    } else if ([title isEqualToString:@"Temperature"]){
//        requestDate = [requestDate dateByAddingTimeInterval:1.0];
//        NSLog(@"gaga temperature %@", requestDate);
//        [NSThread sleepUntilDate:[requestDate dateByAddingTimeInterval:1.0]];
        [NSThread sleepForTimeInterval:3.0];
    }else{
        NSLog(@"something wrong");
    }
    //should be replaced below to NSArray *data = [appDelegate getData:<#(NSString *)#>]
    NSArray *data = [appDelegate getDistance:[NSNumber numberWithInt:nodeId] parameter:parameter];
    NSArray *dataArray = [data valueForKeyPath:@"objects.value"];
    if (dataArray.count > 0) {
        // chart - design
        PNLineChart *lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        lineChart.yLabelFormat = @"%1.1f";
        lineChart.yLabelColor = PNCleanGrey;
        lineChart.xLabelColor = PNCleanGrey;
        lineChart.axisColor = PNLightGrey;
        lineChart.backgroundColor = [UIColor clearColor];
        lineChart.showCoordinateAxis = YES;
        lineChart.xLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:10];
        lineChart.yLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:10];
        
        // chart - data
        NSMutableArray *displayDistanceDataArray = [[NSMutableArray alloc] init];
        if (dataArray.count > CHART_POINTS_MAX) {
            displayDistanceDataArray= [[dataArray subarrayWithRange: NSMakeRange(dataArray.count-CHART_POINTS_MAX, CHART_POINTS_MAX) ] mutableCopy];
        }else{
            displayDistanceDataArray= [dataArray mutableCopy];
        }
        
        // chart - title
        UILabel *boxLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
        if ([title isEqualToString:@"Water Level"]) {
            for (int i = 0; i<displayDistanceDataArray.count; i++) {
                float displayDistance = [displayDistanceDataArray[i] floatValue];
                displayDistanceDataArray[i] = [NSNumber numberWithFloat:DISTANCE_TO_GROUND-displayDistance];
            }
            [boxLabel setText:[NSString stringWithFormat:@"%.0fcm", [[displayDistanceDataArray lastObject] floatValue]]];
            [distanceLabel setText:[NSString stringWithFormat:@"%.0fcm", [[displayDistanceDataArray lastObject] floatValue]]];
        }else if ([title isEqualToString:@"Humidity"]){
            [boxLabel setText:[NSString stringWithFormat:@"%.0f%%", [[displayDistanceDataArray lastObject] floatValue]]];
        }else if ([title isEqualToString:@"Temperature"]){
            [boxLabel setText:[NSString stringWithFormat:@"%.0f℃", [[displayDistanceDataArray lastObject] floatValue]]];
        }
        [boxLabel setTextColor:[UIColor whiteColor]];
        [boxLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32]];
        [view addSubview:boxLabel];
        
        // chart -  x-coordinate axis label
        NSArray *labelArray = [data valueForKeyPath:@"objects.timestamp"];
        NSArray *displayLabelArray = [[NSArray alloc] init];
        if (labelArray.count > CHART_POINTS_MAX) {
            displayLabelArray= [labelArray subarrayWithRange: NSMakeRange(labelArray.count-CHART_POINTS_MAX, CHART_POINTS_MAX)];
        }else{
            displayLabelArray= labelArray;
        }
        NSMutableArray *displayLabelFormattedArray = [[NSMutableArray alloc] init];
        for (int i =0; i<displayLabelArray.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss:SSSSSS"];
            NSDate* date_converted = [formatter dateFromString:displayLabelArray[i]];
            [formatter setDateFormat:@"HHa"];
            [displayLabelFormattedArray addObject:[formatter stringFromDate:date_converted]];
        }
        NSLog(@"ss: %@", displayLabelFormattedArray);
        [lineChart setXLabels:displayLabelFormattedArray];
        
        // chart - chart data setting
        lineChart.showCoordinateAxis = YES;
        PNLineChartData *lineChartDataDistance = [PNLineChartData new];
        lineChartDataDistance.color = PNFreshGreen;
        lineChartDataDistance.itemCount = lineChart.xLabels.count;
        lineChartDataDistance.inflexionPointStyle = PNLineChartPointStyleCycle;
        lineChartDataDistance.getData = ^(NSUInteger index) {
            CGFloat yValue = [displayDistanceDataArray[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        lineChart.chartData = @[lineChartDataDistance];
        [lineChart strokeChart];
        [view addSubview:lineChart];
    }
}

// animation function for windmill
- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end