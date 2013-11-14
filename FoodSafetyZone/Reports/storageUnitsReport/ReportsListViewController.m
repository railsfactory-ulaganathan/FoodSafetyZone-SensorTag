//
//  ReportsListViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 23/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ReportsListViewController.h"
#import "ReportsDisplayViewController.h"
#import "ReportView.h"
#import "ReportTableHeader.h"
#import "correctiveAction.h"

@interface ReportsListViewController ()

@end

@implementation ReportsListViewController
@synthesize GeneratePDF,allViews;
@synthesize daywise,rowwise,wed,thu,fri,sat,sun;
@synthesize headerViewForReports,headerStartDateLbl,footerViewForReports;
@synthesize correctiveHeading;

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
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 50, 40);
    [doneButton setImage:[UIImage imageNamed:@"mail-icon.png"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:doneButton];
    doneButton = nil;
    self.navigationItem.rightBarButtonItem = rightBarButton;
    rightBarButton = nil;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 40);
    [back setImage:[UIImage imageNamed:@"new-back-button.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    back = nil;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftBarButton = nil;
    self.navigationItem.title = @"STORAGE UNITS";
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
    correctAction = [[NSMutableArray alloc]init];
    dateTake = [[NSMutableArray alloc]init];
    
    UnitNames = [[NSMutableArray alloc]init];
    time = [[NSMutableArray alloc]init];
    temperature = [[NSMutableArray alloc]init];
    
    if (listOfDates)
    {
        [listOfDates removeAllObjects];
        [listOfRecords removeAllObjects];
        [temperature removeAllObjects];
        [UnitNames removeAllObjects];
        [time removeAllObjects];
    }
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordsForStorageUnit WHERE dateField BETWEEN ? AND ? ",[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
    while([dbmanager.fmResults next])
    {
        [listOfDates addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"dateField"]]];
        [UnitNames addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"storageUnitName"]]];
        [time addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"timeField"]]];
        [temperature addObject:[NSString stringWithFormat:@"%.2f",[dbmanager.fmResults doubleForColumn:@"temperature"]]];
    }
    
    
    NSLog(@"LIST OF DATES %@",listOfDates);
    
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

