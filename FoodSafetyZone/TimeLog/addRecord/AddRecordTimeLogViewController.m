//
//  AddRecordTimeLogViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 22/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "AddRecordTimeLogViewController.h"

@interface AddRecordTimeLogViewController ()
{
    int tftag,sec,min,hrs,startSwitch,viewStatus;
}

@end

@implementation AddRecordTimeLogViewController
@synthesize mainScroll,foodNameField,foodTempField,activityField,timerLbl,foodItemImage,startBtn,timerAlertTimeValue,timerAlertView,overlayView,activityButton,actionTakenButton,actionTakenTextField;

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
    self.navigationItem.title = @"";
    [self loadDataForPage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainScroll.contentSize = self.view.frame.size;
    ActivityNames = [[NSMutableArray alloc]init];
    foodTemps = [[NSMutableArray alloc]init];
    startTime = [[NSString alloc]init];
    stopTime = [[NSString alloc]init];
    actionTakenArray = [[NSMutableArray alloc]initWithObjects:@"Used in",@"Eaten / Served",@"Disposed", nil];
    dbmanager = [DBManager sharedInstance];
    startSwitch = 0;
    viewStatus = 0;
    hrsStatus = 0;
    min = 0;
    sec = 0;
    hrs = 0;
    //[self loadDataForPage];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadDataForPage
{
    stopWatch = [[NSTimer alloc]init];
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM FoodItem WHERE foodName = ?",dbmanager.tempStorageValues];
    while([dbmanager.fmResults next])
    {
        [foodNameField setText:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"foodName"]]];
        if ([dbmanager.fmResults stringForColumn:@"purposeName"])
        {
            [activityField setText:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"purposeName"]]];
        }
        [foodTempField setText:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"foodTemp"]]];
        NSData *tempData = [dbmanager.fmResults dataForColumn:@"foodImage"];
        [foodItemImage setImage:[UIImage imageWithData:tempData]];
        selectedFoodID = [NSString stringWithFormat:@"%d",[dbmanager.fmResults intForColumn:@"id"]];
        receivedStatus = [dbmanager.fmResults intForColumn:@"startStatus"];
        receivedStartTime = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"startTime"]];
        
        NSLog(@"Received date from DB %@",receivedStartTime);
    }
    if (ActivityNames)
    {
        [ActivityNames removeAllObjects];
    }
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM Purpose"];
    while([dbmanager.fmResults next])
    {
        [ActivityNames addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"purposeName"]]];
        selectedActivityID = [NSString stringWithFormat:@"%d",[dbmanager.fmResults intForColumn:@"id"]];
    }
    
    if (receivedStatus == 1)
    {
        startSwitch = 1;
        NSDate *endD = [NSDate date];
        
        NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
        [dateF setDateFormat:@"MM-dd-yyyy hh:mm:ss a"];
        NSString *endDate = [dateF stringFromDate:endD];
        dateF = nil;
        endD = nil;
        
        NSArray *splitStartTime = [endDate componentsSeparatedByString:@" "];
        NSArray *splitEndComponents = [[splitStartTime objectAtIndex:1] componentsSeparatedByString:@":"];
        
        NSLog(@"end time %@",splitStartTime);
        splitStartTime = [receivedStartTime componentsSeparatedByString:@" "];
        NSArray *splitStartComponents = [[splitStartTime objectAtIndex:1] componentsSeparatedByString:@":"];
        
        NSLog(@"start time %@",receivedStartTime);
        
        
        hrs = [[splitEndComponents objectAtIndex:0] intValue] - [[splitStartComponents objectAtIndex:0] intValue];
        min = [[splitEndComponents objectAtIndex:1] intValue] - [[splitStartComponents objectAtIndex:1] intValue];
        sec = [[splitEndComponents objectAtIndex:2] intValue] - [[splitStartComponents objectAtIndex:2] intValue];
        
        if (hrs < 0)
        {
            hrs = 0;
        }
        if (min < 0)
        {
            hrs -= 1;
            min = 60 + min;
        }
        if (sec < 0)
        {
            min -= 1;
            sec = 60 + sec;
        }
        
        if ((min > 2)||(min > 4))
        {
            hrsStatus = 0;
            [self startTheAlert];
        }
        
        stopWatch = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        [startBtn setTitle:@"Stop" forState:UIControlStateNormal];
        endDate = nil;
        splitEndComponents = nil;
        splitStartTime = nil;
    }
    else
    {
        startSwitch = 0;
        [startBtn setBackgroundImage:[UIImage imageNamed:@"start_button.png"] forState:UIControlStateNormal];
        [startBtn setTitle:@"Start" forState:UIControlStateNormal];
    }
}

