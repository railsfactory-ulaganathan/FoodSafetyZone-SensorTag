//
//  GRAddRecordViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 09/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "GRAddRecordViewController.h"
#import "deviceSelector.h"

@interface GRAddRecordViewController ()
{
    int tftag;
    NSString *foodITEM;
    NSString *foodCategory;
    NSString *supplierName;
    float minTemp,maxTemp;
}

@end

@implementation GRAddRecordViewController
@synthesize foodItemName,foodItemImage,expDateField,backView,mainScroll,bestBeforeField,acceptSwitch,option1,option2,tempField,correctiveAction,correctiveBack,correctiveLbl,alertLbl,alertValueLbl;
@synthesize d,p,manager,setupData,sensorsEnabled;

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
    back = nil;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.title = @"GOODS RECEIVED";
    leftBarButton = nil;
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search.png"]forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [acceptSwitch setOnImage:[UIImage imageNamed:@"accept.png"]];
    [acceptSwitch setOffImage:[UIImage imageNamed:@"not_accept.png"]];
    acceptSwitch.tintColor = [UIColor colorWithRed:1/255.0f green:1/255.0f blue:0/255.0f alpha:1.0f];
    acceptSwitch.thumbTintColor = [UIColor whiteColor];
    mainScroll.contentSize = backView.frame.size;
    [mainScroll addSubview:backView];
    tempStorageValues = [[NSMutableString alloc]init];
    dbManager = [DBManager sharedInstance];
    [self loadDataForPage];
}

-(void)loadDataForPage
{
    if (dbManager.d)
    {
        self.d = dbManager.d;
        
        self.sensorsEnabled = [[NSMutableArray alloc] init];
        if (!self.d.p.isConnected) {
            self.d.manager.delegate = self;
            [self.d.manager connectPeripheral:self.d.p options:nil];
        }
        else {
            self.d.p.delegate = self;
            [self configureSensorTag];
            self.navigationItem.title = @"GOODS RECEIVED";
        }
    }

    supplierName = [[NSString alloc]init];
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbManager.fmResults next])
    {
        foodITEM = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"tempArray"]];
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    NSArray *te = [foodITEM componentsSeparatedByString:@","];
    if ([te count]>1)
    {
        foodITEM = [NSString stringWithFormat:@"%@",[te objectAtIndex:1]];
    }
    else
    {
        foodITEM = [NSString stringWithFormat:@"%@",[te objectAtIndex:0]];
    }
    
    te = nil;
    
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM supplierFoodItems WHERE foodItem = ?",foodITEM];
    while([dbManager.fmResults next])
    {
        foodItemName.text = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodItem"]];
        foodCategory = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodCategory"]];
        NSData *tempData = [dbManager.fmResults dataForColumn:@"foodItemImage"];
        foodItemImage.image = [UIImage imageWithData:tempData];
        tempData = nil;
    }
    
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM suppliers WHERE id = ?",[NSNumber numberWithInt:[tempStorageValues integerValue]]];
    while([dbManager.fmResults next])
    {
        supplierName = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"supplierName"]];
    }
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM foodCategory WHERE foodCategoryName = ?",foodCategory];
    while([dbManager.fmResults next])
    {
        minTemp = [dbManager.fmResults doubleForColumn:@"minTemp"];
        maxTemp = [dbManager.fmResults doubleForColumn:@"maxTemp"];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)scanClicked:(id)sender
{
    deviceSelector *dS = [[deviceSelector alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:dS animated:YES];
}

- (IBAction)switchChanged:(UISwitch *)sender
{
    if (sender.on == YES)
    {
        acceptSwitch.tintColor = [UIColor colorWithRed:25/255.0f green:118/255.0f blue:0/255.0f alpha:1.0f];
        [self check];
    }
    else
    {
        acceptSwitch.tintColor = [UIColor colorWithRed:1/255.0f green:1/255.0f blue:0/255.0f alpha:1.0f];
        [self check];
    }
}

-(void)check
{
    if (([tempField.text floatValue] < minTemp)||([tempField.text floatValue] > maxTemp))
    {
        if (acceptSwitch.on == YES)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            correctiveAction.hidden = NO;
            correctiveLbl.hidden = NO;
            correctiveBack.hidden = NO;
            alertLbl.hidden = NO;
            alertValueLbl.hidden = NO;
            [UIView commitAnimations];
        }
        else
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            correctiveAction.hidden = YES;
            correctiveLbl.hidden = YES;
            correctiveBack.hidden = YES;
            alertLbl.hidden = YES;
            alertValueLbl.hidden = YES;
            [UIView commitAnimations];
        }
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        correctiveAction.hidden = YES;
        correctiveLbl.hidden = YES;
        correctiveBack.hidden = YES;
        alertLbl.hidden = YES;
        alertValueLbl.hidden = YES;
        [UIView commitAnimations];
    }
}