-(void)seperateDataDaywise
{
    daywise = [[NSMutableArray alloc]init];
    rowwise = [[NSMutableArray alloc]init];
    allViews = [[NSMutableArray alloc]init];
    wed = [[NSMutableArray alloc]init];
    thu = [[NSMutableArray alloc]init];
    fri = [[NSMutableArray alloc]init];
    sat = [[NSMutableArray alloc]init];
    sun = [[NSMutableArray alloc]init];
    tableHeaders = [[NSMutableArray alloc]initWithObjects:@"Unit",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
    tableSubHeaders = [[NSMutableArray alloc]initWithObjects:@" ",@"Time am/pm | Temp",@"Time am/pm | Temp",@"Time am/pm | Temp",@"Time am/pm | Temp",@"Time am/pm | Temp",@"Time am/pm | Temp",@"Time am/pm | Temp", nil];
    
    NSArray *newa = [[NSSet setWithArray:UnitNames] allObjects];
    [UnitNames removeAllObjects];
    UnitNames = [NSMutableArray arrayWithArray:newa];
    newa = nil;
    totalRows = [UnitNames count];
    
    for (int t = 0; t<[UnitNames count]; t++)
    {
        dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordsForStorageUnit WHERE storageUnitName=? AND dateField LIKE '%Mon' AND dateField BETWEEN ? AND ? ",[UnitNames objectAtIndex:t],[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
        while([dbmanager.fmResults next])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"timeField"]] forKey:@"Time"];
            [dict setValue:[NSString stringWithFormat:@"%.1f",[dbmanager.fmResults doubleForColumn:@"temperature"]] forKey:@"Temp"];
            [dict setValue:[NSString stringWithFormat:@"%@",[UnitNames objectAtIndex:t]] forKey:@"storageUnit"];
            [dict setValue:@"Monday" forKey:@"day"];
            [daywise addObject:dict];
            dict = nil;
        }
        
        dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordsForStorageUnit WHERE storageUnitName=? AND dateField LIKE '%Tue' AND dateField BETWEEN ? AND ? ",[UnitNames objectAtIndex:t],[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
        while([dbmanager.fmResults next])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"timeField"]] forKey:@"Time"];
            [dict setValue:[NSString stringWithFormat:@"%.1f",[dbmanager.fmResults doubleForColumn:@"temperature"]] forKey:@"Temp"];
            [dict setValue:[NSString stringWithFormat:@"%@",[UnitNames objectAtIndex:t]] forKey:@"storageUnit"];
            [dict setValue:@"Tuesday" forKey:@"day"];
            [daywise addObject:dict];
            dict = nil;
        }

        
        dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordsForStorageUnit WHERE storageUnitName=? AND dateField LIKE '%Wed' AND dateField BETWEEN ? AND ? ",[UnitNames objectAtIndex:t],[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
        while([dbmanager.fmResults next])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"timeField"]] forKey:@"Time"];
            [dict setValue:[NSString stringWithFormat:@"%.1f",[dbmanager.fmResults doubleForColumn:@"temperature"]] forKey:@"Temp"];
            [dict setValue:[NSString stringWithFormat:@"%@",[UnitNames objectAtIndex:t]] forKey:@"storageUnit"];
            [dict setValue:@"Wednesday" forKey:@"day"];
            [daywise addObject:dict];
            dict = nil;
        }
        
        dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordsForStorageUnit WHERE storageUnitName=? AND dateField LIKE '%Thu' AND dateField BETWEEN ? AND ? ",[UnitNames objectAtIndex:t],[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
        while([dbmanager.fmResults next])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"timeField"]] forKey:@"Time"];
            [dict setValue:[NSString stringWithFormat:@"%.1f",[dbmanager.fmResults doubleForColumn:@"temperature"]] forKey:@"Temp"];
            [dict setValue:[NSString stringWithFormat:@"%@",[UnitNames objectAtIndex:t]] forKey:@"storageUnit"];
            [dict setValue:@"Thursday" forKey:@"day"];
            [daywise addObject:dict];
            dict = nil;
        }
        
        dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordsForStorageUnit WHERE storageUnitName=? AND dateField LIKE '%Fri'AND dateField BETWEEN ? AND ?",[UnitNames objectAtIndex:t],[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
        while([dbmanager.fmResults next])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"timeField"]] forKey:@"Time"];
            [dict setValue:[NSString stringWithFormat:@"%.1f",[dbmanager.fmResults doubleForColumn:@"temperature"]] forKey:@"Temp"];
            [dict setValue:[NSString stringWithFormat:@"%@",[UnitNames objectAtIndex:t]] forKey:@"storageUnit"];
            [dict setValue:@"Friday" forKey:@"day"];
            [daywise addObject:dict];
            dict = nil;
        }
        
        dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordsForStorageUnit WHERE storageUnitName=? AND dateField LIKE '%Sat' AND dateField BETWEEN ? AND ? ",[UnitNames objectAtIndex:t],[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
        while([dbmanager.fmResults next])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"timeField"]] forKey:@"Time"];
            [dict setValue:[NSString stringWithFormat:@"%.1f",[dbmanager.fmResults doubleForColumn:@"temperature"]] forKey:@"Temp"];
            [dict setValue:[NSString stringWithFormat:@"%@",[UnitNames objectAtIndex:t]] forKey:@"storageUnit"];
            [dict setValue:@"Saturday" forKey:@"day"];
            [daywise addObject:dict];
            dict = nil;
        }
        
        dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordsForStorageUnit WHERE storageUnitName=? AND dateField LIKE '%Sun' AND dateField BETWEEN ? AND ? ",[UnitNames objectAtIndex:t],[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
        while([dbmanager.fmResults next])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"timeField"]] forKey:@"Time"];
            [dict setValue:[NSString stringWithFormat:@"%.1f",[dbmanager.fmResults doubleForColumn:@"temperature"]] forKey:@"Temp"];
            [dict setValue:[NSString stringWithFormat:@"%@",[UnitNames objectAtIndex:t]] forKey:@"storageUnit"];
            [dict setValue:@"Sunday" forKey:@"day"];
            [daywise addObject:dict];
            dict = nil;
        }
        
    }
    NSLog(@"daywise %@",daywise);
    NSMutableDictionary *record;
    rowwise = [[NSMutableArray alloc]init];
    for (int j = 0; j < [UnitNames count]; j++)
    {
        int colCount = 0;
        for (int i = 0; i<[daywise count]; i++)
        {
            if (colCount >= 7 || colCount == 0)
            {
                if (colCount == 7)
                {
                    [rowwise addObject:record];
                    record = nil;
                    record = [[NSMutableDictionary alloc]init];
                    colCount = 0;
                }
                else
                {
                    record = nil;
                    record = [[NSMutableDictionary alloc]init];
                }
            }
           
            if ([[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] isEqualToString:[UnitNames objectAtIndex:j]])
            {
                if ([[[daywise objectAtIndex:i] objectForKey:@"day"]isEqualToString:@"Monday"])
                {
                    if ([record objectForKey:@"Mon"])
                    {
                        [rowwise addObject:record];
                        record = nil;
                        record = [[NSMutableDictionary alloc]init];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"MonTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"MonTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"MonUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Mon"];
                        colCount += 1;
                    }
                    else
                    {
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"MonTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"MonTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"MonUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Mon"];
                        colCount += 1;
                    }
                }
                else if ([[[daywise objectAtIndex:i] objectForKey:@"day"]isEqualToString:@"Tuesday"])
                {
                    if ([record objectForKey:@"Tue"])
                    {
                        [rowwise addObject:record];
                        record = nil;
                        record = [[NSMutableDictionary alloc]init];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"TueTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"TueTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"TueUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Tue"];
                        colCount += 1;
                    }
                    else
                    {
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"TueTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"TueTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"TueUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Tue"];
                        colCount += 1;
                    }
                }
                else if ([[[daywise objectAtIndex:i] objectForKey:@"day"]isEqualToString:@"Wednesday"])
                {
                    if ([record objectForKey:@"Wed"])
                    {
                        [rowwise addObject:record];
                        record = nil;
                        record = [[NSMutableDictionary alloc]init];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"WedTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"WedTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"WedUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Wed"];
                        colCount += 1;
                    }
                    else
                    {
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"WedTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"WedTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"WedUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Wed"];
                        colCount += 1;
                    }
                }
                else if ([[[daywise objectAtIndex:i] objectForKey:@"day"]isEqualToString:@"Thursday"])
                {
                    if ([record objectForKey:@"Thu"])
                    {
                        [rowwise addObject:record];
                        record = nil;
                        record = [[NSMutableDictionary alloc]init];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"ThuTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"ThuTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"ThuUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Thu"];
                        colCount += 1;
                    }
                    else
                    {
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"ThuTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"ThuTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"ThuUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Thu"];
                        colCount += 1;
                    }
                }
                else if ([[[daywise objectAtIndex:i] objectForKey:@"day"]isEqualToString:@"Friday"])
                {
                    if ([record objectForKey:@"Fri"])
                    {
                        [rowwise addObject:record];
                        record = nil;
                        record = [[NSMutableDictionary alloc]init];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"FriTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"FriTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"FriUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Fri"];
                        colCount += 1;
                    }
                    else
                    {
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"FriTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"FriTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"FriUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Fri"];
                        colCount += 1;
                    }
                }
                else if ([[[daywise objectAtIndex:i] objectForKey:@"day"]isEqualToString:@"Saturday"])
                {
                    if ([record objectForKey:@"Sat"])
                    {
                        [rowwise addObject:record];
                        record = nil;
                        record = [[NSMutableDictionary alloc]init];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"SatTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"SatTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"SatUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Sat"];
                        colCount += 1;
                    }
                    else
                    {
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"SatTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"SatTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"SatUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Sat"];
                        colCount += 1;
                    }
                }
                else if ([[[daywise objectAtIndex:i] objectForKey:@"day"]isEqualToString:@"Sunday"])
                {
                    if ([record objectForKey:@"Sun"])
                    {
                        [rowwise addObject:record];
                        record = nil;
                        record = [[NSMutableDictionary alloc]init];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"SunTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"SunTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"SunUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Sun"];
                        colCount += 1;
                    }
                    else
                    {
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Time"] forKey:@"SunTime"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"Temp"] forKey:@"SunTemp"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"storageUnit"] forKey:@"SunUnit"];
                        [record setValue:[[daywise objectAtIndex:i] objectForKey:@"day"] forKey:@"Sun"];
                        colCount += 1;
                    }
                }
            }
        }
        [rowwise addObject:record];
        record = nil;
    }
    daywise = nil;
    NSLog(@"data seperated by day %@",rowwise);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING");
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
        [self clearMemory];
        if (iOSDeviceScreenSize.height == 480)
        {
            ReportsDisplayViewController *showReports = [[ReportsDisplayViewController alloc]initWithNibName:@"ReportsDisplayViewController" bundle:nil];
            [self.navigationController pushViewController:showReports animated:YES];
            showReports = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            ReportsDisplayViewController *showReports = [[ReportsDisplayViewController alloc]initWithNibName:@"ReportsDisplayViewController5" bundle:nil];
            [self.navigationController pushViewController:showReports animated:YES];
            showReports = nil;
        }
    }
}