-(void)startTheAlert
{
    if (viewStatus == 0)
    {
        overlayView.frame = CGRectMake(0, 0, 320, 600);
        [self.view addSubview:overlayView];
        if ([overlayView.subviews count]==0)
        {
            timerAlertView.frame = CGRectMake(20, self.view.center.y - 125, 285, 210);
            timerAlertView.layer.cornerRadius = 5.0;
            [self.view addSubview:timerAlertView];
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        [self openingAnimation];
    }
}


-(void)closingAnimationAlert
{
    if (timerAlertView)
    {
        [timerAlertView removeFromSuperview];
        if (overlayView)
        {
            [overlayView removeFromSuperview];
        }
    }
    [actionTakenTextField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationController.navigationBarHidden = NO;
    viewStatus = 0;
    startBtn.enabled = YES;
    activityButton.enabled = YES;
    [UIView commitAnimations];
}

-(void)openingAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationController.navigationBarHidden = YES;
    viewStatus = 1;
    startBtn.enabled = NO;
    activityButton.enabled = NO;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)activityButtonClicked:(UIButton *)sender
{
    tftag = sender.tag;
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [sender bounds];
    inputFieldBounds = [sender convertRect:inputFieldBounds toView:mainScroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y -= 100; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
    
    if ([ActivityNames count]>0)
    {
        [self createPicker];
    }
    else
    {
        UIAlertView *noUnitTypes = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Add Activity in Settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [noUnitTypes show];
        noUnitTypes = nil;
    }
}

-(void)createPicker
{
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"what?"
                                              delegate:self
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 0, 0)];
    picker.showsSelectionIndicator = YES;
    picker.dataSource = self;
    picker.delegate=self;
    picker.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    
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
    [actionSheet addSubview:picker];
    [actionSheet  showInView:self.view];
    [actionSheet setBounds:CGRectMake(0,0,320, 464)];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    if (tftag == 1)
    {
        return [ActivityNames count];
    }
    else
    {
        return [actionTakenArray count];
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (tftag == 1)
    {
        return [ActivityNames objectAtIndex:row];
    }
    else
    {
        return [actionTakenArray objectAtIndex:row];
    }
}

-(void)DatePickerDoneClick
{
    if (tftag == 1)
    {
        activityField.text = [NSString stringWithFormat:@"%@",[ActivityNames objectAtIndex:[picker selectedRowInComponent:0]]];
    }
    if (tftag == 3)
    {
        actionTakenTextField.text = [NSString stringWithFormat:@"%@",[actionTakenArray objectAtIndex:[picker selectedRowInComponent:0]]];
    }
    [actionTakenTextField resignFirstResponder];
    [foodNameField resignFirstResponder];
    [activityField resignFirstResponder];
    [foodTempField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self closingAnimation];
}

-(void)closingAnimation
{
    CGPoint scrollPoint;
    scrollPoint.x = 0;
    scrollPoint.y = 0; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
}

-(void)CancelPickerDoneClick
{
    [actionTakenTextField resignFirstResponder];
    [foodNameField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self closingAnimation];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tftag = textField.tag;
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [textField bounds];
    inputFieldBounds = [textField convertRect:inputFieldBounds toView:mainScroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y -= 100; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
}

- (IBAction)startButtonClicked:(id)sender
{
    NSData *imgData = UIImageJPEGRepresentation(foodItemImage.image, 50);
    if (startSwitch == 0)
    {
        startSwitch = 1;
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM-dd-yyyy hh:mm:ss a"];
        
        NSDate *currentTime = [[NSDate alloc] init];
        
        NSString *dateString = [format stringFromDate:currentTime];
            
        BOOL status = [dbmanager.fmDatabase  executeUpdate:@"UPDATE FoodItem SET foodName = ?, purposeName = ?, foodTemp = ?, foodImage = ?, purposeId = ?,  startTime = ?,startStatus = ? WHERE id = ?", foodNameField.text,activityField.text,foodTempField.text,imgData,[NSNumber numberWithInt:[selectedActivityID integerValue]],[NSString stringWithFormat:@"%@",dateString],[NSNumber numberWithInt:startSwitch],[NSNumber numberWithInt:[selectedFoodID integerValue]]];
        NSLog(@"Data saved %c",status);
        receivedStartTime = dateString;
        
        [startBtn setBackgroundImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        [startBtn setTitle:@"Stop" forState:UIControlStateNormal];
        
        [self setLocalNotification];

        stopWatch = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        
        NSArray *splDate = [dateString componentsSeparatedByString:@" "];
        NSArray *spltime = [[splDate objectAtIndex:0] componentsSeparatedByString:@"-"];
        NSArray *spltt = [[splDate objectAtIndex:1] componentsSeparatedByString:@":"];
        [comps setDay:[[spltime objectAtIndex:1] intValue]];
        [comps setMonth:[[spltime objectAtIndex:0] intValue]];
        [comps setYear:[[spltime objectAtIndex:2] intValue]];
        int mi = [[spltt objectAtIndex:1] intValue];
        mi += 2;
        int hr = [[spltt objectAtIndex:0] intValue];
        if (mi > 60)
        {
            hr += 1;
            mi = 0;
        }
        [comps setMinute:mi];
        [comps setHour:hr];
        [self setLocalNotification:comps];
        splDate = nil;
        spltime = nil;
        spltt = nil;
        comps = nil;
        currentTime = nil;
        dateString = nil;
    }
    else
    {
        startSwitch = 0;
        BOOL status = [dbmanager.fmDatabase  executeUpdate:@"UPDATE FoodItem SET foodName = ?, purposeName = ?, foodTemp = ?, foodImage = ?, purposeId = ?,  startTime = NULL,startStatus = ? WHERE id = ?", foodNameField.text,activityField.text,foodTempField.text,imgData,[NSNumber numberWithInt:[selectedActivityID integerValue]],[NSNumber numberWithInt:startSwitch],[NSNumber numberWithInt:[selectedFoodID integerValue]]];
        
        NSDate *endTime = [NSDate date];
        for (UILocalNotification *cancelLocal in [[UIApplication sharedApplication] scheduledLocalNotifications])
        {
            if ([[cancelLocal.userInfo valueForKey:@"userInfo"] isEqualToString:foodNameField.text])
            {
                int nt = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
                nt -= 1;
                if (nt < 0)
                {
                    nt = 0;
                }
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:nt];
                [[UIApplication sharedApplication] cancelLocalNotification:cancelLocal];
            }
        }
        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        stopTime = [dateFormatter stringFromDate:endTime];
        dateFormatter = nil;
        endTime = nil;
        
        [startBtn setBackgroundImage:[UIImage imageNamed:@"start_button.png"] forState:UIControlStateNormal];
        [startBtn setTitle:@"Start" forState:UIControlStateNormal];
        [stopWatch invalidate];
        hrsStatus = 0;
        [self startTheAlert];
        
    }
}


-(void) setLocalNotification {
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM-dd-yyyy hh:mm:ss a"];
    
    NSDate *currentTime = [[NSDate alloc] init];
    
    NSString *dateString = [format stringFromDate:currentTime];
    format = nil;
    
    NSArray *split = [dateString componentsSeparatedByString:@" "];
    NSArray *splitDate = [[split objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *splitTime = [[split objectAtIndex:1] componentsSeparatedByString:@":"];
    
    [comps setYear:[[splitDate objectAtIndex:2] integerValue]];
    [comps setMonth:[[splitDate objectAtIndex:0] integerValue]];
    [comps setDay:[[splitDate objectAtIndex:1] integerValue]];
    [comps setHour:[[splitTime objectAtIndex:0] integerValue]];
    int minutes = [[splitTime objectAtIndex:1] integerValue];
    [comps setMinute:minutes+2];
     NSLog(@"Minutes %@",comps);
    [comps setTimeZone:[NSTimeZone systemTimeZone]];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *setTime = [cal dateFromComponents:comps];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = setTime;
     NSLog(@"Minutes %@",setTime );
    comps = nil;

    localNotif.timeZone = [NSTimeZone defaultTimeZone];
	
    // Notification details
    localNotif.alertBody = [NSString stringWithFormat:@"%@ is out of safezone for 2 Hrs!!",foodNameField.text];
    // Set the action button
    localNotif.alertAction = @"View";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
	
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    localNotif = nil;
}

-(void)updateTime
{
    sec+=1;
    if (sec>=60)
    {
        min+=1;
        sec = 0;
    }
    if (min>=60)
    {
        hrs+=1;
        min = 0;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    timerLbl.text = [NSString stringWithFormat:@"%d:%d:%d",hrs,min,sec];
    [UIView commitAnimations];
    if ((min == 2)&&(hrsStatus == 0))
    {
        [self startTheAlert];
    }
    if (min == 4)
    {
        hrsStatus = 0;
    }
    if((min == 4)&&(hrsStatus == 0))
    {
        [self startTheAlert];
    }
}

-(void) setLocalNotification:(NSDateComponents *)comp
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *setTime = [cal dateFromComponents:comp];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
    return;
    localNotif.fireDate = setTime;
    localNotif.repeatInterval = NSMinuteCalendarUnit;
    setTime = nil;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = [NSString stringWithFormat:@"%@ is out of safe zone for %d:%d:%d Hours!!!",foodNameField.text,hrs,min,sec];
    localNotif.alertAction = @"View";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    int cnt = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
    cnt += 1;
    localNotif.applicationIconBadgeNumber = cnt;
    NSMutableDictionary *notifications = [[NSMutableDictionary alloc]init];
    [notifications setValue:[NSString stringWithFormat:@"%@",foodNameField.text] forKey:@"userInfo"];
    [notifications setValue:[NSString stringWithFormat:@"%d",cnt] forKey:@"badgeNumber"];
    localNotif.userInfo = notifications;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    notifications = nil;
    cal = nil;
    localNotif = nil;
}

    
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 7)&&(buttonIndex == 1))
    {
        stopWatch = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
    if ((alertView.tag == 10)&&(buttonIndex == 0))
    {
        [self  backClicked];
    }
    if ((alertView.tag == 12)&&(buttonIndex == 0))
    {
        [self deleteData];
    }
}

-(void)doneClicked
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
    [formatDate setDateFormat:@"yyyy-MM-dd,EEE"];
    NSString *todaysDate = [formatDate stringFromDate:today];
    [formatDate setDateFormat:@"hh:mm a"];
    NSString *timeOfAction = [formatDate stringFromDate:today];
    formatDate = nil;
    today = nil;
    NSArray *strtTime = [receivedStartTime componentsSeparatedByString:@" "];
    NSArray *strTime = [[strtTime objectAtIndex:1] componentsSeparatedByString:@":"];
    if ([strTime count]>1)
    {
         receivedStartTime = [NSString stringWithFormat:@"%@:%@ %@",[strTime objectAtIndex:0],[strTime objectAtIndex:1],[strtTime objectAtIndex:2]];
        strTime = nil;
    }
    strtTime = nil;
    
    NSLog(@"Received Start date %@",receivedStartTime);
    BOOL status;
    if ([actionTakenTextField.text length]<=0)
    {
        viewStatus = 0;
        [self startTheAlert];
    }
    else
    {
        status = [dbmanager.fmDatabase  executeUpdate:@"INSERT INTO recordForTimeLogs(id,date,foodName,activityName,startTime,endTime,foodTemp,actionTaken,timeOfAction) VALUES(?,?,?,?,?,?,?,?,?)",NULL,todaysDate,foodNameField.text,activityField.text,receivedStartTime,stopTime,foodTempField.text,actionTakenTextField.text,timeOfAction,nil];
        todaysDate = nil;
        receivedStartTime = nil;
    }
    if (status == YES)
    {
        UIAlertView *timeAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Record Created!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        timeAlert.tag = 10;
        [timeAlert show];
        timeAlert = nil;
    }
}

-(void)backClicked
{
    [stopWatch invalidate];
    mainScroll = nil;
    foodNameField = nil;
    activityField = nil;
    foodTempField = nil;
    timerLbl = nil;
    foodItemImage = nil;
    startBtn = nil;
    actionSheet = nil;
    picker = nil;
    toolBar = nil;
    stopWatch = nil;
    stopTime = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)timerContinueClicked:(id)sender
{
    hrsStatus = 1;
    [self closingAnimationAlert];
    startSwitch = 1;
}

- (IBAction)timerStopClicked:(id)sender
{
    [stopWatch invalidate];
    startSwitch = 1;
    hrsStatus = 1;
    [self startButtonClicked:nil];
    [self closingAnimationAlert];
}
- (IBAction)editClicked:(UIButton *)sender
{
    if (sender.currentImage == [UIImage imageNamed:@"edit-icon.png"])
    {
        dbmanager.tempStorageValues = [NSMutableString stringWithFormat:@"%@",foodNameField.text];
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {    // The iOS device = iPhone or iPod Touch
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            
            if (iOSDeviceScreenSize.height == 480)
            {
                EditTimeLogsViewController *timeLogEdit = [[EditTimeLogsViewController alloc]initWithNibName:@"EditTimeLogsViewController" bundle:nil];
                [self.navigationController pushViewController:timeLogEdit animated:YES];
            }
            if (iOSDeviceScreenSize.height > 480)
            {
                EditTimeLogsViewController *timeLogEdit = [[EditTimeLogsViewController alloc]initWithNibName:@"EditTimeLogsViewController5" bundle:nil];
                [self.navigationController pushViewController:timeLogEdit animated:YES];
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

-(void)deleteData
{
    bool bScuees;
    bScuees =[dbmanager.fmDatabase executeUpdate:@"DELETE FROM FoodItem WHERE foodName = ?",foodNameField.text];
    
    if ([dbmanager.fmDatabase hadError])
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:[dbmanager.fmDatabase lastErrorMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        sucess = nil;
    }
    if (bScuees == YES)
    {
        [self backClicked];
    }
}

- (IBAction)alertCloseClicked:(id)sender
{
    hrsStatus = 1;
    [self closingAnimationAlert];
}
- (IBAction)actionTakenClicked:(UIButton *)sender
{
    tftag = sender.tag;
    [self createPicker];
}
@end
