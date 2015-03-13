#import "SettingTableViewController.h"
#import "SettingValueViewController.h"
#import "AboutViewController.h"
#import <sys/utsname.h>
@interface SettingTableViewController ()

@end

@implementation SettingTableViewController


-(id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
    mininumWaterLevel = appDelegate->minimumWaterLevel;
    selectedSiteId = appDelegate->currentSite;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self setTitle:NSLocalizedString(@"Setting", nil)];
    NSDictionary *attributeDictionary = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributeDictionary];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.1 alpha:1.0];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped)];
    doneButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.tableView.allowsMultipleSelection = NO;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    sites = [appDelegate getData:@"sites"];
}

- (void)doneButtonTapped{
    NSLog(@"doneButtonTapped");
    // save in user defaults
    //ローカルに保存
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSDictionary *setting = @{@"site":[NSNumber numberWithInteger:selectedSiteId],
                              @"minimumWaterLevel":[numberFormatter numberFromString:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].detailTextLabel.text]
                              };
    NSLog(@"setting: %@", setting);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:setting forKey:@"cache/setting"];
    BOOL successful = [defaults synchronize];
    if (successful) {
        NSLog(@"%@", @"SettingTableViewController-doneButtonTapped: saved data successfully");
    }
    appDelegate->currentSite = selectedSiteId;
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
            return [[sites objectForKey:@"objects"] count];
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
            if ([[[sites objectForKey:@"objects"][(int)indexPath.row] objectForKey:@"id"] intValue]  == selectedSiteId) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = [[sites objectForKey:@"objects"][(int)indexPath.row] objectForKey:@"alias"];
            break;
        }
        case 1:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedString(@"Minimum water level", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", mininumWaterLevel];
            break;
        }
        case 2:{
            switch (indexPath.row) {
                case 0:
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = NSLocalizedString(@"About Techrice", nil);
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Contact (Feedback | Bug report)", nil);
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
            selectedSiteId = [[[sites objectForKey:@"objects"][(int)indexPath.row] objectForKey:@"id"] intValue];
            NSLog(@"checking %d", selectedSiteId);
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
        case 1:{
            SettingValueViewController *settingValueController = [[SettingValueViewController alloc] init];
            settingValueController.title = NSLocalizedString(@"Minimum water level", nil);
            [self.navigationController pushViewController:settingValueController animated:YES];
            break;
        }
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
                    aboutViewController.title = NSLocalizedString(@"About Techrice", nil);
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0: return NSLocalizedString(@"SITES", nil);
        case 1: return NSLocalizedString(@"SENSORS", nil);
        case 2: return NSLocalizedString(@"MORE", nil);
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
        [mailPicker setSubject:NSLocalizedString(@"About Techrice", nil)];
        
        NSString *message = NSLocalizedString(@"\n\n\n-----\nPlease do not delete below.\n", nil);
        [mailPicker setMessageBody:[message stringByAppendingPathComponent:[NSString stringWithFormat:@"System Info : %@\nOS : %@\nApp Version : %@",
                                                                            [self platformString],
                                                                            [self iOSVersion],
                                                                            [self appVersion]]] isHTML:NO];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Your message has been successfully sent.", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            break;
        }
        // 送信失敗
        case MFMailComposeResultFailed:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Delivery has failed.", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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

- (void) addSite{
    NSLog(@"post");
    NSString *query = @"";
    NSData *queryData = [query dataUsingEncoding:NSUTF8StringEncoding];
    NSString *url = @"http://128.199.191.249/site";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:queryData];
    NSURLResponse *response;
    NSError *error;
    NSData *result = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&response
                                                       error:&error];
    NSString *string = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"%@", string);
}

@end