-(void)backClicked
{
    [dbmanager.tempArray removeAllObjects];
    [self clearMemory];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self clearMemory];
}
-(void)clearMemory
{
    GeneratePDF = nil;
    listOfDates = nil;
    listOfRecords = nil;
    myTextField = nil;
    allViews = nil;
    UnitNames = nil;
    temperature = nil;
    time = nil;
    correctAction = nil;
    dateTake = nil;
    daywise = nil;
    rowwise = nil;
    wed = nil;
    thu = nil;
    fri = nil;
    sat = nil;
    sun = nil;
    tableHeaders = nil;
    tableSubHeaders = nil;

}

-(void)doneClicked
{
    [self seperateDataDaywise];
    if ([listOfDates count]>0)
    {
        [self loadDataForPDF];
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                              message:@"No Record Found!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [myAlertView show];
        myAlertView = nil;
    }
}

-(void)loadDataForPDF
{
    totalColumns = 8;
    xpos = 0;
    ypos = 0;
    cellWidth = 76;
    cellHeight = 30;
    
    GeneratePDF = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 612, 792)];
    
    [self generateView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Enter file name"
                                                          message:@"sdfsdfsdfdsffsf" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    myAlertView.tag = 22;
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    [myAlertView addSubview:myTextField];
    [myAlertView show];
    myAlertView = nil;
}

