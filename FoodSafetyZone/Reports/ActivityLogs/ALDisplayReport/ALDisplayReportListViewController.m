//
//  ALDisplayReportListViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 30/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ALDisplayReportListViewController.h"
#import "ALDisplayReportViewController.h"

@interface ALDisplayReportListViewController ()

@end

@implementation ALDisplayReportListViewController
@synthesize headerLbl;

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
    [back setImage:[UIImage imageNamed:@"new-back-button.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    back = nil;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftBarButton = nil;
    self.navigationItem.title = @"ACTIVITY LOGS";
    [self loadDataForPage];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)loadDataForPage
{
    dbmanager = [DBManager sharedInstance];
    viewTags = 0;
    listOfDates = [[NSMutableArray alloc]init];
    listOfRecords = [[NSMutableArray alloc]init];
    rowwise = [[NSMutableArray alloc]init];
    
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbmanager.fmResults next])
    {
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    headerLbl.text = [NSString stringWithFormat:@"%@",tempStorageValues];
    if (listOfDates)
    {
        [listOfDates removeAllObjects];
        [listOfRecords removeAllObjects];
    }
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordForActivityLog WHERE date = ? ",[NSString stringWithFormat:@"%@",tempStorageValues]];
    while([dbmanager.fmResults next])
    {
        [listOfDates addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"foodName"]]];
    }
    //SORTING ALL THE VALUES
    [listOfDates sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *newArray =  [[NSSet setWithArray:listOfDates] allObjects];
    
    //FINDING NUMBER OF OCCURANCES
    int occurrences = 0;
    for (int i=0; i<[newArray count]; i++)
    {
        for(NSString *string in listOfDates){
            occurrences += ([string isEqualToString:[NSString stringWithFormat:@"%@",[newArray objectAtIndex:i]]]?1:0);
        }
        [listOfRecords addObject:[NSString stringWithFormat:@"%d",occurrences]];
        occurrences = 0;
    }
    [listOfDates removeAllObjects];
    listOfDates = [NSMutableArray arrayWithArray:newArray];
    newArray = nil;
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
    return [listOfDates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[listOfDates objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, 30, 30);
    button.frame = frame;
    [button setBackgroundImage:[UIImage imageNamed:@"count-bg.png"] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"%@",[listOfRecords objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.accessoryView = button;
    button = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL status = [dbmanager.fmDatabase  executeUpdate:@"UPDATE temp SET tempStorageValue = ? WHERE id = 1",[NSMutableString stringWithFormat:@"%@",[listOfDates objectAtIndex:indexPath.row]]];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if (iOSDeviceScreenSize.height == 480)
        {
            ALDisplayReportViewController *reportsList = [[ALDisplayReportViewController alloc]initWithNibName:@"ALDisplayReportViewController" bundle:nil];
            [self.navigationController pushViewController:reportsList animated:YES];
            reportsList = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            ALDisplayReportViewController *reportsList = [[ALDisplayReportViewController alloc]initWithNibName:@"ALDisplayReportViewController5" bundle:nil];
            [self.navigationController pushViewController:reportsList animated:YES];
            reportsList = nil;
        }
    }
}

-(void)backClicked
{
    [self clearMemory];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clearMemory
{
    listOfDates = nil;
    listOfRecords = nil;
    rowwise = nil;
    allViews = nil;
    GeneratePDF = nil;
}
- (void)viewDidUnload
{
    [self setHeaderLbl:nil];
    [super viewDidUnload];
}
@end
