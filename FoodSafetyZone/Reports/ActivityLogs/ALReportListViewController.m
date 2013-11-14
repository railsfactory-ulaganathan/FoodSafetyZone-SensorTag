//
//  ALReportListViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 28/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ALReportListViewController.h"
#import "ALDisplayReportListViewController.h"

@interface ALReportListViewController ()

@end

@implementation ALReportListViewController
@synthesize TLHeaderView;

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
    self.navigationItem.title = @"ACTIVITY LOGS";
    [self loadDataForPage];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)loadDataForPage
{
    int f = 11;
    dbmanager = [DBManager sharedInstance];
    viewTags = 0;
    listOfDates = [[NSMutableArray alloc]init];
    listOfRecords = [[NSMutableArray alloc]init];
    rowwise = [[NSMutableArray alloc]init];
    
    if (listOfDates)
    {
        [listOfDates removeAllObjects];
        [listOfRecords removeAllObjects];
    }
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordForActivityLog WHERE date BETWEEN ? AND ?  ",[NSString stringWithFormat:@"%@",[dbmanager.tempArray objectAtIndex:0]],[NSString stringWithFormat:@"%@",[dbmanager.tempArray objectAtIndex:1]]];
    while([dbmanager.fmResults next])
    {
        if ([dbmanager.fmResults intForColumn:@"completeStatus"] == f)
        {
            [listOfDates addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"date"]]];
        }
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
                ALDisplayReportListViewController *reportsList = [[ALDisplayReportListViewController alloc]initWithNibName:@"ALDisplayReportListViewController" bundle:nil];
                [self.navigationController pushViewController:reportsList animated:YES];
        }
        if (iOSDeviceScreenSize.height > 480)
        {
                ALDisplayReportListViewController *reportsList = [[ALDisplayReportListViewController alloc]initWithNibName:@"ALDisplayReportListViewController5" bundle:nil];
                [self.navigationController pushViewController:reportsList animated:YES];
        }
    }
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

-(void)seperateDataDaywise
{
    allViews = [[NSMutableArray alloc]init];
    if (rowwise)
    {
        [rowwise removeAllObjects];
    }
    
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordForActivityLog WHERE date BETWEEN ? AND ? ",[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
    while([dbmanager.fmResults next])
        
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"activity"]] forKey:@"activity"];
        NSString *tem = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"date"]];
        NSArray *t = [tem componentsSeparatedByString:@","];
        [dict setValue:[t objectAtIndex:0] forKey:@"date"];
        t = nil;
        tem = nil;
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"preparation"]] forKey:@"preparation"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"cookingFood"]] forKey:@"cookingFood"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"coolingFood"]] forKey:@"coolingFood"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"reheatingFood"]] forKey:@"reheatingFood"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"hotHolding"]] forKey:@"hotHolding"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"serving"]] forKey:@"serving"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"foodPacking"]] forKey:@"foodPacking"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"foodName"]] forKey:@"foodName"];
        [rowwise addObject:dict];
        dict = nil;
    }
    
    NSLog(@"ROWWISE %@",rowwise);
}

-(NSString *)getActivity:(int)idd
{
    NSString *dict;
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM activityLogFoodItem WHERE id = ? ",[NSNumber numberWithInt:idd]];
    while([dbmanager.fmResults next])
    {
        dict = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"activity"]];
    }
    return dict;
}

-(void)loadDataForPDF
{
    totalColumns = 8;
    xpos = 10;
    ypos = 0;
    cellWidth = 76;
    cellHeight = 30;
    
    GeneratePDF = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 792, 612)];
    
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

