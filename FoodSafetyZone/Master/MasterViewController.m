//
//  MasterViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 15/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "MasterViewController.h"
#import "StorageUnitTypeViewController.h"
#import "FoodCategoryViewController.h"
#import "MasterEquipmentsViewController.h"

@interface MasterViewController ()
{
    NSArray *masterList;
    UIButton *accessoryButton;
}

@end

@implementation MasterViewController

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
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 40);
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"new-main-menu-button.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    back = nil;
    self.navigationItem.leftBarButtonItem = backButton;
    backButton = nil;
    self.navigationItem.title = @"MASTERS";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    masterList = [[NSArray alloc]initWithObjects:@"FoodCategory",@"StorageUnit - Unit Type",@"Equipment", nil];

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
    return [masterList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[masterList objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accessoryButton.tag = indexPath.row;
    accessoryButton.frame = CGRectMake(0, 0, 35, 35);
    [accessoryButton setImage:[UIImage imageNamed:@"list-icon.png"] forState:UIControlStateNormal];
    [accessoryButton addTarget:self action:@selector(AccessoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = accessoryButton;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {    // The iOS device = iPhone or iPod Touch
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            if (iOSDeviceScreenSize.height == 480)
            {
                StorageUnitTypeViewController *storageUnitTypes = [[StorageUnitTypeViewController alloc]initWithNibName:@"StorageUnitTypeViewController" bundle:nil];
                [self.navigationController pushViewController:storageUnitTypes animated:YES];
                storageUnitTypes = nil;
            }
            if (iOSDeviceScreenSize.height > 480)
            {
                StorageUnitTypeViewController *storageUnitTypes = [[StorageUnitTypeViewController alloc]initWithNibName:@"StorageUnitTypeViewController5" bundle:nil];
                [self.navigationController pushViewController:storageUnitTypes animated:YES];
                storageUnitTypes = nil;
            }
        }
    }
    if (indexPath.row == 0)
    {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {    // The iOS device = iPhone or iPod Touch
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            if (iOSDeviceScreenSize.height == 480)
            {
                FoodCategoryViewController *foodCategory = [[FoodCategoryViewController alloc]initWithNibName:@"FoodCategoryViewController" bundle:nil];
                [self.navigationController pushViewController:foodCategory animated:YES];
                foodCategory = nil;
            }
            if (iOSDeviceScreenSize.height > 480)
            {
                FoodCategoryViewController *foodCategory = [[FoodCategoryViewController alloc]initWithNibName:@"FoodCategoryViewController5" bundle:nil];
                [self.navigationController pushViewController:foodCategory animated:YES];
                foodCategory = nil;
            }
        }
    }
    if (indexPath.row == 2)
    {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {    // The iOS device = iPhone or iPod Touch
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            if (iOSDeviceScreenSize.height == 480)
            {
                MasterEquipmentsViewController *equip = [[MasterEquipmentsViewController alloc]initWithNibName:@"MasterEquipmentsViewController" bundle:nil];
                [self.navigationController pushViewController:equip animated:YES];
                equip = nil;
            }
            if (iOSDeviceScreenSize.height > 480)
            {
                MasterEquipmentsViewController *equip = [[MasterEquipmentsViewController alloc]initWithNibName:@"MasterEquipmentsViewController5" bundle:nil];
                [self.navigationController pushViewController:equip animated:YES];
                equip = nil;
            }
        }
    }

}

-(void)AccessoryButtonClicked:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
            {
                NSLog(@"%@",[masterList objectAtIndex:sender.tag]);
                FoodCategoryViewController *foodCategory = [[FoodCategoryViewController alloc]init];
                [self.navigationController pushViewController:foodCategory animated:YES];
                break;
            }
        case 1:
            {
                NSLog(@"%@",[masterList objectAtIndex:sender.tag]);
                StorageUnitTypeViewController *storageUnitTypes = [[StorageUnitTypeViewController alloc]init];
                [self.navigationController pushViewController:storageUnitTypes animated:YES];
                break;
            }
        case 2:
            {
                NSLog(@"%@",[masterList objectAtIndex:sender.tag]);
                break;
            }
            
    }
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
