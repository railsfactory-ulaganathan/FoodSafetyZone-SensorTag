//
//  AddRecordsStorageUnitViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 22/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "AddRecordsStorageUnitViewController.h"
#import "EditStorageUnitsViewController.h"

@interface AddRecordsStorageUnitViewController ()
{
    int tftag,blockViewFlag,helpTextStatus;
}

@end

@implementation AddRecordsStorageUnitViewController
@synthesize storageUnitNamefield,unitTypeField,tempRangeField,storageUnitImage,tempField;
@synthesize correctiveActionLabel,correctiveActionImageView,correctiveActionTextView;
@synthesize Scroll,mainView,infoButton,helpText,helpView,helpInfo;
@synthesize tempAlert;
@synthesize dateField,timeField;
@synthesize dateBack,dateLbl,timeBack,timeLbl;

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
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 50, 40);
    [doneButton setImage:[UIImage imageNamed:@"new-done.png"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 40);
    [back setImage:[UIImage imageNamed:@"new-back-button.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [self loadDataForView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    iCelsius = [iCelsiusAPI sharedManager];
    iCelsius.dataConsumer = (DataProtocol*)self;
    [iCelsius setSamplingPeriod:2.0];
    blockViewFlag = 0;
    confirmDelete = 0;
    Scroll.contentSize = CGSizeMake(320, mainView.frame.size.height - 100);
    [Scroll addSubview:mainView];
    dbmanager = [DBManager sharedInstance];
}

-(void)moveDateAndTime
{
    if (tempAlert.hidden == YES)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.25];
        dateField.frame = CGRectMake(dateField.frame.origin.x, dateField.frame.origin.y - 50, dateField.frame.size.width, dateField.frame.size.height);
        dateLbl.frame = CGRectMake(dateLbl.frame.origin.x, dateLbl.frame.origin.y - 50, dateLbl.frame.size.width, dateLbl.frame.size.height);
        dateBack.frame = CGRectMake(dateBack.frame.origin.x, dateBack.frame.origin.y - 50, dateBack.frame.size.width, dateBack.frame.size.height);
        timeLbl.frame = CGRectMake(timeLbl.frame.origin.x, timeLbl.frame.origin.y - 50, timeLbl.frame.size.width, timeLbl.frame.size.height);
        timeField.frame = CGRectMake(timeField.frame.origin.x, timeField.frame.origin.y - 50, timeField.frame.size.width, timeField.frame.size.height);
        timeBack.frame = CGRectMake(timeBack.frame.origin.x, timeBack.frame.origin.y - 50, timeBack.frame.size.width, timeBack.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)loadDataForView
{
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM AddStorageUnits WHERE StorageUnitName = ?",[dbmanager.tempArray objectAtIndex:0]];
    while([dbmanager.fmResults next])
    {
        
        storageUnitNamefield.text = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"StorageUnitName"]];
        unitTypeField.text = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"UnitType"]];
        tempRangeField.text = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"tempRange"]];
        storageUnitImage.image = [UIImage imageWithData:[dbmanager.fmResults dataForColumn:@"storageUnitImage"]];
        tempAlert.text = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"alertMessage"]];
    }
    NSLog(@"%@",[dbmanager.tempArray objectAtIndex:1]);
    if ([[dbmanager.tempArray objectAtIndex:1] isEqualToString:@"longPress"])
    {
        tempField.text = [dbmanager.tempArray objectAtIndex:2];
        [self DoneNumberPad];
        tempRangeStatus = @"OUT";
        [self confirmClicked];
    }
    [self confirmClicked];

    FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setDateFormat:@"yyyy-MM-dd,EEE"];
    NSDate *new = [NSDate date];
    dateField.text = [NSString stringWithFormat:@"%@",[FormatDate stringFromDate:new]];
    [FormatDate setDateFormat:@"hh:mm a"];
    timeField.text = [NSString stringWithFormat:@"%@",[FormatDate stringFromDate:new]];
    FormatDate = nil;
    new = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint scrollPoint;
    CGRect inputFieldBounds;
    for (UIView *vi in [mainView subviews])
    {
        if(vi == helpText)
        {
            helpTextStatus = 1;
        }
        else
        {
            helpTextStatus = 0;
        }
    }
    if (helpTextStatus == 1)
    {
        inputFieldBounds = CGRectMake(textField.bounds.origin.x, textField.bounds.origin.y + 150, textField.bounds.size.width, textField.bounds.size.height);
    }
    else
    {
        inputFieldBounds = [textField bounds];
    }
    inputFieldBounds = [textField convertRect:inputFieldBounds toView:Scroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y -= 100; // you can customize this value
    [Scroll setContentOffset:scrollPoint animated:YES];
    
    tftag = textField.tag;
    if (textField.tag == 1)
    {
        
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barStyle = UIBarStyleBlackTranslucent;
        [numberToolbar setBackgroundImage:[UIImage imageNamed:@"header-bg-1.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        done.frame = CGRectMake(0, 0, 50, 40);
        [done addTarget:self action:@selector(DoneNumberPad) forControlEvents:UIControlEventTouchUpInside];
        [done setImage:[UIImage imageNamed:@"new-done.png"] forState:UIControlStateNormal];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithCustomView:done];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 0, 50, 40);
        [cancel addTarget:self action:@selector(CancelNumberPad) forControlEvents:UIControlEventTouchUpInside];
        [cancel setImage:[UIImage imageNamed:@"cancel-bar-button.png"] forState:UIControlStateNormal];
        UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithCustomView:cancel];
        [barItems addObject:flexSpace];
        [barItems addObject:flexSpace1];
        
        [numberToolbar setItems:barItems animated:YES];
        
        [numberToolbar sizeToFit];
        textField.inputAccessoryView = numberToolbar;
    }
    if (textField.tag == 11 || textField.tag == 13)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"How many?"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        actionSheet.tag = 1;

        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:0];
        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [datePicker setMaximumDate:maxDate];
        
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
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 0, 50, 40);
        [cancel addTarget:self action:@selector(CancelPickerDoneClick) forControlEvents:UIControlEventTouchUpInside];
        [cancel setImage:[UIImage imageNamed:@"cancel-bar-button.png"] forState:UIControlStateNormal];
        UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithCustomView:cancel];
        [barItems addObject:flexSpace];
        [barItems addObject:flexSpace1];
        
        [toolBar setItems:barItems animated:YES];
        [actionSheet addSubview:toolBar];
        [actionSheet addSubview:datePicker];
        [actionSheet  showInView:self.view];
        [actionSheet setBounds:CGRectMake(0,0,320, 464)];
    }
    if (textField.tag == 12 || textField.tag == 14)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"How many?"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        actionSheet.tag = 1;
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
        datePicker.datePickerMode = UIDatePickerModeTime;
        [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        
                
        FormatDate = [[NSDateFormatter alloc] init];
        [FormatDate setFormatterBehavior:NSDateFormatterBehavior10_4];
        [FormatDate setDateFormat:@"hh:mm a"];
        
        
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
        [barItems addObject:flexSpace1];
        flexSpace = nil;
        flexSpace1 = nil;
        
        [toolBar setItems:barItems animated:YES];
        barItems = nil;
        [actionSheet addSubview:toolBar];
        toolBar = nil;
        [actionSheet addSubview:datePicker];
        [actionSheet  showInView:self.view];
        [actionSheet setBounds:CGRectMake(0,0,320, 464)];
    }
}

