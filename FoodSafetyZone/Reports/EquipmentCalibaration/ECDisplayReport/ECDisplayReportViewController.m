//
//  ECDisplayReportViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 22/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ECDisplayReportViewController.h"

@interface ECDisplayReportViewController ()

@end

@implementation ECDisplayReportViewController
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
    self.navigationItem.title = @"EQUIPMENT CALIBRATION";
    [self loadDataForPage];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [DBManager sharedInstance];
    equipmentNames = [[NSMutableArray alloc]init];
    contractors = [[NSMutableArray alloc]init];
    iceWaterTemps = [[NSMutableArray alloc]init];
    boilingWaterTemps = [[NSMutableArray alloc]init];
    passStatus = [[NSMutableArray alloc]init];
    correctiveActions = [[NSMutableArray alloc]init];
    headerLbl.text = [NSString stringWithFormat:@"%@",dbManager.tempStorageValues];
}

-(void)loadDataForPage
{
    if (equipmentNames)
    {
        [equipmentNames removeAllObjects];
        [contractors removeAllObjects];
        [iceWaterTemps removeAllObjects];
        [boilingWaterTemps removeAllObjects];
        [passStatus removeAllObjects];
        [correctiveActions removeAllObjects];
    }
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbManager.fmResults next])
    {
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    
    headerLbl.text = tempStorageValues;
    
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM RecordsForEquipments WHERE dateOfService = ?",tempStorageValues];
    while([dbManager.fmResults next])
    {
        [equipmentNames addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"equipmentName"]]];
        [contractors addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"contractorName"]]];
        [iceWaterTemps addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"iceWaterTemp"]]];
        [boilingWaterTemps addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"hotWaterTemp"]]];
        [passStatus addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"passStatus"]]];
        [correctiveActions addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"correctiveActions"]]];
    }
    [self.tableView reloadData];
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
    return [equipmentNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ECDisplayCell";
    ECDisplayCell *cell = (ECDisplayCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ECDisplayCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.equipmentName.text = [NSString stringWithFormat:@"%@",[equipmentNames objectAtIndex:indexPath.row]];
    cell.contractorName.text = [NSString stringWithFormat:@"%@",[contractors objectAtIndex:indexPath.row]];
    cell.iceWaterTemp.text = [NSString stringWithFormat:@"%@",[iceWaterTemps objectAtIndex:indexPath.row]];
    cell.boilingWaterTemp.text = [NSString stringWithFormat:@"%@",[boilingWaterTemps objectAtIndex:indexPath.row]];
    if ([[passStatus objectAtIndex:indexPath.row] isEqualToString:@"Pass"])
    {
        cell.passstatus.image = [UIImage imageNamed:@"passed.png"];
    }
    else
    {
        cell.passstatus.image = [UIImage imageNamed:@"failed.png"];
    }
    
    if ([correctiveActions objectAtIndex:indexPath.row])
    {
        cell.correctiveAction.hidden = NO;
        cell.correctiveActionValue.hidden = NO;
        cell.correctiveActionValue.text = [NSString stringWithFormat:@"%@",[correctiveActions objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.correctiveAction.hidden = YES;
        cell.correctiveActionValue.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)backClicked
{
    equipmentNames = nil;
    contractors = nil;
    iceWaterTemps = nil;
    boilingWaterTemps = nil;
    passStatus = nil;
    correctiveActions = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setHeaderLbl:nil];
    [super viewDidUnload];
}
@end
