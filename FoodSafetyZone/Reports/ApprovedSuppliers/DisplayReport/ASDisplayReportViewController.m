//
//  ASDisplayReportViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 10/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ASDisplayReportViewController.h"

@interface ASDisplayReportViewController ()

@end

@implementation ASDisplayReportViewController
@synthesize supplierName,supplyStartDate,mainScroll,addressNPhone,otherInfo,foodItemTable,backView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    self.navigationItem.title = @"SUPPLIERS";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sectionTitleArray = [[NSMutableArray alloc]init];
    arrayForBool = [[NSMutableArray alloc]init];
    mainScroll.contentSize = backView.bounds.size;
    [mainScroll addSubview:backView];
    [self loadDataForPage];
}

-(void)loadDataForPage
{
    dbManager = [DBManager sharedInstance];
    if (sectionTitleArray)
    {
        [sectionTitleArray removeAllObjects];
    }
    int selectedID;
    
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbManager.fmResults next])
    {
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM suppliers WHERE id = ?",[NSNumber numberWithInt:[tempStorageValues integerValue]]];
    while([dbManager.fmResults next])
    {
        supplierName.text = [dbManager.fmResults stringForColumn:@"supplierName"];
        addressNPhone.text = [NSString stringWithFormat:@"%@,%@\n%@%@\n%@%@", [dbManager.fmResults stringForColumn:@"streetName"],[dbManager.fmResults stringForColumn:@"province"],[dbManager.fmResults stringForColumn:@"city"],[dbManager.fmResults stringForColumn:@"pin"],[dbManager.fmResults stringForColumn:@"state"],[dbManager.fmResults stringForColumn:@"country"]];
        selectedID = [dbManager.fmResults intForColumn:@"id"];
        otherInfo.text = [dbManager.fmResults stringForColumn:@"otherInformation"];
        supplyStartDate.text = [dbManager.fmResults stringForColumn:@"date"];
    }
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT foodCategory FROM supplierFoodItems WHERE supplierId = ?",[NSNumber numberWithInt:selectedID]];
    while([dbManager.fmResults next])
    {
        if (![sectionTitleArray containsObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodCategory"]]])
            [sectionTitleArray addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodCategory"]]];
    }
    if (arrayForBool)
    {
        [arrayForBool removeAllObjects];
    }
    sectionContentDict  = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [sectionTitleArray count]; i++)
    {
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        NSMutableArray *tempimg = [[NSMutableArray alloc]init];
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
        dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM supplierFoodItems WHERE foodCategory = ?",[sectionTitleArray objectAtIndex:i]];
        while([dbManager.fmResults next])
        {
            if ([dbManager.fmResults intForColumn:@"supplierId"] == selectedID)
            {
                [temp addObject:[dbManager.fmResults stringForColumn:@"foodItem"]];
                [tempimg addObject:[UIImage imageWithData:[dbManager.fmResults dataForColumn:@"foodItemImage"]]];
            }
        }
        [sectionContentDict setValue:temp forKey:[sectionTitleArray objectAtIndex:i]];
        [sectionContentDict setValue:tempimg forKey:[NSString stringWithFormat:@"img%@",[sectionTitleArray objectAtIndex:i]]];
        temp = nil;
        tempimg = nil;
    }
    [self.foodItemTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[arrayForBool objectAtIndex:section] boolValue])
    {
        return [[sectionContentDict objectForKey:[sectionTitleArray objectAtIndex:section]] count];
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor whiteColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-50, 50)];
    headerString.backgroundColor = [UIColor clearColor];
    BOOL manyCells                  = [[arrayForBool objectAtIndex:section] boolValue];
    if (!manyCells) {
        headerString.text = [sectionTitleArray objectAtIndex:section];
    }else{
        headerString.text = [sectionTitleArray objectAtIndex:section];
    }
    headerString.textAlignment      = NSTextAlignmentLeft;
    headerString.textColor          = [UIColor blackColor];
    [headerView addSubview:headerString];
    headerString = nil;
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [headerView addGestureRecognizer:headerTapped];
    headerTapped = nil;
    
    //up or down arrow depending on the bool
    UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"arrow_down.png"] : [UIImage imageNamed:@"arrow_right.png"]];
    upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
    upDownArrow.frame               = CGRectMake(self.view.frame.size.width-40, 10, 30, 30);
    [headerView addSubview:upDownArrow];
    upDownArrow = nil;
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue])
    {
        return 50;
    }
    else
    {
        return 1;
    }
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    if (!manyCells)
    {
        cell.textLabel.text = [sectionTitleArray objectAtIndex:indexPath.section];
    }
    else
    {
        NSArray *content = [sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
        cell.textLabel.text = [content objectAtIndex:indexPath.row];
        NSArray *img = [sectionContentDict valueForKey:[NSString stringWithFormat:@"img%@",[sectionTitleArray objectAtIndex:indexPath.section]]];
        cell.imageView.image = [img objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.foodItemTable deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        collapsed       = !collapsed;
        [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
        
        //reload specific section animated
        NSRange range   = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.foodItemTable reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
