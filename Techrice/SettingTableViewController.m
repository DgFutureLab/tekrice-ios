#import "SettingTableViewController.h"
#import "SettingValueViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import <sys/utsname.h>
@interface SettingTableViewController ()

@end

@implementation SettingTableViewController


-(id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self setTitle:@"Setting"];
    NSDictionary *attributeDictionary = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributeDictionary];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.1 alpha:1.0];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped)];
    doneButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)doneButtonTapped{
    NSLog(@"doneButtonTapped");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:{
            cell.accessoryType = UITableViewCellAccessoryNone;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Kamogawa";
                    break;
                case 1:
                    cell.textLabel.text = @"Hacker Farm";
                    break;
                case 2:
                    cell.textLabel.text = @"Digital Garage";
                    break;
                default:
                    break;
            }
            break;
        }
        case 1:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Minimum water level";
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", appDelegate->distanceThreshold];
            break;
        }
        case 2:{
            switch (indexPath.row) {
                case 0:
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = @"About Techrice";
                    break;
                case 1:
                    cell.textLabel.text = @"Contact (Feedback | Bug report)";
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            NSLog(@"selected sites");
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
        case 1:{
            SettingValueViewController *settingValueController = [[SettingValueViewController alloc] init];
            settingValueController.title = @"Minimum water level";
            [self.navigationController pushViewController:settingValueController animated:YES];
            break;
        }
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
                    aboutViewController.title = @"About Techrice";
                    [self.navigationController pushViewController:aboutViewController animated:YES];
                    break;
                }
                case 1:{
                    [self mailStartUp];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0: return @"SITES";
        case 1: return @"SENSORS";
        case 2: return @"MORE";
        default: return @"";
    }
}
- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0: return @"";
        default: return @"";
    }
}

- (void)mailStartUp{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil){
        MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
        mailPicker.mailComposeDelegate = self;
        [mailPicker setSubject:NSLocalizedString(@"about Techrice", @"")];
        [mailPicker setMessageBody:[NSString stringWithFormat:@"\n\n\n-----\nPlease do not delete below.\nSystem Info : %@\nOS : %@\nApp Version : %@",
                                    [self platformString],
                                    [self iOSVersion],
                                    [self appVersion]] isHTML:NO];
         NSArray *toRecipients = [NSArray arrayWithObject:@"yuta-toga@garage.co.jp"];
        [mailPicker setToRecipients:toRecipients];
        if ([mailClass canSendMail]){
            [self presentViewController:mailPicker animated:TRUE completion:nil];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result){
            // キャンセル
        case MFMailComposeResultCancelled:
            break;
            // 保存
        case MFMailComposeResultSaved:
            break;
            // 送信
        case MFMailComposeResultSent:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your message has been successfully sent." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            break;
        }
        // 送信失敗
        case MFMailComposeResultFailed:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Delivery has failed." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSString *)platformString{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (NSString *)iOSVersion{
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)appVersion{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

@end