-(void)generateView
{
    if (allViews)
    {
        [allViews removeAllObjects];
    }
    ypos = 20;
    TLHeaderView.frame = CGRectMake(20, ypos, 650, 20);
    [GeneratePDF addSubview:TLHeaderView];
    ypos = 50;
    for (int i = 0; i<[rowwise count]; i++)
    {
        if (ypos < 500)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ALTableHeader" owner:nil options:nil];
            ALTableHeader *hView  = [nib objectAtIndex:0];
            nib = nil;
            hView.frame=CGRectMake(20,ypos,650,168);
            hView.dateValue.text = [[rowwise objectAtIndex:i] objectForKey:@"date"];
            NSString *string = [[rowwise objectAtIndex:i] objectForKey:@"activity"];
            if ([string rangeOfString:@"Preparation"].location != NSNotFound)
            {
                hView.preparationImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.preparationImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if ([string rangeOfString:@"Cooling food"].location != NSNotFound)
            {
                hView.coolingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.coolingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if ([string rangeOfString:@"Reheating"].location != NSNotFound)
            {
                hView.reheatingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.reheatingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if ([string rangeOfString:@"Serving"].location != NSNotFound)
            {
                hView.servingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.servingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if ([string rangeOfString:@"Cooking food"].location != NSNotFound)
            {
                hView.cookingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.cookingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if ([string rangeOfString:@"Hot holding"].location != NSNotFound)
            {
                hView.hotholdingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.hotholdingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if ([string rangeOfString:@"Food packing"].location != NSNotFound)
            {
                hView.foodPackingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.foodPackingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            NSArray *t = [string componentsSeparatedByString:@"((/"];
            string = @"";
            for (int i = 0; i < [t count]; i++)
            {
                string = [NSString stringWithFormat:@"%@%@",string,[t objectAtIndex:i]];
            }
            NSArray *tt = [string componentsSeparatedByString:@"))"];
            t= nil;
            NSMutableArray *t1 = [[NSMutableArray alloc]initWithArray:tt];
            tt = nil;
            int k = [t1 count];
            [t1 removeObjectAtIndex:k-1];
            NSLog(@"ACTIVITY %@",t1);
            for (int x = 0; x < [t1 count]; x++)
            {
                switch (x)
                {
                    case 0:
                        hView.activity1.text = [t1 objectAtIndex:0];
                        break;
                    case 1:
                        hView.activity2.text = [t1 objectAtIndex:1];
                        break;
                    case 2:
                        hView.activity3.text = [t1 objectAtIndex:2];
                        break;
                    case 3:
                        hView.activity4.text = [t1 objectAtIndex:3];
                        break;
                    case 4:
                        hView.activity5.text = [t1 objectAtIndex:4];
                        break;
                    case 5:
                        hView.activity6.text = [t1 objectAtIndex:5];
                        break;
                    case 6:
                        hView.activity7.text = [t1 objectAtIndex:6];
                        break;
                }

            }
            hView.menuItemValue.text = [[rowwise objectAtIndex:i] objectForKey:@"foodName"];
            [GeneratePDF addSubview:hView];
            hView = nil;
            ypos += 168;
            NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"ALTableRow" owner:nil options:nil];
            ALTableRow *rView  = [nib1 objectAtIndex:0];
            if ([[rowwise objectAtIndex:i] objectForKey:@"preparation"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"preparation"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS1.text = [allData objectAtIndex:0];
                    rView.tempS1.text = [allData objectAtIndex:1];
                    rView.timeE1.text = [allData objectAtIndex:2];
                    rView.tempE1.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"cookingFood"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"cookingFood"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS2.text = [allData objectAtIndex:0];
                    rView.tempS2.text = [allData objectAtIndex:1];
                    rView.timeE2.text = [allData objectAtIndex:2];
                    rView.tempE2.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"coolingFood"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"coolingFood"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS3.text = [allData objectAtIndex:0];
                    rView.tempS3.text = [allData objectAtIndex:1];
                    rView.timeE3.text = [allData objectAtIndex:2];
                    rView.tempE3.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"reheatingFood"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"reheatingFood"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS4.text = [allData objectAtIndex:0];
                    rView.tempS4.text = [allData objectAtIndex:1];
                    rView.timeE4.text = [allData objectAtIndex:2];
                    rView.tempE4.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"hotHolding"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"hotHolding"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS5.text = [allData objectAtIndex:0];
                    rView.tempS5.text = [allData objectAtIndex:1];
                    rView.timeE5.text = [allData objectAtIndex:2];
                    rView.tempE5.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"serving"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"serving"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS6.text = [allData objectAtIndex:0];
                    rView.tempS6.text = [allData objectAtIndex:1];
                    rView.timeE6.text = [allData objectAtIndex:2];
                    rView.tempE6.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"foodPacking"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"foodPacking"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS7.text = [allData objectAtIndex:0];
                    rView.tempS7.text = [allData objectAtIndex:1];
                    rView.timeE7.text = [allData objectAtIndex:2];
                    rView.tempE7.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }


            nib1 = nil;
            rView.frame = CGRectMake(20,ypos,650,50);
            [GeneratePDF addSubview:rView];
            rView = nil;
            ypos+=100;
        }
        else
        {
            UILabel *pgNumber = [[UILabel alloc]initWithFrame:CGRectMake(700, 590, 80,20)];
            pgNumber.text = [NSString stringWithFormat:@"Page %d",[allViews count]+1];
            [GeneratePDF addSubview:pgNumber];
            pgNumber = nil;
            [allViews addObject:GeneratePDF];
            GeneratePDF = nil;
            ypos = 20;
            [self generatePdfView];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ALTableHeader" owner:nil options:nil];
            ALTableHeader *hView  = [nib objectAtIndex:0];
            nib = nil;
            hView.frame=CGRectMake(20,ypos,650,168);
            hView.dateValue.text = [[rowwise objectAtIndex:i] objectForKey:@"date"];
            NSString *string = [[rowwise objectAtIndex:i] objectForKey:@"activity"];
            if (![string rangeOfString:@"Preparation"].location != NSNotFound)
            {
                hView.preparationImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.preparationImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if (![string rangeOfString:@"Cooling food"].location != NSNotFound)
            {
                hView.coolingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.coolingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if (![string rangeOfString:@"Reheating"].location != NSNotFound)
            {
                hView.reheatingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.reheatingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if (![string rangeOfString:@"Serving"].location != NSNotFound)
            {
                hView.servingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.servingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if (![string rangeOfString:@"Cooking food"].location != NSNotFound)
            {
                hView.cookingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.cookingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if (![string rangeOfString:@"Hot holding"].location != NSNotFound)
            {
                hView.hotholdingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.hotholdingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            if (![string rangeOfString:@"Food packing"].location != NSNotFound)
            {
                hView.foodPackingImageView.image = [UIImage imageNamed:@"checkbox_select.png"];
            }
            else
            {
                hView.foodPackingImageView.image = [UIImage imageNamed:@"checkbox.png"];
            }
            hView.menuItemValue.text = [[rowwise objectAtIndex:i] objectForKey:@"foodName"];
            [GeneratePDF addSubview:hView];
            hView = nil;
            ypos += 168;
            NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"ALTableRow" owner:nil options:nil];
            ALTableRow *rView  = [nib1 objectAtIndex:0];
            if ([[rowwise objectAtIndex:i] objectForKey:@"preparation"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"preparation"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS1.text = [allData objectAtIndex:0];
                    rView.tempS1.text = [allData objectAtIndex:1];
                    rView.timeE1.text = [allData objectAtIndex:2];
                    rView.tempE1.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"cookingFood"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"cookingFood"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS2.text = [allData objectAtIndex:0];
                    rView.tempS2.text = [allData objectAtIndex:1];
                    rView.timeE2.text = [allData objectAtIndex:2];
                    rView.tempE2.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"coolingFood"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"coolingFood"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS3.text = [allData objectAtIndex:0];
                    rView.tempS3.text = [allData objectAtIndex:1];
                    rView.timeE3.text = [allData objectAtIndex:2];
                    rView.tempE3.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"reheatingFood"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"reheatingFood"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS4.text = [allData objectAtIndex:0];
                    rView.tempS4.text = [allData objectAtIndex:1];
                    rView.timeE4.text = [allData objectAtIndex:2];
                    rView.tempE4.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"hotHolding"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"hotHolding"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS5.text = [allData objectAtIndex:0];
                    rView.tempS5.text = [allData objectAtIndex:1];
                    rView.timeE5.text = [allData objectAtIndex:2];
                    rView.tempE5.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"serving"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"serving"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS6.text = [allData objectAtIndex:0];
                    rView.tempS6.text = [allData objectAtIndex:1];
                    rView.timeE6.text = [allData objectAtIndex:2];
                    rView.tempE6.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            if ([[rowwise objectAtIndex:i] objectForKey:@"foodPacking"])
            {
                NSString *dd = [[rowwise objectAtIndex:i] objectForKey:@"foodPacking"];
                NSArray *al = [dd componentsSeparatedByString:@"((/"];
                dd = @"";
                for (int j = 0; j < [al count]; j ++)
                {
                    dd = [NSString stringWithFormat:@"%@%@",dd,[al objectAtIndex:j]];
                }
                NSArray *all = [dd componentsSeparatedByString:@"))"];
                NSMutableArray *allData = [[NSMutableArray alloc]initWithArray:all];
                [allData removeObjectAtIndex:([all count]-1)];
                NSLog(@"Preparation %@",allData);
                if ([allData count] > 1)
                {
                    rView.timeS7.text = [allData objectAtIndex:0];
                    rView.tempS7.text = [allData objectAtIndex:1];
                    rView.timeE7.text = [allData objectAtIndex:2];
                    rView.tempE7.text = [allData objectAtIndex:3];
                }
                all = nil;
                allData = nil;
            }
            
            
            nib1 = nil;
            rView.frame = CGRectMake(20,ypos,650,50);
            [GeneratePDF addSubview:rView];
            rView = nil;
            ypos+=100;
        }
    }
    if (ypos <= 590)
    {
        UILabel *pgNumber = [[UILabel alloc]initWithFrame:CGRectMake(700, 590, 80,20)];
        pgNumber.text = [NSString stringWithFormat:@"Page %d",[allViews count]+1];
        [GeneratePDF addSubview:pgNumber];
        pgNumber = nil;
        [allViews addObject:GeneratePDF];
        GeneratePDF = nil;
    }
    else
    {
        [allViews addObject:GeneratePDF];
        GeneratePDF = nil;
    }
    [rowwise removeAllObjects];
}
-(void)generatePdfView
{
    viewTags+=1;
    UIView *pdfView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 792, 612)];
    pdfView.tag = viewTags;
    GeneratePDF = pdfView;
    pdfView = nil;
}

-(UIView *)tableHeaderView
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ALTableHeader" owner:nil options:nil];
    ALTableHeader *hView  = [nib objectAtIndex:0];
    nib = nil;
    hView.frame=CGRectMake(20,ypos,650,168);
    return hView;
    hView = nil;
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
    int numberofPages;
    
    NSString *docDirectory =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pdfPath = [docDirectory stringByAppendingPathComponent:aFilename];
    docDirectory = nil;
    
    // set the size of the page (the page is in landscape format)
    CGRect pageBounds = CGRectMake(0.0f, 0.0f, 792.0f, 612.0f);
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
    allViews = nil;
    UIGraphicsEndPDFContext();
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"Reports Record4 from the date %@ to %@",[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]]];
        
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
			errorStr = @"Mail failed: the email message was not saved or queued, possibly due to an error";
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
- (void)viewDidUnload {
    [self setTLHeaderView:nil];
    [super viewDidUnload];
}
@end
