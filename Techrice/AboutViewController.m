#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    textView.editable = NO;
    [textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    textView.text = NSLocalizedString(@"Techrice app shows the temperature, water level, humidituy in the ricefield which are sensored by Techrice's original sensor device.\nTechrice( http://www.techrice.jp/ ) is an open data sensor network. Techrice wants to help local farmers monitoring rice field water levels. The star topology sensor network is designed using Freaklabs open hardware. This is a collaboration project by Digital Garage Inc. Future Lab( http://www.fljapan.com/about ), Freaklabs( http://www.freaklabs.org/ ), Hacker Farm.", nil);;
    [self.view addSubview:textView];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
