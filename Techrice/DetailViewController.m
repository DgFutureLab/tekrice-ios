#import "DetailViewController.h"
#import "AppDelegate.h"
@interface DetailViewController ()
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.1 alpha:1.0];
    NSString *nodeAlias = [nodeData valueForKey:@"alias"];
    if (![nodeAlias isEqual:[NSNull null]]) {
        self.title = nodeAlias;
    }else{
        self.title = [NSString stringWithFormat:@"Node ID:%d", nodeId];
    }
    NSDictionary *attributeDictionary = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributeDictionary];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *customView = [self customView];
    glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"ricefield.jpg"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:customView];
    [self.view addSubview:glassScrollView];
    // FIXME: hard code - should be get how many days does the chart shows from setting data.
    howManyDays = 7;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)customView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1200)];
    // distance
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(IS_PAD?20:5, IS_PAD?-120:5, IS_PAD?760:310, IS_PAD?240:120)];
    [distanceLabel setText:@"--cm"];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [distanceLabel setFont:[UIFont fontWithName:IS_PAD?@"HelveticaNeue-Thin":@"HelveticaNeue-UltraLight" size:IS_PAD?240:100]];
    [view addSubview:distanceLabel];
    
    // subtitle for big water level label;
    UILabel *subDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(IS_PAD?40:10, IS_PAD?-195:-70, 310, 120)];
    [subDistanceLabel setText:NSLocalizedString(@"Water Level", nil)];
    [subDistanceLabel setTextColor:[UIColor whiteColor]];
    [subDistanceLabel setFont:[UIFont fontWithName:IS_PAD?@"HelveticaNeue-Thin":@"HelveticaNeue-Light" size:IS_PAD?64:28]];
    [view addSubview:subDistanceLabel];
    
    //box: marning left: 5px, bottom 5px | size width: 310, height: 350
    
    // chart - water level
    for (int i = 0; i<[[nodeData valueForKey:@"sensors"] count]; i++) {
        if ([[NSString stringWithFormat:@"%@", [[nodeData valueForKey:@"sensors"][i] valueForKeyPath:@"latest_reading.sensor.alias"][0]] isEqualToString:@"water_level"]) {
            // water level
            int sensorId = [[[nodeData valueForKey:@"sensors"][i] valueForKeyPath:@"latest_reading.sensor.id"][0] intValue];
            NSString *title = @"Water Level";
            UIView *box = [[UIView alloc] initWithFrame:CGRectMake(5, 140, self.view.frame.size.width-10, 350)];
            NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                       box, @"view",
                                       title, @"title",
                                       @"water_level", @"sensorType",
                                       [NSNumber numberWithInt:sensorId], @"sensorId",
                                       nil];
            [self performSelectorInBackground:@selector(setChartView:) withObject:arguments];
            [view addSubview:box];
        }else if ([[NSString stringWithFormat:@"%@", [[nodeData valueForKey:@"sensors"][i] valueForKeyPath:@"latest_reading.sensor.alias"][0]] isEqualToString:@"air humidity"]){
            // air humidity
            int sensorId = [[[nodeData valueForKey:@"sensors"][i] valueForKeyPath:@"latest_reading.sensor.id"][0] intValue];
            NSString *title = @"Humidity";
            UIView *box = [[UIView alloc] initWithFrame:CGRectMake(5, 495, self.view.frame.size.width-10, 350)];
            NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                       box, @"view",
                                       title, @"title",
                                       @"air humidity", @"sensorType",
                                       [NSNumber numberWithInt:sensorId], @"sensorId",
                                       nil];
            [self performSelectorInBackground:@selector(setChartView:) withObject:arguments];
            [view addSubview:box];
        }else if ([[NSString stringWithFormat:@"%@", [[nodeData valueForKey:@"sensors"][i] valueForKeyPath:@"latest_reading.sensor.alias"][0]] isEqualToString:@"ambient temperature"]){
            // ambient temperature
            int sensorId = [[[nodeData valueForKey:@"sensors"][i] valueForKeyPath:@"latest_reading.sensor.id"][0] intValue];
            NSString *title = @"Temperature";
            UIView *box = [[UIView alloc] initWithFrame:CGRectMake(5, 850, self.view.frame.size.width-10, 350)];
            NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
                                       box, @"view",
                                       title, @"title",
                                       @"ambient temperature", @"sensorType",
                                       [NSNumber numberWithInt:sensorId], @"sensorId",
                                       nil];
            [self performSelectorInBackground:@selector(setChartView:) withObject:arguments];
            [view addSubview:box];
        }else{
            NSLog(@"something wrong: no valid data for making chart");
        }
    }
    
    
    
//    for (int i=0; i<[[nodeData valueForKey:@"sensors"] count]; i++) {
//        UIView *box = [[UIView alloc] initWithFrame:CGRectMake(5, 140, self.view.frame.size.width-10, 350)];
//        
//        
//        NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   box, @"view",
//                                   @"test title", @"title",
//                                   @"water_level", @"sensorType",
//                                   nil];
//        [self performSelectorInBackground:@selector(setChartView:) withObject:arguments];
//        [view addSubview:box0];
//    }
    

    
    // chart - humidity
