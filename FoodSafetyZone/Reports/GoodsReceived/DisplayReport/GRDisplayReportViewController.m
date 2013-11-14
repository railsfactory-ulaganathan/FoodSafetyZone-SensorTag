//
//  GRDisplayReportViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 15/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "GRDisplayReportViewController.h"

@interface GRDisplayReportViewController ()

@end

@implementation GRDisplayReportViewController
@synthesize HeaderLbl;

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
    self.navigationItem.title = @"GOODS RECEIVED";
    [self loadDataForPage];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [DBManager sharedInstance];
    foodTypes = [[NSMutableArray alloc]init];
    suppliers = [[NSMutableArray alloc]init];
    temperatures = [[NSMutableArray alloc]init];
    usedByDates = [[NSMutableArray alloc]init];
    times = [[NSMutableArray alloc]init];
    correctiveActions = [[NSMutableArray alloc]init];
    acceptStatus = [[NSMutableArray alloc]init];
    HeaderLbl.text = [NSString stringWithFormat:@"%@",dbManager.tempStorageValues];
}

-(void)loadDataForPage
{
    if (foodTypes)
    {
        [foodTypes removeAllObjects];
        [suppliers removeAllObjects];
        [temperatures removeAllObjects];
        [usedByDates removeAllObjects];
        [times removeAllObjects];
        [correctiveActions removeAllObjects];
        [acceptStatus removeAllObjects];
    }
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbManager.fmResults next])
    {
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM recordForGoodsReceived WHERE date = ?",tempStorageValues];
    while([dbManager.fmResults next])
    {
        [foodTypes addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodType"]]];
        [suppliers addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"supplier"]]];
        [temperatures addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodTemp"]]];
        [usedByDates addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"date"]]];
        [times addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"time"]]];
        [correctiveActions addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"problems"]]];
        [acceptStatus addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"acceptStatus"]]];
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
    return [foodTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"GRCustomCellId";
    GRCustomCell *cell = (GRCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GRCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.foodTypeLbl.text = [NSString stringWithFormat:@"%@",[foodTypes objectAtIndex:indexPath.row]];
    cell.supplierLbl.text = [NSString stringWithFormat:@"%@",[suppliers objectAtIndex:indexPath.row]];
    cell.temperatureLbl.text = [NSString stringWithFormat:@"%@",[temperatures objectAtIndex:indexPath.row]];
    cell.usedByLbl.text = [NSString stringWithFormat:@"%@",[usedByDates objectAtIndex:indexPath.row]];
    cell.timeLbl.text = [NSString stringWithFormat:@"%@",[times objectAtIndex:indexPath.row]];
    if ([correctiveActions objectAtIndex:indexPath.row])
    {
        cell.correctiveActionLbl.hidden = YES;
        cell.correctiveActionValueLbl.hidden = YES;
    }
    else
    {
        cell.correctiveActionLbl.hidden = NO;
        cell.correctiveActionValueLbl.hidden = YES;
        cell.correctiveActionValueLbl.text = [NSString stringWithFormat:@"%@",[correctiveActions objectAtIndex:indexPath.row]];
    }
    if ([[acceptStatus objectAtIndex:indexPath.row] isEqualToString:@"A"])
    {
        cell.acceptImage.image = [UIImage imageNamed:@"accepted.png"];
    }
    else
    {
        cell.acceptImage.image = [UIImage imageNamed:@"rejected.png"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
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
    foodTypes = nil;
    suppliers = nil;
    temperatures = nil;
    usedByDates = nil;
    times = nil;
    correctiveActions = nil;
    acceptStatus = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
