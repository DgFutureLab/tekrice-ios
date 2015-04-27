//
//  ConditionViewController.m
//  mapboxtest
//
//  Created by 藤賀 雄太 on 8/27/14.
//  Copyright (c) 2014 Yuta Toga. All rights reserved.
//

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
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    
    appDelegate = appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    float distance = 42; // FIXME: hard code
    //rice
    conditionImageViewRice = [[UIImageView alloc] init];
    [conditionImageViewRice setFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:conditionImageViewRice];
    //water
    conditionImageViewWater = [[UIImageView alloc] init];
    if (distance < THRESHOLD) {
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
    
//    UILabel *waterLevelLabel = [[UILabel alloc] init];
//    waterLevelLabel.frame = CGRectMake(0, 430, 320, 32);
//    waterLevelLabel.textAlignment = NSTextAlignmentCenter;
//    waterLevelLabel.text = [NSString stringWithFormat:@"Distance: %.0f", distance];
//    [self.view addSubview:waterLevelLabel];
    
    UIBarButtonItem *detailButton = [[UIBarButtonItem alloc] initWithTitle:@"Detail" style:UIBarButtonItemStylePlain target:self action:@selector(pressDetailButton)];
    self.navigationItem.rightBarButtonItem = detailButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSTimer *tm = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(hoge:) userInfo:nil repeats:YES];
    
    // debug(delete me)
//    slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 300, 200, 20)];
//    slider.minimumValue = 0.0;
//    slider.maximumValue = 1.0;
//    slider.value = 0.5;
//    [self.view addSubview:slider];
}

-(void)hoge:(NSTimer*)timer{
//    NSLog(@"update");
    // ここに何かの処理を記述する
    // （引数の timer には呼び出し元のNSTimerオブジェクトが引き渡されてきます）
    float distance = 42; // FIXME: hard code
    
//    float th = slider.value*100;//debug (delete me)
    if (distance < THRESHOLD) {
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
//    NSLog(@"go to the detail view");
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)sinAnimation:(CALayer *)layer waterLevel:(float)waterLevel{
    // アニメーションの開始点
    CGPoint start = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*1.1);// FIXME: height should be changed by waterLevel
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