//    UIView *box1 = [[UIView alloc] initWithFrame:CGRectMake(5, 495, self.view.frame.size.width-10, 350)];
//    NSDictionary *arguments2 = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    box1, @"view",
//                                    @"Humidity", @"title",
//                                    @"air humidity", @"sensorType",
//                                    nil];
//    [self performSelectorInBackground:@selector(setChartView:) withObject:arguments2];
//    [view addSubview:box1];
//    
//    // tempereture
//    UIView *box3 = [[UIView alloc] initWithFrame:CGRectMake(5, 850, self.view.frame.size.width-10, 350)];
//    NSDictionary *arguments3 = [NSDictionary dictionaryWithObjectsAndKeys:
//                                box3, @"view",
//                                @"Temperature", @"title",
//                                @"ambient temperature", @"sensorType",
//                                nil];
//    [self performSelectorInBackground:@selector(setChartView:) withObject:arguments3];
//    [view addSubview:box3];
    
    return view;
}

- (void)setChartView:(NSDictionary *)arguments{
    NSLog(@"setChartView");
    // get each data from arguments(NSDictionary)
    UIView *view = [arguments objectForKey:@"view"];
    NSString *title = [arguments objectForKey:@"title"];
    NSString *sensorType = [arguments objectForKey:@"sensorType"];
    int sensorId = [[arguments objectForKey:@"sensorId"] intValue];
    // view design - background
    view.layer.cornerRadius = 3;
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    
    // view design - tile
    UILabel *boxTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, 30)];
    [boxTitleLabel setTextColor:[UIColor whiteColor]];
    [boxTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:24]];
    boxTitleLabel.text = NSLocalizedString(title, nil);
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
        [NSThread sleepForTimeInterval:0.0];
    } else if ([title isEqualToString:@"Humidity"]) {
        [NSThread sleepForTimeInterval:1.5];
    } else if ([title isEqualToString:@"Temperature"]){
        [NSThread sleepForTimeInterval:3.0];
    }else{
        NSLog(@"chart: something wrong");
    }
    NSDictionary *data = [appDelegate getData:[self getParameterForChart:sensorId]];
//    NSDictionary *data = [self getDummyData:sensorType];
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
            [formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMd" options:0 locale:[NSLocale currentLocale]]];
            [displayLabelFormattedArray addObject:[formatter stringFromDate:date_converted]];
        }
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

// get string of parameter to get x days data from today for making chart
- (NSString *) getParameterForChartFromToday:(int)sensor_id
                    howManyDays:(int)days{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-1*days];
    NSDate *xDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-M-d"];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    NSString *xDaysAgoString = [dateFormatter stringFromDate:xDaysAgo];
    NSString *parameter = [NSString stringWithFormat:@"readings?sensor_id=%d&from=%@&until=%@", sensor_id, xDaysAgoString, currentDateString];
    NSLog(@"parameter: %@", parameter);
    return parameter;
}

// get string of parameter to get data for making chart
- (NSString *) getParameterForChart:(int)sensor_id{
    NSString *parameter = [NSString stringWithFormat:@"readings?sensor_id=%d", sensor_id];
    NSLog(@"parameter: %@", parameter);
    return parameter;
}


- (NSDictionary *)getDummyData:(NSString*)sensorType{
    NSArray *valueArray = [[NSArray alloc] init];
    NSArray *timeStampArray = [[NSArray alloc] init];
    if ([sensorType isEqualToString:@"distance"]) {
        valueArray =  @[[NSNumber numberWithInt:60+arc4random()%5], [NSNumber numberWithInt:60+arc4random()%5], [NSNumber numberWithInt:60+arc4random()%5], [NSNumber numberWithInt:60+arc4random()%5], [NSNumber numberWithInt:60+arc4random()%5], [NSNumber numberWithInt:60+arc4random()%5]];
        timeStampArray = @[@"2015-02-01-12:12:12:00", @"2015-02-02-13:00:00:00", @"2015-02-03-13:00:00:00", @"2015-02-04-13:00:00:00", @"2015-02-05-13:00:00:00", @"2015-02-06-13:00:00:00"];
    }else if ([sensorType isEqualToString:@"humidity"]) {
        valueArray =  @[[NSNumber numberWithInt:30+arc4random()%30], [NSNumber numberWithInt:30+arc4random()%30], [NSNumber numberWithInt:30+arc4random()%30], [NSNumber numberWithInt:30+arc4random()%30], [NSNumber numberWithInt:30+arc4random()%30], [NSNumber numberWithInt:30+arc4random()%30]];
        timeStampArray = @[@"2015-02-01-12:12:12:00", @"2015-02-02-13:00:00:00", @"2015-02-03-13:00:00:00", @"2015-02-04-13:00:00:00", @"2015-02-05-13:00:00:00", @"2015-02-06-13:00:00:00"];
    }else if ([sensorType isEqualToString:@"temperature"]){
        valueArray = @[[NSNumber numberWithInt:10+arc4random()%5], [NSNumber numberWithInt:10+arc4random()%5], [NSNumber numberWithInt:10+arc4random()%5], [NSNumber numberWithInt:10+arc4random()%5], [NSNumber numberWithInt:10+arc4random()%5], [NSNumber numberWithInt:10+arc4random()%5]];
        timeStampArray = @[@"2015-02-01-12:12:12:00", @"2015-02-02-13:00:00:00", @"2015-02-03-13:00:00:00", @"2015-02-04-13:00:00:00", @"2015-02-05-13:00:00:00", @"2015-02-06-13:00:00:00"];
    }
    else{
        NSLog(@"dummyData: something wrong");
    }
    NSDictionary *dictionary = @{@"value":valueArray, @"timestamp":timeStampArray};
    return @{@"objects":dictionary};
}

@end