-(void)generatePdfView
{
    viewTags+=1;
    UIView *pdfView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 612, 792)];
    pdfView.tag = viewTags;
    GeneratePDF = pdfView;
    pdfView = nil;
}

-(UIView *)tableHeaderView
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReportTableHeader" owner:nil options:nil];
    ReportTableHeader *hView  = [nib objectAtIndex:0];
    nib = nil;
    hView.frame=CGRectMake(0,ypos,612,55);
    hView.unit.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.mon.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.tue.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.wed.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.thu.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.fri.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.sat.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.sun.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.empty.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.t1.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.tp1.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.t2.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.tp2.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.t3.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.tp3.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.t4.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.tp4.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.t5.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.tp5.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.t6.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.tp6.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.t7.layer.borderColor = [[UIColor blackColor] CGColor];
    hView.tp7.layer.borderColor = [[UIColor blackColor] CGColor];
    
    hView.unit.layer.borderWidth = 1;
    hView.mon.layer.borderWidth = 1;
    hView.tue.layer.borderWidth = 1;
    hView.wed.layer.borderWidth = 1;
    hView.thu.layer.borderWidth = 1;
    hView.fri.layer.borderWidth = 1;
    hView.sat.layer.borderWidth = 1;
    hView.sun.layer.borderWidth = 1;
    hView.empty.layer.borderWidth = 1;
    hView.t1.layer.borderWidth = 1;
    hView.tp1.layer.borderWidth = 1;
    hView.t2.layer.borderWidth = 1;
    hView.tp2.layer.borderWidth = 1;
    hView.t3.layer.borderWidth = 1;
    hView.tp3.layer.borderWidth = 1;
    hView.t4.layer.borderWidth = 1;
    hView.tp4.layer.borderWidth = 1;
    hView.t5.layer.borderWidth = 1;
    hView.tp5.layer.borderWidth = 1;
    hView.t6.layer.borderWidth = 1;
    hView.tp6.layer.borderWidth = 1;
    hView.t7.layer.borderWidth = 1;
    hView.tp7.layer.borderWidth = 1;

    return hView;
}

