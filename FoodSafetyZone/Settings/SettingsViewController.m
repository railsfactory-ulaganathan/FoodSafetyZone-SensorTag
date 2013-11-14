//
//  SettingsViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 20/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "SettingsViewController.h"
#import "TimeLogViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"ACTIVITY TIMELOG";
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 40);
    [back setImage:[UIImage imageNamed:@"new-main-menu-button.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    listArray = [[NSMutableArray alloc]initWithObjects:@"Time Log-Activity", nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellbackview.png"]];
    cell.backgroundView = backView;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[listArray objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {    // The iOS device = iPhone or iPod Touch
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            
            if (iOSDeviceScreenSize.height == 480)
            {
                TimeLogViewController *timelogs = [[TimeLogViewController alloc]initWithNibName:@"TimeLogViewController" bundle:nil];
                [self.navigationController pushViewController:timelogs animated:YES];
                timelogs = nil;
            }
            if (iOSDeviceScreenSize.height > 480)
            {
                TimeLogViewController *timelogs = [[TimeLogViewController alloc]initWithNibName:@"TimeLogViewController5" bundle:nil];
                [self.navigationController pushViewController:timelogs animated:YES];
                timelogs = nil;
            }
        }

    }
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
