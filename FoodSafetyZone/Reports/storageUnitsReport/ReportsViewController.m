//
//  ReportsViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 19/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ReportsViewController.h"
#import "ReportsListViewController.h"
#import "TimeLogReportListViewController.h"
#import "ApprovedSupplierReportListViewController.h"
#import "GoodsReceivedReportListViewController.h"
#import "ECListViewController.h"
#import "CSReportListViewController.h"
#import "ALReportListViewController.h"

@interface ReportsViewController ()
{
    int tftag;
    NSArray *recordList;
}

@end

@implementation ReportsViewController
@synthesize fromDateField,toDateField,selectRecordField;

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
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"new-main-menu-button.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    back = nil;
    self.navigationItem.leftBarButtonItem = backButton;
    backButton = nil;
    self.navigationItem.title = @"REPORTS";
    [self loadDataForPage];
}
-(void)backClicked
{
    [self clearMemory];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self clearMemory];
    fromDateField.text = @"";
    toDateField.text = @"";
    selectRecordField.text = @"";
}
-(void)clearMemory
{
    picker= nil;
    datePicker = nil;
    actionSheet = nil;
    recordList = nil;
    FormatDate = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadDataForPage
{
    dbmanager = [DBManager sharedInstance];
    dbmanager.tempArray = [[NSMutableArray alloc]init];
    recordList = [[NSArray alloc]initWithObjects:@"Storage Units",@"Time Logs",@"Approved Suppliers",@"Goods Received",@"Equipment Calibaration",@"Cleaning Schedule",@"ActivityLogs", nil];
    FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setDateFormat:@"yyyy-MM-dd,EEE"];
    NSDate *new = [NSDate date];
    toDateField.text = [NSString stringWithFormat:@"%@",[FormatDate stringFromDate:new]];
        
    NSCalendar *gregCalendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components=[gregCalendar components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:new];
    NSInteger month=[components month];
    [components setMonth:month-3];
    
    
    fromDateField.text = [NSString stringWithFormat:@"%@",[FormatDate stringFromDate:[gregCalendar dateFromComponents:components]]];
    new = nil;
    gregCalendar = nil;
    components = nil;
    FormatDate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //
}

- (void)textFieldDidBeginEditing:(UITextField *)aTextField
{
    if (FormatDate)
    {
        FormatDate = nil;
    }
    
    if (aTextField.tag == 1 || aTextField.tag == 2)
    {
        tftag = aTextField.tag;
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"How many?"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:0];
        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        calendar = nil;
        comps = nil;
        [datePicker setMaximumDate:maxDate];
        maxDate = nil;
        
        FormatDate = [[NSDateFormatter alloc] init];
        [FormatDate setFormatterBehavior:NSDateFormatterBehavior10_4];
        [FormatDate setDateFormat:@"yyyy-MM-dd,EEE"];

        
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolBar.barStyle=UIBarStyleBlackOpaque;
        [toolBar setBackgroundImage:[UIImage imageNamed:@"header-bg-1.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [toolBar sizeToFit];
        
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        done.frame = CGRectMake(0, 0, 50, 40);
        [done addTarget:self action:@selector(DatePickerDoneClick) forControlEvents:UIControlEventTouchUpInside];
        [done setImage:[UIImage imageNamed:@"new-done.png"] forState:UIControlStateNormal];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithCustomView:done];
        done = nil;
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 0, 50, 40);
        [cancel addTarget:self action:@selector(CancelPickerDoneClick) forControlEvents:UIControlEventTouchUpInside];
        [cancel setImage:[UIImage imageNamed:@"cancel-bar-button.png"] forState:UIControlStateNormal];
        UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithCustomView:cancel];
        cancel = nil;
        [barItems addObject:flexSpace];
        flexSpace = nil;
        [barItems addObject:flexSpace1];
        flexSpace1 = nil;
        
        [toolBar setItems:barItems animated:YES];
        barItems = nil;
        [actionSheet addSubview:toolBar];
        toolBar = nil;
        [actionSheet addSubview:datePicker];
        [actionSheet  showInView:self.view];
        [actionSheet setBounds:CGRectMake(0,0,320, 464)];
    }
    else if (aTextField.tag == 3)
    {
        tftag = aTextField.tag;
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"what?"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        
        picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 0, 0)];
        picker.showsSelectionIndicator = YES;
        picker.dataSource = self;
        picker.delegate=self;
        
        
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolBar.barStyle=UIBarStyleBlackOpaque;
        [toolBar setBackgroundImage:[UIImage imageNamed:@"header-bg-1.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [toolBar sizeToFit];
        
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        done.frame = CGRectMake(0, 0, 50, 40);
        [done addTarget:self action:@selector(DatePickerDoneClick) forControlEvents:UIControlEventTouchUpInside];
        [done setImage:[UIImage imageNamed:@"new-done.png"] forState:UIControlStateNormal];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithCustomView:done];
        done = nil;
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 0, 50, 40);
        [cancel addTarget:self action:@selector(CancelPickerDoneClick) forControlEvents:UIControlEventTouchUpInside];
        [cancel setImage:[UIImage imageNamed:@"cancel-bar-button.png"] forState:UIControlStateNormal];
        UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithCustomView:cancel];
        cancel = nil;
        [barItems addObject:flexSpace];
        flexSpace = nil;
        [barItems addObject:flexSpace1];
        flexSpace1 = nil;
        
        [toolBar setItems:barItems animated:YES];
        barItems = nil;
        [actionSheet addSubview:toolBar];
        toolBar = nil;
        [actionSheet addSubview:picker];
        [actionSheet  showInView:self.view];
        [actionSheet setBounds:CGRectMake(0,0,320, 464)];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [recordList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [recordList objectAtIndex:row];
    
}