-(void)generateView
{
    char cString[] = "\u2103";
    NSData *data = [NSData dataWithBytes:cString length:strlen(cString)];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    data = nil;
    headerStartDateLbl.text = [dbmanager.tempArray objectAtIndex:0];
    [GeneratePDF addSubview:headerViewForReports];
    ypos = 125;
    UIView *hdr = [self tableHeaderView];
    [GeneratePDF addSubview:hdr];
    hdr = nil;
    ypos+=55;
    
    for (int i = 0; i<[rowwise count]; i++)
    {
        if (ypos < 700)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReportView" owner:nil options:nil];
            ReportView *rView  = [nib objectAtIndex:0];
            nib = nil;
            rView.frame=CGRectMake(0,ypos,612,30);
            
            if ([rowwise objectAtIndex:i])
            {
                if (i%2==0)
                {
                    rView.backgroundColor = [UIColor lightGrayColor];
                }
                else
                {
                    rView.backgroundColor = [UIColor darkGrayColor];
                }
                
                NSString *su;
                if ([[rowwise objectAtIndex:i] objectForKey:@"MonUnit"])
                {
                    su = [[rowwise objectAtIndex:i] objectForKey:@"MonUnit"];
                }
                else if ([[rowwise objectAtIndex:i] objectForKey:@"TueUnit"])
                {
                    su = [[rowwise objectAtIndex:i] objectForKey:@"TueUnit"];
                }
                else if ([[rowwise objectAtIndex:i] objectForKey:@"WedUnit"])
                {
                    su = [[rowwise objectAtIndex:i] objectForKey:@"WedUnit"];
                }
                else if ([[rowwise objectAtIndex:i] objectForKey:@"ThuUnit"])
                {
                    su = [[rowwise objectAtIndex:i] objectForKey:@"ThuUnit"];
                }
                else if ([[rowwise objectAtIndex:i] objectForKey:@"FriUnit"])
                {
                    su = [[rowwise objectAtIndex:i] objectForKey:@"FriUnit"];
                }
                else if ([[rowwise objectAtIndex:i] objectForKey:@"SatUnit"])
                {
                    su = [[rowwise objectAtIndex:i] objectForKey:@"SatUnit"];
                }
                else if ([[rowwise objectAtIndex:i] objectForKey:@"SunUnit"])
                {
                    su = [[rowwise objectAtIndex:i] objectForKey:@"SunUnit"];
                }
                
                rView.unitNameLbl.text = [NSString stringWithFormat:@"%@",su];
                su = nil;
                rView.unitNameLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.unitNameLbl.layer.borderWidth = 1.0;
                
                rView.mondayTimeLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                if ([[rowwise objectAtIndex:i] objectForKey:@"Mon"])
                {
                    rView.mondayTimeLbl.text =  [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"MonTime"]];
                    rView.mondayTempLbl.text =  [NSString stringWithFormat:@"%@%@",[[rowwise objectAtIndex:i] objectForKey:@"MonTemp"],string];
                }
                
                rView.mondayTimeLbl.layer.borderWidth = 1.0;
                rView.mondayTempLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.mondayTempLbl.layer.borderWidth = 1.0;
                
                rView.tuesdayTempLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.tuesdayTempLbl.layer.borderWidth = 1.0;
                if ([[rowwise objectAtIndex:i] objectForKey:@"Tue"])
                {
                    rView.tuesdayTimeLbl.text =  [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"TueTime"]];
                    rView.tuesdayTempLbl.text =  [NSString stringWithFormat:@"%@%@",[[rowwise objectAtIndex:i] objectForKey:@"TueTemp"],string];
                }
                rView.tuesdayTimeLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.tuesdayTimeLbl.layer.borderWidth = 1.0;
                
                rView.wednesdayTimeLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.wednesdayTimeLbl.layer.borderWidth = 1.0;
                if ([[rowwise objectAtIndex:i] objectForKey:@"Wed"])
                {
                    rView.wednesdayTimeLbl.text =  [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"WedTime"]];
                    rView.wednesdayTempLbl.text =  [NSString stringWithFormat:@"%@%@",[[rowwise objectAtIndex:i] objectForKey:@"WedTemp"],string];
                }
                rView.wednesdayTempLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.wednesdayTempLbl.layer.borderWidth = 1.0;
                
                rView.thursdayTempLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.thursdayTempLbl.layer.borderWidth = 1.0;
                if ([[rowwise objectAtIndex:i] objectForKey:@"Thu"])
                {
                    rView.thursdayTimeLbl.text =  [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"ThuTime"]];
                    rView.thursdayTempLbl.text =  [NSString stringWithFormat:@"%@%@",[[rowwise objectAtIndex:i] objectForKey:@"ThuTemp"],string];
                }
                rView.thursdayTimeLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.thursdayTimeLbl.layer.borderWidth = 1.0;
                
                rView.fridayTimeLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.fridayTimeLbl.layer.borderWidth = 1.0;
                if ([[rowwise objectAtIndex:i] objectForKey:@"Fri"])
                {
                    rView.fridayTimeLbl.text =  [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"FriTime"]];
                    rView.fridayTempLbl.text =  [NSString stringWithFormat:@"%@%@",[[rowwise objectAtIndex:i] objectForKey:@"FriTemp"],string];
                }
                rView.fridayTempLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.fridayTempLbl.layer.borderWidth = 1.0;
                
                rView.saturdayTempLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.saturdayTempLbl.layer.borderWidth = 1.0;
                if ([[rowwise objectAtIndex:i] objectForKey:@"Sat"])
                {
                    rView.saturdayTimeLbl.text =  [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"SatTime"]];
                    rView.saturdayTempLbl.text =  [NSString stringWithFormat:@"%@%@",[[rowwise objectAtIndex:i] objectForKey:@"SatTemp"],string];
                }
                rView.saturdayTimeLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.saturdayTimeLbl.layer.borderWidth = 1.0;
                
                rView.sundayTempLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.sundayTempLbl.layer.borderWidth = 1.0;
                if ([[rowwise objectAtIndex:i] objectForKey:@"Sun"])
                {
                    rView.sundayTimeLbl.text =  [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"SunTime"]];
                    rView.sundayTempLbl.text =  [NSString stringWithFormat:@"%@%@",[[rowwise objectAtIndex:i] objectForKey:@"SunTemp"],string];
                }
                rView.sundayTimeLbl.layer.borderColor = [[UIColor blackColor] CGColor];
                rView.sundayTimeLbl.layer.borderWidth = 1.0;
                
                [GeneratePDF addSubview:rView];
                rView = nil;
                ypos+=30;
            }
        }
        else
        {
            [allViews addObject:GeneratePDF];
            GeneratePDF = nil;
            ypos = 20;
            [self generatePdfView];
            UIView *hdr = [self tableHeaderView];
            [GeneratePDF addSubview:hdr];
            hdr = nil;
            ypos += 55;
        }
    }
    string = nil;
    
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordsForStorageUnit WHERE dateField BETWEEN ? AND ? ",[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
    while([dbmanager.fmResults next])
    {
        if ([[dbmanager.fmResults stringForColumn:@"correctiveAction"]length]>0)
        {
            [correctAction addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"correctiveAction"]]];
            [dateTake addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"dateField"]]];
        }
    }
    if ([correctAction count]>0)
    {
        if (ypos < 680)
        {
            correctiveHeading.frame = CGRectMake(0, ypos, 612, 30);
            [GeneratePDF addSubview:correctiveHeading];
            correctiveHeading = nil;
            ypos +=30;
        }
        else
        {
            [allViews addObject:GeneratePDF];
            GeneratePDF = nil;
            ypos = 20;
            [self generatePdfView];
            correctiveHeading.frame = CGRectMake(0, ypos, 612, 30);
            [GeneratePDF addSubview:correctiveHeading];
            correctiveHeading = nil;
            ypos +=30;
        }

        for (int i = 0; i<[correctAction count]; i++)
        {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"correctiveAction" owner:nil options:nil];
                correctiveAction *rView  = [nib objectAtIndex:0];
                nib = nil;
                rView.frame=CGRectMake(0,ypos,612,30);
                rView.actionTaken.text = [correctAction objectAtIndex:i];
                rView.date.text = [dateTake objectAtIndex:i];
                rView.layer.borderWidth = 1.0;
                rView.layer.borderColor = [[UIColor blackColor] CGColor];
                [GeneratePDF addSubview:rView];
                rView = nil;
                ypos += 30;
        }
    }
    if ([allViews count] == 0)
    {
        footerViewForReports.frame = CGRectMake(0, ypos+25, 612, 200);
        [GeneratePDF addSubview:footerViewForReports];
        [allViews addObject:GeneratePDF];
        GeneratePDF = nil;
    }
    else
    {
        footerViewForReports.frame = CGRectMake(0, ypos+25, 612, 200);
        [GeneratePDF addSubview:footerViewForReports];
        [allViews addObject:GeneratePDF];
        GeneratePDF = nil;
    }

    [self generatePdfView];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *name = [NSString stringWithFormat:@"%@.pdf",myTextField.text];
    if (actionSheet.tag == 22 && buttonIndex == 1)
    {
        [self createPDFfromUIView:GeneratePDF saveToDocumentsWithFileName:name];
        name = nil;
    }
}

