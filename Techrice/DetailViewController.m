#import "DetailViewController.h"

// Numerics
NSInteger const numOfDots = 20;
NSInteger const minLineHeight = 5;
NSInteger const maxLineHeight = 10;

@interface DetailViewController ()<JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *monthlySymbols;

- (void)initFakeData;

@end

@implementation DetailViewController

-(void)initFakeData
{
    NSMutableArray *mutableChartData = [NSMutableArray array];
    
    // Weather API
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/history/city?q=Tokyo,jp"]];
    NSError *error;
    if (data != nil) {
        NSMutableDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSArray *dataArray = parsedData[@"list"];
        
        for (int j=0; j<numOfDots; j++)
        {
            NSNumber *temp = (NSNumber *)dataArray[j][@"main"][@"temp"];
            [mutableChartData addObject:[NSNumber numberWithFloat:([temp floatValue] - 272.15)]];
        }
        
        _chartData = [NSArray arrayWithArray:mutableChartData];
        _monthlySymbols = [[[NSDateFormatter alloc] init] shortMonthSymbols];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initFakeData];
    self.view.backgroundColor =[UIColor whiteColor];
    UIFont *fontForSensorValueLabel = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36.0f];
    
    // temperature - label
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 80, 320, 40)];
    temperatureLabel.font = fontForSensorValueLabel;
    temperatureLabel.textAlignment = NSTextAlignmentLeft;
    temperatureLabel.text = @"24 ℃";
    [self.view addSubview:temperatureLabel];
    
    // tempereture - thermometer
    UIProgressView *temperatureProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    temperatureProgressView.frame = CGRectMake(20, 95, 30, 10);
    temperatureProgressView.progressTintColor = [UIColor redColor];
    temperatureProgressView.transform = CGAffineTransformMakeRotation( -90.0f * M_PI / 180.0f );
    [temperatureProgressView setProgress:1.0 animated:YES];
    [self.view addSubview:temperatureProgressView];
    
    UIImageView *thermometerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thermometer.png"]];
    thermometerImageView.frame = CGRectMake(10, 70, 50, 50);
    [self.view addSubview:thermometerImageView];
    
    // distance - label
    appDelegate = appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 140, 320, 40)];
    distanceLabel.font = fontForSensorValueLabel;
    distanceLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:distanceLabel];
    // get data
    float distance = [appDelegate getDistance];
    distanceLabel.text = [NSString stringWithFormat:@"%.0f cm", distance];
    
    // distance
    UIProgressView *distanceProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    distanceProgressView.frame = CGRectMake(20, 160, 30, 10);
    distanceProgressView.progressTintColor = [UIColor blueColor];
    [distanceProgressView setProgress:1.0 animated:YES];
    [self.view addSubview:distanceProgressView];

    // humidity - label
    UILabel *humidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 320, 40)];
    humidityLabel.font = fontForSensorValueLabel;
    humidityLabel.textAlignment = NSTextAlignmentLeft;
    humidityLabel.text = @"45 %";
    [self.view addSubview:humidityLabel];
    
    //donuts meter
    MCPercentageDoughnutView *percentageDoughnut = [[MCPercentageDoughnutView alloc] initWithFrame:CGRectMake(20, 200, 40, 40)];
    percentageDoughnut.percentage = 0.45;
    percentageDoughnut.textLabel.text = @"HYGRO";
    [percentageDoughnut setTextStyle:MCPercentageDoughnutViewTextStyleUserDefined];
    [self.view addSubview:percentageDoughnut];
    
    // wind - label
    UILabel *windSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 260, 320, 40)];
    windSpeedLabel.text = @"2 m/s";
    windSpeedLabel.font = fontForSensorValueLabel;
    windSpeedLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:windSpeedLabel];
    
    // windmill - base
    UIImageView *windSpeedImageViewPole = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"windmill_pole.png"]];
    windSpeedImageViewPole.frame = CGRectMake(35, 265, 5, 30);
    [self.view addSubview:windSpeedImageViewPole];
    
    // windminll - fan
    UIImageView *windSpeedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"windmill_fan.png"]];
    windSpeedImageView.frame = CGRectMake(17, 245, 40, 40);
    [self runSpinAnimationOnView:windSpeedImageView duration:0.05 rotations:1 repeat:MAXFLOAT];
    [self.view addSubview:windSpeedImageView];

    // chart
    self.lineChartView = [[JBLineChartView alloc] init];
    self.lineChartView.frame = CGRectMake(10.0, 310.0, self.view.bounds.size.width-20.0, 250.0);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.backgroundColor = [UIColor colorWithRed:0.52 green:0.8 blue:0.79 alpha:0.76];
    
    [self.view addSubview:self.lineChartView];
    
    //NSLog(@"%@", self.chartData);
    //NSLog(@"%@", self.monthlySymbols);
    [self.lineChartView reloadData];
    //NSLog(@"%@", self.chartData);
    
    // graph switch
    UISwitch *switch1 = [[UISwitch alloc] initWithFrame:CGRectMake(240, 80, 50, 30)];
    switch1.onTintColor = [UIColor colorWithRed:0.62 green:1.0 blue:0.89 alpha:0.76];
    switch1.on = false;
    [self.view addSubview:switch1];
    
    UISwitch *switch2 = [[UISwitch alloc] initWithFrame:CGRectMake(240, 140, 50, 30)];
    switch2.onTintColor = [UIColor colorWithRed:0.62 green:1.0 blue:0.89 alpha:0.76];
    switch2.on = true;
    [self.view addSubview:switch2];
    
    UISwitch *switch3 = [[UISwitch alloc] initWithFrame:CGRectMake(240, 200, 50, 30)];
    switch3.onTintColor = [UIColor colorWithRed:0.62 green:1.0 blue:0.89 alpha:0.76];
    switch3.on = false;
    [self.view addSubview:switch3];
    
    UISwitch *switch4 = [[UISwitch alloc] initWithFrame:CGRectMake(240, 260, 50, 30)];
    switch4.onTintColor = [UIColor colorWithRed:0.62 green:1.0 blue:0.89 alpha:0.76];
    switch4.on = false;
    [self.view addSubview:switch4];
    
    //timer
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(checkDistance:) userInfo:nil repeats:YES];
}

-(void)checkDistance:(NSTimer*)timer{
    float distance = [appDelegate getDistance];
    distanceLabel.text = [NSString stringWithFormat:@"%.0f cm", distance];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [self.chartData count];
    //return [self.chartData objectAtIndex:lineIndex];
}

#pragma mark - Delegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[self.chartData objectAtIndex:horizontalIndex] floatValue];
}

#pragma mark - Override

- (JBChartView *)chartView
{
    return self.lineChartView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
}

@end