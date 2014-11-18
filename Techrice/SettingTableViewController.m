//
//  SettingTableViewController.m
//  Techrice
//
//  Created by 藤賀 雄太 on 11/18/14.
//  Copyright (c) 2014 Future Lab. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SettingValueViewController.h"
#import "AppDelegate.h"
@interface SettingTableViewController ()

@end

@implementation SettingTableViewController


-(id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"foo");
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"Red distance threshold";
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", appDelegate->distanceThreshold];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingValueViewController *settingValueController = [[SettingValueViewController alloc] init];
    [self.navigationController pushViewController:settingValueController animated:YES];
}

@end
