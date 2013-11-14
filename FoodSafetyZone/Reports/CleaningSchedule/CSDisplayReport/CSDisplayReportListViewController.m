//
//  CSDisplayReportListViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 29/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "CSDisplayReportListViewController.h"

@interface CSDisplayReportListViewController ()

@end

@implementation CSDisplayReportListViewController
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
    frequencies = [[NSMutableArray alloc]init];
    cleaningInstrs = [[NSMutableArray alloc]init];
    products = [[NSMutableArray alloc]init];
    responsiblePersons = [[NSMutableArray alloc]init];
    reviewers = [[NSMutableArray alloc]init];
    splInstrs = [[NSMutableArray alloc]init];
    headerLbl.text = [NSString stringWithFormat:@"%@",dbManager.tempStorageValues];
}

-(void)loadDataForPage
{
    if (frequencies)
    {
        [frequencies removeAllObjects];
        [cleaningInstrs removeAllObjects];
        [products removeAllObjects];
        [responsiblePersons removeAllObjects];
        [reviewers removeAllObjects];
        [splInstrs removeAllObjects];
    }
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbManager.fmResults next])
    {
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    
    headerLbl.text = tempStorageValues;
    
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM recordForCleaningSchedule WHERE equipmentName = ?",tempStorageValues];
    while([dbManager.fmResults next])
    {
        [frequencies addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"frequency"]]];
        [cleaningInstrs addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"cleaningInstruction"]]];
        [products addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"productsToUse"]]];
        [responsiblePersons addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"responsiblePerson"]]];
        [reviewers addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"reviewedBy"]]];
        [splInstrs addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"specialInstruction"]]];
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
    return [frequencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CSDisplayCell";
    CSDisplayCell *cell = (CSDisplayCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CSDisplayCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.frequency.text = [NSString stringWithFormat:@"%@",[frequencies objectAtIndex:indexPath.row]];
    cell.cleaningInstr.text = [NSString stringWithFormat:@"%@",[cleaningInstrs objectAtIndex:indexPath.row]];
    cell.productsToUse.text = [NSString stringWithFormat:@"%@",[products objectAtIndex:indexPath.row]];
    cell.responsiblePerson.text = [NSString stringWithFormat:@"%@",[responsiblePersons objectAtIndex:indexPath.row]];
    cell.specialInstr.text = [NSString stringWithFormat:@"%@",[splInstrs objectAtIndex:indexPath.row]];
    cell.reviewedBy.text = [NSString stringWithFormat:@"%@",[reviewers objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 280;
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
    frequencies = nil;
    cleaningInstrs = nil;
    products = nil;
    responsiblePersons = nil;
    reviewers = nil;
    splInstrs = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setHeaderLbl:nil];
    [super viewDidUnload];
}
@end