-(void)dateChanged
{
    if (tftag == 11 || tftag == 13)
    {
        FormatDate = [[NSDateFormatter alloc] init];
        [FormatDate setDateFormat:@"yyyy-MM-dd,EEE"];
    }
    else if (tftag == 12 || tftag == 14)
    {
        FormatDate = [[NSDateFormatter alloc] init];
        [FormatDate setDateFormat:@"hh:mm a"];
    }
}

-(void)DatePickerDoneClick
{
    if (tftag == 11)
    {
        dateField.text = [FormatDate stringFromDate:[datePicker date]];
        [dateField resignFirstResponder];
    }
    else if (tftag == 12)
    {
        timeField.text = [FormatDate stringFromDate:[datePicker date]];
        [timeField resignFirstResponder];
        
    }
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    if (datePicker)
    {
        [datePicker removeFromSuperview];
        [toolBar removeFromSuperview];
    }
}


-(void)CancelPickerDoneClick
{
    [dateField resignFirstResponder];
    [timeField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


-(void)DoneNumberPad
{
    NSArray *temp = [tempRangeField.text componentsSeparatedByString:@"to"];
        if ([tempField.text length]>0)
    {
        FormatDate = [[NSDateFormatter alloc] init];
        [FormatDate setDateFormat:@"yyyy-MM-dd,EEE"];
        NSDate *new = [NSDate date];
        dateField.text = [NSString stringWithFormat:@"%@",[FormatDate stringFromDate:new]];
        [FormatDate setDateFormat:@"hh:mm a"];
        timeField.text = [NSString stringWithFormat:@"%@",[FormatDate stringFromDate:new]];
        if (([tempField.text floatValue] >= [[temp objectAtIndex:0] floatValue])&&([tempField.text floatValue] <= [[temp objectAtIndex:1]floatValue]))
        {
            tempRangeStatus = [NSString stringWithFormat:@"IN"];
        }
        else
        {
            tempRangeStatus = [NSString stringWithFormat:@"OUT"];
        }
        [self confirmClicked];
    }
    [tempField resignFirstResponder];
}
-(void)CancelNumberPad
{
    [tempField resignFirstResponder];
}

- (IBAction)scanButtonClicked:(id)sender
{
    if (iCelsius.isConnected == NO)
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"iCelcius device is not connected!!Or Not connected properly!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        sucess = nil;
    }
    else
    {
        [self performSelector:@selector(stopConsuming) withObject:nil afterDelay:2.5];
    }
}

- (void)confirmClicked
{
    if ([tempRangeStatus isEqualToString:@"IN"])
    {
        correctiveActionLabel.hidden = YES;
        correctiveActionImageView.hidden = YES;
        correctiveActionTextView.hidden = YES;
        infoButton.hidden = YES;
        tempAlert.hidden = YES;
        Scroll.contentSize = CGSizeMake(320, mainView.frame.size.height - 100);
    }
    else
    {
        correctiveActionLabel.hidden = NO;
        correctiveActionImageView.hidden = NO;
        correctiveActionTextView.hidden = NO;
        infoButton.hidden = NO;
        tempAlert.hidden = NO;
        Scroll.contentSize = CGSizeMake(320, mainView.frame.size.height);
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self backClicked];
    }
    if ((alertView.tag == 12)&&(buttonIndex == 0))
    {
        [self deleteData];
    }
}

