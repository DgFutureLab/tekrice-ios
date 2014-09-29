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
    NSLog(@"didload");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    appDelegate = appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    float distance = [appDelegate getDistance];
    //rice
    conditionImageViewRice = [[UIImageView alloc] init];
    [conditionImageViewRice setFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:conditionImageViewRice];
    //water
    conditionImageViewWater = [[UIImageView alloc] init];
    if (distance < THRESHOLD) {
        goodCondition = true;
        conditionImageViewRice.image = [UIImage imageNamed:@"happyrice.png"];
        conditionImageViewWater.image = [UIImage imageNamed:@"cleanwater2.png"];
        [self sinAnimation:conditionImageViewWater.layer waterLevel:150];
    }else{
        goodCondition = false;
        conditionImageViewRice.image = [UIImage imageNamed:@"sadrice.png"];
        conditionImageViewWater.image = [UIImage imageNamed:@"dirtywater2.png"];
        [self sinAnimation:conditionImageViewWater.layer waterLevel:50];
    }
    [conditionImageViewWater setFrame:CGRectMake(0, 0, conditionImageViewWater.image.size.width, conditionImageViewWater.image.size.height)];
    
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
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(checkCondition:) userInfo:nil repeats:YES];
    lastDistance = -1;
}

-(void)checkCondition:(NSTimer*)timer{
    float distance = [appDelegate getDistance];
    if (distance != lastDistance) {
        if (distance < THRESHOLD) {
            if (!goodCondition) {
                goodCondition = true;
                conditionImageViewRice.image = [UIImage imageNamed:@"happyrice.png"];
                conditionImageViewWater.image = [UIImage imageNamed:@"cleanwater2.png"];
                [self sinAnimation:conditionImageViewWater.layer waterLevel:150];
            }
        }else{
            if (goodCondition) {
                goodCondition = false;
                conditionImageViewRice.image = [UIImage imageNamed:@"sadrice.png"];
                conditionImageViewWater.image = [UIImage imageNamed:@"dirtywater2.png"];
                [self sinAnimation:conditionImageViewWater.layer waterLevel:50];
            }
        }
    }
    lastDistance = distance;
}

- (void)pressDetailButton{
    [timer invalidate];
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)sinAnimation:(CALayer *)layer waterLevel:(float)waterLevel{
    // アニメーションの開始点
    CGPoint start = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2+290-waterLevel);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
}

@end
