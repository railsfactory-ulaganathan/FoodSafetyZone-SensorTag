//
//  ShowTimeLogReportViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 04/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ShowTimeLogReportViewController.h"

@interface ShowTimeLogReportViewController ()

@end

@implementation ShowTimeLogReportViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [DBManager sharedInstance];
    FoodNames = [[NSMutableArray alloc]init];
    activityNames = [[NSMutableArray alloc]init];
    actionsTaken = [[NSMutableArray alloc]init];
    foodTemps = [[NSMutableArray alloc]init];
    startTimes = [[NSMutableArray alloc]init];
    stopTimes = [[NSMutableArray alloc]init];
    totalTimes = [[NSMutableArray alloc]init];
    [self loadDataForPage];
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

-(void)viewWillAppear:(BOOL)animated
{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 40);
    [back setImage:[UIImage imageNamed:@"new-back-button.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    back = nil;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftBarButton = nil;
    self.navigationItem.title = @"TIME LOGS";
    
}


-(void)loadDataForPage
{
    if (FoodNames)
    {
        [FoodNames removeAllObjects];
        [foodTemps removeAllObjects];
        [activityNames removeAllObjects];
        [actionsTaken removeAllObjects];
        [startTimes removeAllObjects];
        [stopTimes removeAllObjects];
        [totalTimes removeAllObjects];
    }
    
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbManager.fmResults next])
    {
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM recordForTimeLogs WHERE date = ?",tempStorageValues];
    while([dbManager.fmResults next])
    {
        [FoodNames addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodName"]]];
        [activityNames addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"activityName"]]];
        [actionsTaken addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"actionTaken"]]];
        [startTimes addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"startTime"]]];
        [stopTimes addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"endTime"]]];
        [foodTemps addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodTemp"]]];
        [totalTimes addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"endTime"]]];
    }
    [self.tableView reloadData];
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
    return [FoodNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TimelogReportCell";
    TimelogReportCell *cell = (TimelogReportCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimelogReportCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.foodNameValue.text = [FoodNames objectAtIndex:indexPath.row];
    cell.activityNameValue.text = [activityNames objectAtIndex:indexPath.row];
    cell.actionNameValue.text = [actionsTaken objectAtIndex:indexPath.row];
    cell.foodTempValue.text = [foodTemps objectAtIndex:indexPath.row];
    cell.startTimeValue.text = [startTimes objectAtIndex:indexPath.row];
    cell.stopTimeValue.text = [stopTimes objectAtIndex:indexPath.row];
    cell.totalTimeValue.text = [stopTimes objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 215;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)backClicked
{
    FoodNames = nil;
    foodTemps = nil;
    actionsTaken = nil;
    activityNames = nil;
    startTimes = nil;
    stopTimes = nil;
    totalTimes = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
