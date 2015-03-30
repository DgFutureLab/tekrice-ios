#import "TableViewController.h"
#import "SettingTableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"TableViewController: viewWillAppear");
    self.tabBarController.delegate = self;
    [self setListData];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tabBarController.delegate = self;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    displayDataArray = [[NSMutableArray alloc] init];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.1 alpha:1.0];
    NSArray *arr = @[NSLocalizedString(@"Ascending", nil), NSLocalizedString(@"Descending", nil)];
    seg = [[UISegmentedControl alloc] initWithItems:arr];
    seg.frame = CGRectMake(0, 0, 250, 30);
    seg.tintColor = [UIColor whiteColor];
    [seg addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:seg];
    
    //add setting button
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonTapped)];
    settingButton.title = @"\u2699";
    settingButton.tintColor = [UIColor whiteColor];
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingButton setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = settingButton;
}

- (void)setListData{
    NSLog(@"setListData");
    nodeArray = [[[appDelegate getData:[NSString stringWithFormat:@"site/%d", appDelegate->currentSite]] valueForKey:@"objects"][0] objectForKey:@"nodes"];
    appDelegate.nodeArray = nodeArray;
    [displayDataArray removeAllObjects];
    numberOfRows = 0;
    for (int i=0; i<nodeArray.count; i++) {
        NSArray *sensors =[NSArray arrayWithArray:[nodeArray[i] valueForKey:@"sensors"]];
        for (int j = 0; j<sensors.count; j++) {
            if ([[sensors[j] valueForKey:@"alias"] isEqualToString:@"water_level"] && ![[nodeArray[i] valueForKey:@"latitude"] isEqual:[NSNull null]] && ![[nodeArray[i] valueForKey:@"longitude"] isEqual:[NSNull null]] && ![[sensors[j] valueForKey:@"latest_reading"] isEqual:[NSNull null]] && ![[sensors[j] valueForKey:@"latest_reading"] isEqual:@""]) {
                numberOfRows++;
                NSMutableDictionary *displayDictionary = [[sensors[j] valueForKey:@"latest_reading"] mutableCopy];
                [displayDictionary setObject:[nodeArray[i] valueForKey:@"id"] forKey:@"nodeId"];
                [displayDictionary setObject:[nodeArray[i] valueForKey:@"alias"] forKey:@"alias"];
                [displayDataArray addObject:displayDictionary];
            }
        }
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

//sort
- (void)segmentedChanged:(UISegmentedControl*)segment{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            NSLog(@"Ascending");
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
            NSArray *sortDescriptorArray = [NSArray arrayWithObjects:sortDescriptor, nil];
            NSArray *sortedList = [displayDataArray sortedArrayUsingDescriptors:sortDescriptorArray];
            displayDataArray = [sortedList mutableCopy];
            [self.tableView reloadData];
            break;
        }
        case 1:{
            NSLog(@"Descending");
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:NO];
            NSArray *sortDescriptorArray = [NSArray arrayWithObjects:sortDescriptor, nil];
            NSArray *sortedList = [displayDataArray sortedArrayUsingDescriptors:sortDescriptorArray];
            displayDataArray = [sortedList mutableCopy];
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"StatisticsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [@"Node ID:" stringByAppendingString:[NSString stringWithFormat:@"%@", [displayDataArray[indexPath.row] valueForKey:@"nodeId"]]];
    cell.textLabel.text = [[displayDataArray[indexPath.row] valueForKey:@"alias"] stringByAppendingString:[NSString stringWithFormat:@" - %@", NSLocalizedString(@"Water Level", nil)]];
    
    float distance = DISTANCE_TO_GROUND-[[displayDataArray[indexPath.row] valueForKey:@"value"] floatValue];
    NSLog(@"dog %f", distance);
    if (distance > appDelegate->minimumWaterLevel) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }else{
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2fcm", distance];
    
    return cell;
}

//set color
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    float distance = DISTANCE_TO_GROUND-[[displayDataArray[indexPath.row] valueForKey:@"value"] floatValue];

    if (distance > appDelegate->minimumWaterLevel) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.09 brightness:0.99 alpha:1.0];
    }
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController->nodeId = [[displayDataArray[indexPath.row] valueForKey:@"nodeId"] intValue];
    for (int i = 0; i<nodeArray.count; i++) {
        if ([[nodeArray[i] valueForKey:@"id"] intValue] == [[displayDataArray[indexPath.row] valueForKey:@"nodeId"] intValue]) {
            detailViewController->nodeData = nodeArray[i];
        }
    }
    detailViewController.hidesBottomBarWhenPushed = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)settingButtonTapped{
    NSLog(@"settingButtonTapped");
    SettingTableViewController *settingTableViewController = [[SettingTableViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingTableViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
