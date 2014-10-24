//
//  TableViewController.m
//  Techrice
//
//  Created by 藤賀 雄太 on 10/17/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.delegate = self;
    seg.tintColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.4 alpha:255];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tabBarController.delegate = self;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    nodeArray = appDelegate.nodeArray;
    distanceArray = appDelegate.distanceArray;
    
    NSArray *arr = @[@"Ascending", @"Descending"];
    seg = [[UISegmentedControl alloc] initWithItems:arr];
    
    seg.frame = CGRectMake(0, 0, 250, 30);

    [seg addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:seg];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)segmentedChanged:(UISegmentedControl*)segment{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            NSLog(@"Ascending");
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
            NSArray *sortDescriptorArray = [NSArray arrayWithObjects:sortDescriptor, nil];
            NSArray *sortedList = [distanceArray sortedArrayUsingDescriptors:sortDescriptorArray];
            distanceArray = sortedList;
            [self.tableView reloadData];
            break;
        }
        case 1:{
            NSLog(@"Descending");
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:NO];
            NSArray *sortDescriptorArray = [NSArray arrayWithObjects:sortDescriptor, nil];
            NSArray *sortedList = [distanceArray sortedArrayUsingDescriptors:sortDescriptorArray];
            distanceArray = sortedList;
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return nodeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"StatisticsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.textLabel.text = [@"Node ID:" stringByAppendingString:[[nodeArray objectAtIndex:indexPath.row] valueForKey:@"id"]];
    
    cell.textLabel.text = [@"Node ID:" stringByAppendingString:[NSString stringWithFormat:@"%@", [distanceArray[indexPath.row] valueForKey:@"nodeid"]]];
    float distance = [[distanceArray[indexPath.row] valueForKey:@"value"] floatValue];
    if (distance > THRESHOLD) {
        cell.detailTextLabel.textColor = [UIColor redColor];
    }else{
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2fcm", distance];
    
    //UILabelでやる
//    UILabel *sensorDataLabel =[[UILabel alloc] initWithFrame:CGRectMake(200, 0, 320, 40)];
//    sensorDataLabel.text = [NSString stringWithFormat:@"%0.2fcm", [[[[[nodeArray objectAtIndex:indexPath.row] valueForKey:@"sensors"][0] valueForKey:@"latest_reading"] valueForKey:@"value"] floatValue]];
//    [cell.contentView addSubview:sensorDataLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    float distance = [[distanceArray[indexPath.row] valueForKey:@"value"] floatValue];
    if (distance > THRESHOLD) {
        cell.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.09 brightness:0.99 alpha:1.0];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    detailViewController->nodeId = [[distanceArray[indexPath.row] valueForKey:@"nodeid"] intValue];
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
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