-(void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
       
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    
    int numberofPages;
    
    NSString *docDirectory =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pdfPath = [docDirectory stringByAppendingPathComponent:aFilename];
    docDirectory = nil;
    
    // set the size of the page (the page is in landscape format)
    CGRect pageBounds = CGRectMake(0.0f, 0.0f, 612.0f, 792.0f);
    numberofPages = [allViews count];

    UIView *tempView = [[UIView alloc]init];
    // create and save the pdf file
    UIGraphicsBeginPDFContextToFile(pdfPath, pageBounds, nil);
    {
        for (int i = 0; i<numberofPages; i++)
        {
            tempView = [allViews objectAtIndex:i];
            UIGraphicsBeginPDFPage();
            [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
            
        }
    }
    tempView = nil;
    UIGraphicsEndPDFContext();
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"Report from the date %@ to %@",[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]]];
        
        NSString *pdfName = [NSString stringWithFormat:@"%@", pdfPath];
        NSData *pdfData = [NSData dataWithContentsOfFile:pdfName];
        pdfName = nil;
        pdfPath = nil;
        [mailer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:aFilename];
        aFilename = nil;
        pdfData = nil;
        [self presentViewController:mailer animated:YES completion:Nil];
        self.navigationController.navigationBar.tintColor = [UIColor greenColor];
        mailer = nil;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Go to iPhone Settings and sync a mail id to receive reports!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [self removeSubviews];
        alert = nil;
    }
    myTextField = nil;
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *errorStr;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			errorStr = @"Mail cancelled: you cancelled the operation and no email message was queued";
			break;
		case MFMailComposeResultSaved:
			errorStr = @"Mail saved: you saved the email message in the Drafts folder";
			break;
		case MFMailComposeResultSent:
			errorStr = @"Mail sent successfully!!";
			break;
		case MFMailComposeResultFailed:
			errorStr = @"Mail failed: the email message was nog saved or queued, possibly due to an error";
			break;
		default:
			errorStr = @"Mail not sent";
			break;
	}
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:errorStr
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [self removeSubviews];
    alert = nil;
    errorStr = nil;
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void)removeSubviews
{
    for (int i=0; i<[allViews count]; i++)
    {
        for (UIView *subview in [[allViews objectAtIndex:i] subviews])
        {
            [subview removeFromSuperview];
        }
    }
    allViews = nil;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [listOfDates removeAllObjects];
}


@end