-(void)backClicked
{
    datePicker = nil;
    toolBar = nil;
    FormatDate = nil;
    actionSheet = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneClicked
{
    
        NSString *currentDate = [NSString stringWithFormat:@"%@",[NSDate date]];
        NSString *validations = [[NSString alloc]init];
    
        if ([tempField.text length]<=0)
        {
            validations = [validations stringByAppendingFormat:@"Temperature cannot be empty!"];
        }
        if ([dateField.text length]<=0)
        {
            validations = [validations stringByAppendingFormat:@"\n Date cannot be empty!"];
        }
        if ([timeField.text length]<=0)
        {
            validations = [validations stringByAppendingFormat:@"\n Time cannot be empty!"];
        }
        if (correctiveActionTextView.hidden == NO)
        {
            if ([correctiveActionTextView.text length] <= 0)
            {
                validations = [validations stringByAppendingFormat:@"\n Corrective Action cannot be empty!"];
            }
        }
    
        if ([validations length]>0)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:validations delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [sucess show];
            sucess = nil;
            validations = nil;
        }
        else
        {
            BOOL status;
            NSString *check;
                if([correctiveActionTextView.text length]==0)
                {
                    check = [NSString stringWithFormat:@""];
                }
                else
                {
                    check = [NSString stringWithFormat:@"%@",correctiveActionTextView.text];
                }
            status = [dbmanager.fmDatabase  executeUpdate:@"INSERT INTO recordsForStorageUnit(storageUnitName,timeField,temperature,tempRangeStatus,dateField,lastUpdated,correctiveAction,id) VALUES(?,?,?,?,?,?,?,NULL)",storageUnitNamefield.text,timeField.text,[NSNumber numberWithFloat:[tempField.text floatValue]],tempRangeStatus,dateField.text,currentDate,check,nil];
                          
            if (status == YES)
            {
                UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Record created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                sucess.tag = 1;
                [sucess show];
                sucess = nil;
                check = nil;
                iCelsius = nil;
            }
            else
            {
                
                if ([dbmanager.fmDatabase hadError]) {
                    UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Err %d: %@", [dbmanager.fmDatabase lastErrorCode], [dbmanager.fmDatabase lastErrorMessage]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    sucess.tag = 1;
                    [sucess show];
                    sucess = nil;
                }
            }
            NSLog(@"%c ",status);
        }
    [self DoneNumberPad];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [Scroll  setContentOffset:Scroll.bounds.origin animated:YES];
        return NO;
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [Scroll  setContentOffset:Scroll.bounds.origin animated:YES];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [textView bounds];
    inputFieldBounds = [textView convertRect:inputFieldBounds toView:Scroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y -= 100; // you can customize this value
    [Scroll setContentOffset:scrollPoint animated:YES];
}



- (IBAction)infoClicked:(id)sender
{
    helpText.frame = CGRectMake(infoButton.frame.origin.x - 20,infoButton.frame.origin.y - 150, 300, 150);
    helpText.alpha = 0;
    [UIView beginAnimations:@"showHelpText" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    helpText.alpha = 1.0;
    [UIView commitAnimations];
    
    [mainView addSubview:helpText];
}

- (IBAction)removeHelpText:(id)sender
{
    if (helpText)
    {
        [helpText removeFromSuperview];
    }
    if (helpView)
    {
        [helpView removeFromSuperview];
    }
}
- (IBAction)helpInfoClicked:(id)sender
{
    helpView.frame = CGRectMake(10,helpInfo.frame.origin.y + 20, 300, 150);
    helpView.alpha = 0;
    [UIView beginAnimations:@"showHelpView" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    helpView.alpha = 1.0;
    [UIView commitAnimations];
    
    [mainView addSubview:helpView];
}
- (IBAction)editClicked:(UIButton *)sender
{
    if (sender.currentImage == [UIImage imageNamed:@"edit-icon.png"])
    {
            dbmanager.tempStorageValues = [NSMutableString stringWithFormat:@"%@",storageUnitNamefield.text];
               if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {    // The iOS device = iPhone or iPod Touch
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            
            if (iOSDeviceScreenSize.height == 480)
            {
                EditStorageUnitsViewController *storageUnitEdit = [[EditStorageUnitsViewController alloc]initWithNibName:@"EditStorageUnitsViewController" bundle:nil];
                [self.navigationController pushViewController:storageUnitEdit animated:YES];
            }
            if (iOSDeviceScreenSize.height > 480)
            {
                EditStorageUnitsViewController *storageUnitEdit = [[EditStorageUnitsViewController alloc]initWithNibName:@"EditStorageUnitsViewController" bundle:nil];
                [self.navigationController pushViewController:storageUnitEdit animated:YES];
            }
        }
    }
    else if (sender.currentImage == [UIImage imageNamed:@"delete-icon.png"])
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"This will delete the Storage Unit! \nAre you sure you want to delete this Storage Unit ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        sucess.tag = 12;
        [sucess show];
        sucess = nil;
    }
}

- (IBAction)alertTextDisplay:(id)sender
{
    if ([tempAlert.text length]>0)
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert Message" message:tempAlert.text delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        sucess = nil;
    }
}

-(void)deleteData
{
    bool bScuees;
    bScuees =[dbmanager.fmDatabase executeUpdate:@"DELETE FROM AddStorageUnits WHERE StorageUnitName = ?",storageUnitNamefield.text];
    
    if ([dbmanager.fmDatabase hadError])
    {
        NSLog(@"%@",[dbmanager.fmDatabase lastErrorMessage]);
        NSString *alertValue;
        if ([dbmanager.fmDatabase lastErrorCode]==19)
        {
            alertValue = [NSString stringWithFormat:@"Storage Unit Name already taken!"];
        }
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:alertValue delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        sucess.tag = 1;
        [sucess show];
        confirmDelete = 0;
    }
    if (bScuees == YES)
    {
        [self backClicked];
    }
}
#pragma iCelsius API implementation
- (void)consumeData:(Data*)data
{
    NSLog(@"Data from the device %@",data);
    data.timestamp = 2.0;
    if (data)
    {
        self.tempField.text = [NSString stringWithFormat:@"%f",[data.m1 floatValue]];
    }
    else
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Connect the device properly!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        sucess = nil;
    }
}
- (void)stopConsuming
{
    self.tempField.text = @"-";
}
- (void)setProduct:(ProductProtocol*)product
{
    
}
- (void)processError:(NSString*)errorMessage withTitle:(NSString*)errorTitle
{
    UIAlertView* alertWithOkButton = [[UIAlertView alloc] initWithTitle:errorTitle                                                                                                                    message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertWithOkButton show];
    alertWithOkButton = nil;
}
@end
