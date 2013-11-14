//
//  ReportsDisplayViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 24/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ReportsDisplayViewController.h"

@interface ReportsDisplayViewController ()
{
    UITextField *myTextField;
}

@end

@implementation ReportsDisplayViewController
@synthesize unitNames,time,temp,correctiveActions,rangeStatus;

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
    self.navigationItem.title = @"STORAGE UNITS";
    [self loadDataForView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    unitNames = [[NSMutableArray alloc]init];
    time = [[NSMutableArray alloc]init];
    temp = [[NSMutableArray alloc]init];
    correctiveActions = [[NSMutableArray alloc]init];
    rangeStatus = [[NSMutableArray alloc]init];
    dbmanager = [DBManager sharedInstance];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDataForView
{
    
    if (unitNames)
    {
        [unitNames removeAllObjects];
        [time removeAllObjects];
        [temp removeAllObjects];
        [correctiveActions removeAllObjects];
        [rangeStatus removeAllObjects];
    }
    
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbmanager.fmResults next])
    {
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordsForStorageUnit WHERE dateField = ?",tempStorageValues];
    NSLog(@"%@",dbmanager.fmResults);
    while([dbmanager.fmResults next])
    {
        [unitNames addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"storageUnitName"]]];
        [time addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"timeField"]]];
        [temp addObject:[NSString stringWithFormat:@"%.2f",[dbmanager.fmResults doubleForColumn:@"temperature"]]];
        [correctiveActions addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"correctiveAction"]]];
        [rangeStatus addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"tempRangeStatus"]]];
    }
    [self.tableView reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [unitNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([[rangeStatus objectAtIndex:indexPath.row] isEqualToString:@"IN"])
    {
        UIView *inRangeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 40, 21)];
        unitLabel.text = @"UNIT";
        unitLabel.textColor = [UIColor darkGrayColor];
        [inRangeView addSubview:unitLabel];
        unitLabel = nil;
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 40, 45, 21)];
        timeLabel.text = @"TIME";
        timeLabel.textColor = [UIColor darkGrayColor];
        [inRangeView addSubview:timeLabel];
        timeLabel = nil;
        UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 70, 50, 21)];
        tempLabel.text = @"TEMP";
        tempLabel.textColor = [UIColor darkGrayColor];
        [inRangeView addSubview:tempLabel];
        tempLabel = nil;
        
        UILabel *colon1 = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 10, 21)];
        colon1.text = @":";
        colon1.textColor = [UIColor darkGrayColor];
        [inRangeView addSubview:colon1];
        colon1 = nil;
        UILabel *colon2 = [[UILabel alloc]initWithFrame:CGRectMake(150, 40, 10, 21)];
        colon2.text = @":";
        colon2.textColor = [UIColor darkGrayColor];
        [inRangeView addSubview:colon2];
        colon2 = nil;
        UILabel *colon3 = [[UILabel alloc]initWithFrame:CGRectMake(150, 70, 10, 21)];
        colon3.text = @":";
        colon3.textColor = [UIColor darkGrayColor];
        [inRangeView addSubview:colon3];
        colon3 = nil;
        
        UILabel *unitValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 10, 100, 21)];
        unitValueLabel.text = [NSString stringWithFormat:@"%@",[unitNames objectAtIndex:indexPath.row]];
        unitValueLabel.textColor = [UIColor darkGrayColor];
        [inRangeView addSubview:unitValueLabel];
        unitValueLabel = nil;
        UILabel *timeValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 40, 100, 21)];
        timeValueLabel.text = [NSString stringWithFormat:@"%@",[time objectAtIndex:indexPath.row]];
        timeValueLabel.textColor = [UIColor darkGrayColor];
        [inRangeView addSubview:timeValueLabel];
        timeValueLabel = nil;
        UILabel *tempValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 70, 100, 21)];
        tempValueLabel.text = [NSString stringWithFormat:@"%@",[temp objectAtIndex:indexPath.row]];
        tempValueLabel.textColor = [UIColor darkGrayColor];
        [inRangeView addSubview:tempValueLabel];
        tempValueLabel = nil;
        
        UIImageView *inOut = [[UIImageView alloc]initWithFrame:CGRectMake(270, 70, 40, 21)];
        inOut.image = [UIImage imageNamed:@"in-icon.png"];
        [inRangeView addSubview:inOut];
        inOut = nil;
        
        [cell.contentView addSubview:inRangeView];
        inRangeView = nil;
    }
    else
    {
        UIView *outRangeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 40, 21)];
        unitLabel.text = @"UNIT";
        unitLabel.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:unitLabel];
        unitLabel = nil;
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 40, 45, 21)];
        timeLabel.text = @"TIME";
        timeLabel.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:timeLabel];
        timeLabel = nil;
        UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 70, 50, 21)];
        tempLabel.text = @"TEMP";
        tempLabel.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:tempLabel];
        tempLabel = nil;
        UILabel *correctiveLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 102, 131, 21)];
        correctiveLabel.text = @"CORRECTIVE ACTION";
        correctiveLabel.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:correctiveLabel];
        correctiveLabel = nil;
        
        UILabel *colon1 = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 10, 21)];
        colon1.text = @":";
        colon1.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:colon1];
        colon1 = nil;
        UILabel *colon2 = [[UILabel alloc]initWithFrame:CGRectMake(150, 40, 10, 21)];
        colon2.text = @":";
        colon2.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:colon2];
        colon2 = nil;
        UILabel *colon3 = [[UILabel alloc]initWithFrame:CGRectMake(150, 70, 10, 21)];
        colon3.text = @":";
        colon3.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:colon3];
        colon3 = nil;
        UILabel *colon4 = [[UILabel alloc]initWithFrame:CGRectMake(150, 102, 10, 21)];
        colon4.text = @":";
        colon4.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:colon4];
        colon4 = nil;
        
        UILabel *unitValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 10, 100, 21)];
        unitValueLabel.text = [NSString stringWithFormat:@"%@",[unitNames objectAtIndex:indexPath.row]];
        unitValueLabel.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:unitValueLabel];
        unitValueLabel = nil;
        UILabel *timeValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 40, 100, 21)];
        timeValueLabel.text = [NSString stringWithFormat:@"%@",[time objectAtIndex:indexPath.row]];
        timeValueLabel.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:timeValueLabel];
        timeValueLabel = nil;
        UILabel *tempValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 70, 100, 21)];
        tempValueLabel.text = [NSString stringWithFormat:@"%@",[temp objectAtIndex:indexPath.row]];
        tempValueLabel.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:tempValueLabel];
        tempValueLabel = nil;
        
        UILabel *correctiveValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 126, 295, 40)];
        correctiveValueLabel.text = [NSString stringWithFormat:@"%@",[correctiveActions objectAtIndex:indexPath.row]];
        correctiveValueLabel.numberOfLines = 2;
        correctiveValueLabel.textColor = [UIColor darkGrayColor];
        [outRangeView addSubview:correctiveValueLabel];
        correctiveValueLabel = nil;
        
        UIImageView *inOut = [[UIImageView alloc]initWithFrame:CGRectMake(270, 70, 40, 21)];
        inOut.image = [UIImage imageNamed:@"out-icon.png"];
        [outRangeView addSubview:inOut];
        inOut = nil;
        
        [cell.contentView addSubview:outRangeView];
        outRangeView = nil;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[rangeStatus objectAtIndex:indexPath.row] isEqualToString:@"IN"])
    {
        return 100;
    }
    else
    {
        return 175;
    }
}

-(void)backClicked
{
    unitNames = nil;
    time = nil;
    temp = nil;
    correctiveActions = nil;
    rangeStatus = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