-(void)createPicker
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
    
    FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setFormatterBehavior:NSDateFormatterBehavior10_4];
    [FormatDate setDateFormat:@"yyyy-MM-dd,EEE"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [datePicker setMinimumDate:minDate];

    
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

-(void)dateChanged
{
    if (tftag == 11 || tftag == 22)
    {
        [FormatDate setDateFormat:@"yyyy-MM-dd,EEE"];
    }
}

-(void)DatePickerDoneClick
{
    if (tftag == 11)
    {
        expDateField.text = [FormatDate stringFromDate:[datePicker date]];
        [expDateField resignFirstResponder];
    }
    else if (tftag == 22)
    {
        bestBeforeField.text = [FormatDate stringFromDate:[datePicker date]];
        [bestBeforeField resignFirstResponder];
        
    }
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    if (datePicker)
    {
        [datePicker removeFromSuperview];
        [toolBar removeFromSuperview];
        FormatDate = nil;
        actionSheet = nil;
    }
    [self closeAnimation];
}


-(void)CancelPickerDoneClick
{
    [expDateField resignFirstResponder];
    [bestBeforeField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [datePicker removeFromSuperview];
    [toolBar removeFromSuperview];
    [self closeAnimation];
    FormatDate = nil;
    actionSheet = nil;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        CGPoint scrollPoint;
        scrollPoint.x = 0;
        scrollPoint.y = 0; // you can customize this value
        [mainScroll setContentOffset:scrollPoint animated:YES];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [textView bounds];
    inputFieldBounds = [textView convertRect:inputFieldBounds toView:mainScroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y -= 100; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ((textField.tag == 11)||(textField.tag == 22))
    {
        tftag = textField.tag;
        [self createPicker];
    }
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [textField bounds];
    inputFieldBounds = [textField convertRect:inputFieldBounds toView:mainScroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y -= 100; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self closeAnimation];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

-(void)closeAnimation
{
    CGPoint scrollPoint;
    scrollPoint.x = 0;
    scrollPoint.y = 0;// you can customize this value
    [mainScroll  setContentOffset:scrollPoint animated:YES];
}

- (IBAction)optionChanged:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        if (sender.currentImage == [UIImage imageNamed:@"option_selected.png"])
        {
            [option1 setImage:[UIImage imageNamed:@"option_not_selected.png"] forState:UIControlStateNormal];
            [option2 setImage:[UIImage imageNamed:@"option_selected.png"] forState:UIControlStateNormal];
            bestBeforeField.enabled = YES;
            expDateField.enabled = NO;
            expDateField.text = @"";
        }
        else
        {
            [option2 setImage:[UIImage imageNamed:@"option_not_selected.png"] forState:UIControlStateNormal];
            [option1 setImage:[UIImage imageNamed:@"option_selected.png"] forState:UIControlStateNormal];
            bestBeforeField.enabled = NO;
            bestBeforeField.text = @"";
            expDateField.enabled = YES;
        }
    }
    if (sender.tag == 2)
    {
        if (sender.currentImage == [UIImage imageNamed:@"option_selected.png"])
        {
            [option1 setImage:[UIImage imageNamed:@"option_selected.png"] forState:UIControlStateNormal];
            [option2 setImage:[UIImage imageNamed:@"option_not_selected.png"] forState:UIControlStateNormal];
            bestBeforeField.enabled = NO;
            bestBeforeField.text = @"";
            expDateField.enabled = YES;
        }
        else
        {
            [option2 setImage:[UIImage imageNamed:@"option_selected.png"] forState:UIControlStateNormal];
            [option1 setImage:[UIImage imageNamed:@"option_not_selected.png"] forState:UIControlStateNormal];
            bestBeforeField.enabled = YES;
            expDateField.enabled = NO;
            expDateField.text = @"";
        }
    }
}

-(void)clearMemory
{
    FormatDate = nil;
    tempStorageValues = nil;
    datePicker = nil;
    actionSheet = nil;
    toolBar = nil;
    dbManager = nil;
}

-(void)setBackValues
{
    NSLog(@"Supp id %@,Category %@",tempStorageValues,foodCategory);
   BOOL status = [dbManager.fmDatabase  executeUpdate:@"UPDATE temp SET tempStorageValue = ?, tempArray = ? WHERE id = 1",[NSMutableString stringWithFormat:@"%@",tempStorageValues],[NSMutableString stringWithFormat:@"%@",foodCategory]];
}

-(void)backClicked
{
    [self setBackValues];
    [self clearMemory];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneClicked
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd,EEE hh:mm a"];
    NSDate *currentTime = [[NSDate alloc] init];
    NSString *dateString = [format stringFromDate:currentTime];
    NSArray *temp = [dateString componentsSeparatedByString:@" "];
    NSString *currentDate = [temp objectAtIndex:0];
    NSString *currentTme = [NSString stringWithFormat:@"%@ %@",[temp objectAtIndex:1],[temp objectAtIndex:2]];
    
    NSString *dateCode;
    if ([expDateField.text length]>0)
    {
        dateCode = [NSString stringWithFormat:@"%@ (U)",expDateField.text];
    }
    else
    {
        dateCode = [NSString stringWithFormat:@"%@ (B)",bestBeforeField.text];
    }
    
    NSString *acceptStatus;
    if (acceptSwitch.on == YES)
    {
        acceptStatus = @"A";
    }
    else
    {
        acceptStatus = @"R";
    }
    
    NSString *validations = [[NSString alloc]init];
    
    if ([tempField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Temperature cannot be empty!"];
    }
    if (([expDateField.text length]<=0)&&(expDateField.enabled == YES))
    {
        validations = [validations stringByAppendingFormat:@"\n Expiration date cannot be empty!"];
    }
    if (([bestBeforeField.text length]<=0)&&(bestBeforeField.enabled == YES))
    {
        validations = [validations stringByAppendingFormat:@"\n Best before date cannot be empty!"];
    }
    if (correctiveAction.hidden == NO)
    {
        if ([correctiveAction.text length] <= 0)
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
        BOOL status = [dbManager.fmDatabase  executeUpdate:@"INSERT INTO recordForGoodsReceived(id,date,time,supplier,foodType,foodTemp,dateCode,acceptStatus,initials,problems) VALUES(NULL,?,?,?,?,?,?,?,?,?)",currentDate,currentTme,supplierName,foodItemName.text,[NSString stringWithFormat:@"%@",tempField.text],dateCode,acceptStatus,@"",correctiveAction.text,nil];
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Goods Saved!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            sucess.tag = 11;
            [sucess show];
            sucess = nil;
            acceptStatus = nil;
            currentDate = nil;
            currentTime = nil;
            currentTme = nil;
            supplierName = nil;
        }
        else
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:[dbManager.fmDatabase lastErrorMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [sucess show];
            sucess = nil;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11)
    {
        [self backClicked];
    }
}


//SENSOR Tag
-(void) configureSensorTag
{
    // Configure sensortag, turning on Sensors and setting update period for sensors etc ...
    
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"]))
    {
        // Enable Temperature sensor
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature config UUID"]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        
        if ([self sensorEnabled:@"Ambient temperature active"]) [self.sensorsEnabled addObject:@"Ambient temperature"];
        if ([self sensorEnabled:@"IR temperature active"]) [self.sensorsEnabled addObject:@"IR temperature"];
        
    }
}

-(void) deconfigureSensorTag
{
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"]))
    {
        // Enable Temperature sensor
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature config UUID"]];
        unsigned char data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    
}

-(bool)sensorEnabled:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    if (val) {
        if ([val isEqualToString:@"1"]) return TRUE;
    }
    return FALSE;
}

-(int)sensorPeriod:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    return [val integerValue];
}

#pragma mark - CBCentralManager delegate function
-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}


#pragma mark - CBperipheral delegate functions

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"..");
    if ([service.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope service UUID"]]]) {
        [self configureSensorTag];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@".");
    for (CBService *s in peripheral.services) [peripheral discoverCharacteristics:nil forService:s];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@, error = %@",characteristic.UUID, error);
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    //NSLog(@"didUpdateValueForCharacteristic = %@",characteristic.UUID);
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]]]) {
        float tAmb = [sensorTMP006 calcTAmb:characteristic.value];
        float tObj = [sensorTMP006 calcTObj:characteristic.value];
        tempField.text = [NSString stringWithFormat:@"%f",tAmb];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic.UUID,error);
}

//SENSOR TAG

-(void)viewWillDisappear:(BOOL)animated
{
    [self deconfigureSensorTag];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.sensorsEnabled = nil;
    self.d.manager.delegate = nil;
}

@end