-(void)dateChanged
{
    FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setDateFormat:@"yyyy-MM-dd,EEE"];
}

-(void)DatePickerDoneClick
{
    if (tftag == 1)
    {
        fromDateField.text = [FormatDate stringFromDate:[datePicker date]];
        [fromDateField resignFirstResponder];
    }
    else if (tftag ==2)
    {
        toDateField.text = [FormatDate stringFromDate:[datePicker date]];
        [toDateField resignFirstResponder];
        
    }
    else if(tftag == 3)
    {
        selectRecordField.text = [NSString stringWithFormat:@"%@",[recordList objectAtIndex:[picker selectedRowInComponent:0]]];
        [selectRecordField resignFirstResponder];
    }
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    actionSheet = nil;
    if ((tftag == 1)||(tftag == 2))
    {
        datePicker = nil;
    }
    if (tftag == 3)
    {
        picker = nil;
    }
}

-(void)CancelPickerDoneClick
{
    [fromDateField resignFirstResponder];
    [toDateField resignFirstResponder];
    [selectRecordField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    actionSheet = nil;
    if ((tftag == 1)||(tftag == 2))
    {
        datePicker = nil;
    }
    if (tftag == 3)
    {
        picker = nil;
    }
}

- (IBAction)processClicked:(id)sender
{
    NSString *validations = [[NSString alloc]init];
    if ([fromDateField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"From date cannot be empty!"];
    }
    if ([toDateField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n To date cannot be empty!"];
    }
    if ([selectRecordField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n Records cannot be empty!"];
    }
    if ([validations length]>0)
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:validations delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        validations = nil;
        sucess = nil;
    }
    else
    {
        if (dbmanager.tempArray)
        {
            [dbmanager.tempArray removeAllObjects];
        }
        [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",fromDateField.text]];
        [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",toDateField.text]];
        
        if ([selectRecordField.text isEqualToString:@"Storage Units"])
        {
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            {    // The iOS device = iPhone or iPod Touch
                CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
                [self clearMemory];
                if (iOSDeviceScreenSize.height == 480)
                {
                    ReportsListViewController *reportsList = [[ReportsListViewController alloc]initWithNibName:@"ReportsListViewController" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
                if (iOSDeviceScreenSize.height > 480)
                {
                    ReportsListViewController *reportsList = [[ReportsListViewController alloc]initWithNibName:@"ReportsListViewController5" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
            }
        }
        if ([selectRecordField.text isEqualToString:@"Time Logs"])
        {
            if (dbmanager.tempArray)
            {
                [dbmanager.tempArray removeAllObjects];
            }
            
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",fromDateField.text]];
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",toDateField.text]];
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            {    // The iOS device = iPhone or iPod Touch
                CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
                [self clearMemory];
                if (iOSDeviceScreenSize.height == 480)
                {
                    TimeLogReportListViewController *reportsList = [[TimeLogReportListViewController alloc]initWithNibName:@"TimeLogReportListViewController" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
                if (iOSDeviceScreenSize.height > 480)
                {
                    TimeLogReportListViewController *reportsList = [[TimeLogReportListViewController alloc]initWithNibName:@"TimeLogReportListViewController5" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
            }
        }
        if ([selectRecordField.text isEqualToString:@"Approved Suppliers"])
        {
            if (dbmanager.tempArray)
            {
                [dbmanager.tempArray removeAllObjects];
            }
            
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",fromDateField.text]];
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",toDateField.text]];
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            {    // The iOS device = iPhone or iPod Touch
                CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
                [self clearMemory];
                if (iOSDeviceScreenSize.height == 480)
                {
                    ApprovedSupplierReportListViewController *reportsList = [[ApprovedSupplierReportListViewController alloc]initWithNibName:@"ApprovedSupplierReportListViewController" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
                if (iOSDeviceScreenSize.height > 480)
                {
                    ApprovedSupplierReportListViewController *reportsList = [[ApprovedSupplierReportListViewController alloc]initWithNibName:@"ApprovedSupplierReportListViewController5" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
            }
        }
        if ([selectRecordField.text isEqualToString:@"Goods Received"])
        {
            if (dbmanager.tempArray)
            {
                [dbmanager.tempArray removeAllObjects];
            }
            
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",fromDateField.text]];
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",toDateField.text]];
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            {    // The iOS device = iPhone or iPod Touch
                CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
                [self clearMemory];
                if (iOSDeviceScreenSize.height == 480)
                {
                    GoodsReceivedReportListViewController *reportsList = [[GoodsReceivedReportListViewController alloc]initWithNibName:@"GoodsReceivedReportListViewController" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
                if (iOSDeviceScreenSize.height > 480)
                {
                    GoodsReceivedReportListViewController *reportsList = [[GoodsReceivedReportListViewController alloc]initWithNibName:@"GoodsReceivedReportListViewController5" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
            }
        }
        if ([selectRecordField.text isEqualToString:@"Equipment Calibaration"])
        {
            if (dbmanager.tempArray)
            {
                [dbmanager.tempArray removeAllObjects];
            }
            
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",fromDateField.text]];
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",toDateField.text]];
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            {    // The iOS device = iPhone or iPod Touch
                CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
                [self clearMemory];
                if (iOSDeviceScreenSize.height == 480)
                {
                    ECListViewController *reportsList = [[ECListViewController alloc]initWithNibName:@"ECListViewController" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
                if (iOSDeviceScreenSize.height > 480)
                {
                    ECListViewController *reportsList = [[ECListViewController alloc]initWithNibName:@"ECListViewController5" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
            }
        }
        if ([selectRecordField.text isEqualToString:@"Cleaning Schedule"])
        {
            if (dbmanager.tempArray)
            {
                [dbmanager.tempArray removeAllObjects];
            }
            
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",fromDateField.text]];
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",toDateField.text]];
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            {    // The iOS device = iPhone or iPod Touch
                CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
                [self clearMemory];
                if (iOSDeviceScreenSize.height == 480)
                {
                    CSReportListViewController *reportsList = [[CSReportListViewController alloc]initWithNibName:@"CSReportListViewController" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
                if (iOSDeviceScreenSize.height > 480)
                {
                    CSReportListViewController *reportsList = [[CSReportListViewController alloc]initWithNibName:@"CSReportListViewController5" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
            }
        }
        if ([selectRecordField.text isEqualToString:@"ActivityLogs"])
        {
            if (dbmanager.tempArray)
            {
                [dbmanager.tempArray removeAllObjects];
            }
            
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",fromDateField.text]];
            [dbmanager.tempArray addObject:[NSString stringWithFormat:@"%@",toDateField.text]];
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            {    // The iOS device = iPhone or iPod Touch
                CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
                [self clearMemory];
                if (iOSDeviceScreenSize.height == 480)
                {
                    ALReportListViewController *reportsList = [[ALReportListViewController alloc]initWithNibName:@"ALReportListViewController" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
                if (iOSDeviceScreenSize.height > 480)
                {
                    ALReportListViewController *reportsList = [[ALReportListViewController alloc]initWithNibName:@"ALReportListViewController5" bundle:nil];
                    [self.navigationController pushViewController:reportsList animated:YES];
                }
            }
        }
    }
}
@end
