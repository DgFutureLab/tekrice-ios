#import "ConditionViewController.h"

@interface ConditionViewController ()

@end

@implementation ConditionViewController

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
    NSArray *sensors =[NSArray arrayWithArray:[nodeData valueForKey:@"sensors"]];
    for (int j=0; j<sensors.count; j++) {
        if ([[sensors[j] valueForKey:@"alias"] isEqualToString:@"water_level"] ){
            latestWaterLevel = DISTANCE_TO_GROUND-[[[sensors[j] valueForKey:@"latest_reading"] valueForKey:@"value"] floatValue];
        }
    }

    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    //rice
    conditionImageViewRice = [[UIImageView alloc] init];
    [conditionImageViewRice setFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:conditionImageViewRice];
    //water
    conditionImageViewWater = [[UIImageView alloc] init];
    if (latestWaterLevel > THRESHOLD) {
        goodCondition = true;
        conditionImageViewRice.image = [UIImage imageNamed:@"happyrice.png"];
        conditionImageViewWater.image = [UIImage imageNamed:@"cleanwater.png"];
        [self sinAnimation:conditionImageViewWater.layer waterLevel:150];
    }else{
        goodCondition = false;
        conditionImageViewRice.image = [UIImage imageNamed:@"sadrice.png"];
        conditionImageViewWater.image = [UIImage imageNamed:@"dirtywater.png"];
        [self sinAnimation:conditionImageViewWater.layer waterLevel:50];
    }
    [conditionImageViewWater setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self.view addSubview:conditionImageViewWater];
    
    //mud
    UIImageView *conditionImageViewMud = [[UIImageView alloc] init];
    conditionImageViewMud.image = [UIImage imageNamed:@"mud.png"];
    [conditionImageViewMud setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height+50)];
    [self.view addSubview:conditionImageViewMud];
    
    UIBarButtonItem *detailButton = [[UIBarButtonItem alloc] initWithTitle:@"Detail" style:UIBarButtonItemStylePlain target:self action:@selector(pressDetailButton)];
    self.navigationItem.rightBarButtonItem = detailButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSTimer *tm = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(animate:) userInfo:nil repeats:YES];
    
    //distance label
    enableUpdating = true;
    distanceLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(IS_PAD?20:5, IS_PAD?self.view.frame.size.height-225:self.view.frame.size.height-105, IS_PAD?760:310, IS_PAD?240:120)];
    distanceLabel.format = @"%.0fcm";
    distanceLabel.method = UILabelCountingMethodEaseInOut;
    [distanceLabel setText:[NSString stringWithFormat:@"%.0fcm", latestWaterLevel]];
    [distanceLabel countFrom:latestWaterLevel to:latestWaterLevel];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [distanceLabel setFont:[UIFont fontWithName:IS_PAD?@"HelveticaNeue-Thin":@"HelveticaNeue-UltraLight" size:IS_PAD?240:100]];
    [self.view addSubview:distanceLabel];
}

-(void)animate:(NSTimer*)timer{
    if (latestWaterLevel > THRESHOLD) {
        if (!goodCondition) {
            goodCondition = true;
            conditionImageViewRice.image = [UIImage imageNamed:@"happyrice.png"];
            conditionImageViewWater.image = [UIImage imageNamed:@"cleanwater.png"];
            [self sinAnimation:conditionImageViewWater.layer waterLevel:150];
        }
    }else{
        if (goodCondition) {
            goodCondition = false;
            conditionImageViewRice.image = [UIImage imageNamed:@"sadrice.png"];
            conditionImageViewWater.image = [UIImage imageNamed:@"dirtywater.png"];
            [self sinAnimation:conditionImageViewWater.layer waterLevel:50];
        }
    }
}

- (void)pressDetailButton{
    NSLog(@"DetailButton is tapped.");
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController->nodeData = nodeData;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)sinAnimation:(CALayer *)layer waterLevel:(float)waterLevel{
    // アニメーションの開始点
    CGPoint start = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*1.1-(IS_PAD?waterLevel*2:waterLevel));
    // アニメーションの時間
    CFTimeInterval duration = 2;
    // fps
    NSUInteger fps = 24;
    // 実際のフレーム数
    NSUInteger frameCount = (NSUInteger)duration*fps;
    // keytimes
    NSMutableArray *keytimes = [NSMutableArray arrayWithCapacity:frameCount];
    // values
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:frameCount];
    // 総フレーム数に対して正規化されたkeytimeの値を割り振る
    for (double i = 0, add = (double)1/frameCount; i <= 1.0; i+= add){
        [keytimes addObject:@(i)];
    }
    // 波長
    CGFloat amp = 10;
    // 加算するラジアン
    CGFloat add = M_PI*2/frameCount;
    // keytimesに対してサイン関数の値の座標を割り振る
    for (NSUInteger i = 0; i < frameCount; i++){
        CGFloat y = amp*sin((double)i*add);
        CGPoint p = CGPointMake(start.x, start.y+y);
        [values addObject:[NSValue valueWithCGPoint:p]];
    }
    // KeyFrameAnimationを作る
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    kfa.duration = duration;
    kfa.keyTimes = keytimes;
    kfa.values = values;
    // サイクルアニメーションにする
    kfa.repeatCount = HUGE_VALF;
    // 実行
    [layer addAnimation:kfa forKey:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"ConditionViewController: viewWillAppear");
    enableUpdating = true;
    [self performSelectorInBackground:@selector(updateSensorData) withObject:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    enableUpdating = false;
}

- (void)updateSensorData{
    if (enableUpdating) {
        int nodeId = [[nodeData valueForKey:@"id"] intValue];
        NSDate *start = [NSDate date];
        if ([[appDelegate getData:[NSString stringWithFormat:@"node/%d", nodeId]] objectForKey:@"objects"]) {
            nodeData = [[appDelegate getData:[NSString stringWithFormat:@"node/%d", nodeId]] objectForKey:@"objects"][0];
            NSTimeInterval timeInterval = [start timeIntervalSinceNow];
            if (timeInterval < 2) {
                [NSThread sleepForTimeInterval:2-timeInterval];
            }
            NSArray *sensors =[NSArray arrayWithArray:[nodeData valueForKey:@"sensors"]];
            for (int j=0; j<sensors.count; j++) {
                if ([[sensors[j] valueForKey:@"alias"] isEqualToString:@"water_level"] ){
                    latestWaterLevel = DISTANCE_TO_GROUND-[[[sensors[j] valueForKey:@"latest_reading"] valueForKey:@"value"] floatValue];
                    [self performSelectorOnMainThread:@selector(updateLabel) withObject:nil waitUntilDone:NO];
                }
            }
        }
        [self updateSensorData];
    }
}

- (void)updateLabel{
    [distanceLabel countFromCurrentValueTo:latestWaterLevel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
