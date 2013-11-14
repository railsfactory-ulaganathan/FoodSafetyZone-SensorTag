//
//  ALAddRecordViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 23/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ALAddRecordViewController.h"
#import "ALEditViewController.h"

@interface ALAddRecordViewController ()
{
    int foodID;
    int activityToFill;
}

@end

@implementation ALAddRecordViewController
@synthesize portionSize,equipmentName,equipmentTemp,startTemp,startTime,endTemp,endTime,totalTime,comments,foodName,CCRView,otherActivityView,mainScroll,backView,foodImage;
@synthesize startTime1,startTemp1,endTemp1,endTime1,totalTime1,comments1;
@synthesize tabScroll,detuctedTemp,CCRStartButt,otherStartButt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setPortionSize:nil];
    [self setEquipmentName:nil];
    [self setEquipmentTemp:nil];
    [self setStartTime:nil];
    [self setStartTemp:nil];
    [self setEndTime:nil];
    [self setEndTemp:nil];
    [self setTotalTime:nil];
    [self setComments:nil];
    [self setFoodName:nil];
    [self setCCRView:nil];
    [self setOtherActivityView:nil];
    [self setBackView:nil];
    [self setMainScroll:nil];
    [self setTabScroll:nil];
    [self setFoodImage:nil];
    [self setStartTime1:nil];
    [self setStartTemp1:nil];
    [self setEndTime1:nil];
    [self setEndTemp1:nil];
    [self setTotalTime1:nil];
    [self setComments1:nil];
    [self setCCRStartButt:nil];
    [self setOtherStartButt:nil];
    [super viewDidUnload];
}


-(void)viewWillAppear:(BOOL)animated
{
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 50, 40);
    [doneButton setImage:[UIImage imageNamed:@"new-done.png"] forState:UIControlStateNormal];
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
    mainScroll.contentSize = backView.bounds.size;
    [mainScroll addSubview:backView];
    iCelsius = [iCelsiusAPI sharedManager];
    iCelsius.dataConsumer = (DataProtocol*)self;
    activityArray = [[NSMutableArray alloc]init];
    tempStr = [[NSMutableString alloc]init];
    tabScroll.contentSize = CGSizeMake(900, 40);
    availableActivities = [[NSMutableArray alloc]init];
    equipmentNames = [[NSMutableArray alloc]init];
    detuctedTemp = [[NSMutableString alloc]init];
    startStatus = 0;
    stStatus = 0;
    sts = 1;
}

-(void)loadDataForPage
{
    if (startStatus == 2)
    {
        otherStartButt.hidden = NO;
        startStatus = 0;
    }
    
    if (stStatus == 2)
    {
        CCRStartButt.hidden = NO;
        stStatus = 0;
    }
    
    if (equipmentNames)
    {
        [equipmentNames removeAllObjects];
    }
    dbManager = [DBManager sharedInstance];
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbManager.fmResults next])
    {
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    int selid;
    if (tempStr)
    {
        tempStr = [NSString stringWithFormat:@""];
    }
    
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM activityLogFoodItem WHERE id = ?",[NSNumber numberWithInt:[tempStorageValues intValue]]];
    while([dbManager.fmResults next])
    {
        
        foodName.text = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodName"]];
        NSData *tempData = [dbManager.fmResults dataForColumn:@"foodImage"];
        [foodImage setImage:[UIImage imageWithData:tempData] forState:UIControlStateNormal];
        tempData = nil;
        tempStr = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"activity"]];
        selid = [dbManager.fmResults intForColumn:@"id"];
        foodID = [dbManager.fmResults intForColumn:@"id"];
    }
    int total;
    idd = 0;
    total = 0;
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM recordForActivityLog WHERE foodId = ?",[NSNumber numberWithInt:[tempStorageValues intValue]]];
    while([dbManager.fmResults next])
    {
        if ([dbManager.fmResults intForColumn:@"id"] > idd)
        {
            idd = [dbManager.fmResults intForColumn:@"id"];
            sts = [dbManager.fmResults intForColumn:@"completeStatus"];
        }
        total += 1;
    }
    if ((sts == 11)||(sts == 1)||(total == 0))
        
    {
        int j = 1;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd,EEE"];
        NSDate *currentTime = [[NSDate alloc] init];
        NSString *dateString = [format stringFromDate:currentTime];
        BOOL status = [dbManager.fmDatabase executeUpdate:@"INSERT INTO recordForActivityLog(id,date,foodId,preparation,cookingFood,coolingFood,reheatingFood,hotHolding,serving,foodPacking,completeStatus,foodName,activity) VALUES(NULL,?,?,NULL,NULL,NULL,NULL,NULL,NULL,NULL,?,?,?)",dateString,[NSString stringWithFormat:@"%d",selid],[NSNumber numberWithInt:j],foodName.text,tempStr,nil];
        sts = 1;
        selectedId = 0;
        format = nil;
        currentTime = nil;
        dateString = nil;
    }
    
    NSArray *aa;
    
    aa = [tempStr componentsSeparatedByString:@"((/"];
    
    tempStr = [NSString stringWithFormat:@""];
    for (int i = 0; i < [aa count]; i++)
    {
        NSLog(@"-->>%@",[aa objectAtIndex:i]);
        tempStr = [NSString stringWithFormat:@"%@%@",tempStr,[aa objectAtIndex:i]];
        
    }
    aa = nil;
    NSArray *bb;
    bb = [tempStr componentsSeparatedByString:@"))"];
    NSString *t = [bb objectAtIndex:([bb count]-1)];
    NSMutableArray *b = [[NSMutableArray alloc]init];
    if ([t length] <= 1)
    {
        
        for (int i = 0; i < ([bb count]-1); i++)
        {
            [b addObject:[bb objectAtIndex:i]];
        }
    }
    NSLog(@"Components %@\\n",bb);
    NSLog(@"Components %@\\n",b);
    bb = nil;
    int xpos,ypos,nou;
    xpos = 0;
    ypos = 0;
    nou = 0;
    int  cooking = 0;
    
    if ([[tabScroll subviews] count] > 0)
    {
        for(UIView *subview in [tabScroll subviews]) {
            [subview removeFromSuperview];
        }
    }
    if (activityArray)
    {
        [activityArray removeAllObjects];
    }
    for (int i = 1; i <= [b count]; i++)
    {
        UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
        temp.frame = CGRectMake(xpos, ypos, 100, 40);
        temp.tag = i*10;
        [temp setTitle:[b objectAtIndex:nou] forState:UIControlStateNormal];
        [temp.titleLabel setFont:[UIFont systemFontOfSize:12]];
        if (i == sts)
        {
            [temp addTarget:self action:@selector(ActivitySelected:) forControlEvents:UIControlEventTouchUpInside];
            [temp setBackgroundImage:[UIImage imageNamed:@"tab_menu_bg.png"] forState:UIControlStateNormal];
            [temp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (([temp.currentTitle isEqualToString:@"Cooking food"])||([temp.currentTitle isEqualToString:@"Cooling food"])||([temp.currentTitle isEqualToString:@"Reheating"]))
            {
                cooking += 1;
            }
        }
        else
        {
            [temp setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [tabScroll addSubview:temp];
        [activityArray addObject:temp];
        temp = nil;
        xpos += 100;
        nou++;
    }
    int wid,hei;
    if ((nou > 2)&&(nou < 6))
    {
        wid = 600;
        hei = 40;
    }
    else if ((nou > 6)&&(nou < 9))
    {
        wid = 900;
        hei = 40;
    }
    else
    {
        wid = 300;
        hei = 40;
    }
    tabScroll.contentSize = CGSizeMake(wid, hei);
    NSLog(@"COUNT ACTIVITY %d",[activityArray count]);
    if (sts == [activityArray count])
    {
        sts = 11;
    }
    else
    {
        sts += 1; 
    }
    
    if (total == 0)
    {
        dbManager.fmResults = [dbManager.fmDatabase executeQuery:@"SELECT * FROM recordForActivityLog"];
        while([dbManager.fmResults next])
        {
            idd = [dbManager.fmResults intForColumn:@"id"];
        }
    }
    else
    {
        dbManager.fmResults = [dbManager.fmDatabase executeQuery:@"SELECT * FROM recordForActivityLog"];
        while([dbManager.fmResults next])
        {
            if ([dbManager.fmResults intForColumn:@"id"]>idd)
            {
                idd = [dbManager.fmResults intForColumn:@"id"];
            } 
        }
    }
    if (cooking > 0)
    {
        if (otherActivityView)
        {
            [otherActivityView removeFromSuperview];
        }
        CCRView.frame = CGRectMake(0, 240, 320, 440);
        [backView addSubview:CCRView];
        dataForActivity = [[NSMutableString alloc]init];
    }
    else
    {
        dataForActivity = [[NSMutableString alloc]init];
        if (CCRView)
        {
            [CCRView removeFromSuperview];
        }
        otherActivityView.frame = CGRectMake(0, 240, 320, 300);
        [backView addSubview:otherActivityView];
    }
    selectedId = idd;
}


-(void)deleteData
{
    bool bScuees;
    bScuees =[dbManager.fmDatabase executeUpdate:@"DELETE FROM activityLogFoodItem WHERE id = ?",[NSNumber numberWithInt:foodID]];
    if (bScuees == YES)
    {
        [self backClicked];
    }
}

-(void)doneClicked
{
    BOOL status = [dbManager.fmDatabase  executeUpdate:@"UPDATE recordForActivityLog SET completeStatus = ? WHERE id = ?",[NSNumber numberWithInt:sts],[NSNumber numberWithInt:idd]];
    if (status == YES)
    {
        NSLog(@"Completed");
    }
    
    NSString *t;
    for (int i = 0; i < [activityArray count]; i++)
    {
        UIButton *temp = [activityArray objectAtIndex:i];
        if (temp.currentBackgroundImage == [UIImage imageNamed:@"tab_menu_bg.png"])
        {
            activityToFill = temp.tag;
            t = [NSString stringWithFormat:@"%@",temp.currentTitle];
        }
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd,EEE"];
    NSDate *currentTime = [[NSDate alloc] init];
    NSString *dateString = [format stringFromDate:currentTime];
    NSString *validations = [[NSString alloc]init];
    if ([t isEqualToString:@"Cooking food"]||[t isEqualToString:@"Cooling food"]||[t isEqualToString:@"Reheating"])
    {
        if ([portionSize.text length]<=0)
        {
            validations = [validations stringByAppendingFormat:@"PortionSize cannot be empty!"];
        }
        if ([equipmentName.text length] <= 0)
        {
            validations = [validations stringByAppendingFormat:@"\n Equipment Name cannot be empty!"];
        }
        if ([equipmentTemp.text length]<=0)
        {
            validations = [validations stringByAppendingFormat:@"Equipment Temp  cannot be empty!"];
        }
        if ([startTime.text length] <= 0)
        {
            validations = [validations stringByAppendingFormat:@"\n Start Time cannot be empty!"];
        }
        if ([endTime.text length] <= 0)
        {
            validations = [validations stringByAppendingFormat:@"\n End Time cannot be empty!"];
        }
        if ([endTemp.text length] <= 0)
        {
            validations = [validations stringByAppendingFormat:@"\n End Temp cannot be empty!"];
        }
        if ([totalTime.text length] <= 0)
        {
            validations = [validations stringByAppendingFormat:@"\n Total Time cannot be empty!"];
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
            dataForActivity =[NSString stringWithFormat:@"((/%@))",portionSize.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,equipmentName.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,equipmentTemp.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,startTime.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,startTemp.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,endTime.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,endTemp.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,totalTime.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,comments.text];
            [self recordData:activityToFill :dateString];
            format = nil;
            dateString = nil;
            currentTime = nil;
        }
    }
    else
    {
        if ([startTime1.text length] <= 0)
        {
            validations = [validations stringByAppendingFormat:@"\n Start Time cannot be empty!"];
        }
        if ([startTemp1.text length] <= 0)
        {
            validations = [validations stringByAppendingFormat:@"\n Start Temp cannot be empty!"];
        }
        if ([endTime1.text length] <= 0)
        {
            validations = [validations stringByAppendingFormat:@"\n End Time cannot be empty!"];
        }
        if ([endTemp1.text length] <= 0)
        {
            validations = [validations stringByAppendingFormat:@"\n End Temp cannot be empty!"];
        }
        if ([totalTime1.text length] <= 0)
        {
            validations = [validations stringByAppendingFormat:@"\n Total Time cannot be empty!"];
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
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,startTime1.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,startTemp1.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,endTime1.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,endTemp1.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,totalTime1.text];
            dataForActivity =[NSString stringWithFormat:@"%@((/%@))",dataForActivity,comments1.text];
            [self recordData:activityToFill :dateString];
            format = nil;
            dateString = nil;
            currentTime = nil;
        }
    }
}

-(void)recordData:(int)activityToF :(NSString *)dateString
{
    BOOL status;
    switch (activityToF)
    {
            
        case 10:
        {
            status = [dbManager.fmDatabase  executeUpdate:@"UPDATE recordForActivityLog SET preparation = ? WHERE id = ?",[NSString stringWithFormat:@"%@",dataForActivity],[NSNumber numberWithInt:selectedId]];
        }
            break;
        case 20:
        {
            status = [dbManager.fmDatabase  executeUpdate:@"UPDATE recordForActivityLog SET cookingFood = ? WHERE id = ?",[NSString stringWithFormat:@"%@",dataForActivity],[NSNumber numberWithInt:selectedId]];
        }
            break;
        case 30:
        {
            status = [dbManager.fmDatabase  executeUpdate:@"UPDATE recordForActivityLog SET coolingFood = ? WHERE id = ?",[NSString stringWithFormat:@"%@",dataForActivity],[NSNumber numberWithInt:selectedId]];
        }
            break;
        case 40:
        {
            status = [dbManager.fmDatabase  executeUpdate:@"UPDATE recordForActivityLog SET reheatingFood = ? WHERE id = ?",[NSString stringWithFormat:@"%@",dataForActivity],[NSNumber numberWithInt:selectedId]];
        }
            break;
        case 50:
        {
            status = [dbManager.fmDatabase  executeUpdate:@"UPDATE recordForActivityLog SET hotHolding = ? WHERE id = ?",[NSString stringWithFormat:@"%@",dataForActivity],[NSNumber numberWithInt:selectedId]];
        }
            break;
        case 60:
        {
            status = [dbManager.fmDatabase  executeUpdate:@"UPDATE recordForActivityLog SET serving = ? WHERE id = ?",[NSString stringWithFormat:@"%@",dataForActivity],[NSNumber numberWithInt:selectedId]];
        }
            break;
        case 70:
        {
            status = [dbManager.fmDatabase  executeUpdate:@"UPDATE recordForActivityLog SET foodPacking = ? WHERE id = ?",[NSString stringWithFormat:@"%@",dataForActivity],[NSNumber numberWithInt:selectedId]];
        }
            break;
    }
    if (status == YES)
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Data Saved!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        if (activityToFill == ([activityArray count]*10))
        {
            sucess.tag = 1;
        }
        else
        {
            sucess.tag = 11;
        }
        [sucess show];
        sucess = nil;
    }
    else
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:[dbManager.fmDatabase lastErrorMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        sucess = nil;
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self backClicked];
    }
    if (alertView.tag == 12)
    {
        [self deleteData];
    }
    if (alertView.tag == 11)
    {
        [self refresh];
    }
}

-(void)refresh
{
    [self clearText];
    [self loadDataForPage];
}

-(void)clearText
{
    startTemp.text = @"";
    startTemp1.text = @"";
    startTime.text = @"";
    startTime1.text = @"";
    endTemp.text = @"";
    endTemp1.text = @"";
    endTime.text = @"";
    endTime1.text = @"";
    equipmentName.text = @"";
    equipmentTemp.text = @"";
    comments.text = @"";
    comments1.text = @"";
    totalTime.text = @"";
    totalTime1.text = @"";
}

-(void)clearmemory
{
    tempStorageValues = nil;
    activityArray = nil;
    availableActivities = nil;
    tempStr = nil;
    dataForActivity = nil;
    equipmentNames = nil;
    detuctedTemp = nil;
    actionSheet = nil;
    toolBar = nil;
    picker = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [textField bounds];
    inputFieldBounds = [textField convertRect:inputFieldBounds toView:mainScroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y -= 100; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        CGPoint scrollPoint;
        scrollPoint.x = 0;
        scrollPoint.y = 0;// you can customize this value
        [mainScroll  setContentOffset:scrollPoint animated:YES];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGPoint scrollPoint;
    scrollPoint.x = 0;
    scrollPoint.y = 0;// you can customize this value
    [mainScroll  setContentOffset:scrollPoint animated:YES];
    return YES;
}

-(void)backClicked
{
    [self clearmemory];
    activityArray = nil;
    availableActivities = nil;
    tempStr = nil;
    dataForActivity = nil;
    tempStorageValues = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ActivitySelected:(UIButton *)sender
{
    int selectedTag = sender.tag;
    for (int i = 0; i < [activityArray count]; i++)
    {
        UIButton *temp = [activityArray objectAtIndex:i];
        if (selectedTag == temp.tag)
        {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"tab_menu_bg.png"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [temp setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        temp = nil;
    }
}
- (IBAction)equipmentNameListClicked:(UIButton *)sender
{
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM Equipments"];
    while([dbManager.fmResults next])
    {
        [equipmentNames addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"equipmentName"]]];
    }
    if ([equipmentNames count] > 0)
    {
        [self createPicker];
    }
    else
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Add Equipments in equipment calibaration" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        sucess = nil;
    }
}

- (IBAction)otherActivitiesStartClicked:(UIButton *)sender
{
    if (startStatus == 0)
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];

        [iCelsius setSamplingPeriod:0.5];
        
        if (iCelsius.isConnected == NO)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"iCelcius device is not connected!!Or Not connected properly!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [sucess show];
            sucess = nil;
        }
        else
        {
            [self performSelector:@selector(stopConsuming) withObject:nil afterDelay:5.5];
            startTemp1.text = [NSString stringWithFormat:@"%@",self.detuctedTemp];
        }
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"hh:mm:ss a"];
        NSDate *currentTime = [[NSDate alloc] init];
        NSString *dateString = [format stringFromDate:currentTime];
        startTime1.text = dateString;
        currentTime = nil;
        dateString = nil;
        format = nil;
        startStatus = 1;
        endTemp1.text = @"--";
        endTime1.text = @"--";
        totalTime1.text = @"--";
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"start_button.png"] forState:UIControlStateNormal];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [self performSelector:@selector(stopConsuming) withObject:nil afterDelay:5.5];
         endTemp1.text = [NSString stringWithFormat:@"%@",self.detuctedTemp];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"hh:mm:ss a"];
        NSDate *currentTime = [[NSDate alloc] init];
        NSString *dateString = [format stringFromDate:currentTime];
        endTime1.text = dateString;
        NSArray *timeD = [endTime1.text componentsSeparatedByString:@" "];
        dateString = @"";
        dateString = [NSString stringWithFormat:@"%@",[timeD objectAtIndex:0]];
        NSArray *timeDiff = [dateString componentsSeparatedByString:@":"];
        
        NSLog(@"END time %@",timeDiff);
        
        dateString = @"";
        dateString = startTime1.text;
        timeD = [dateString componentsSeparatedByString:@" "];
        dateString = [NSString stringWithFormat:@"%@",[timeD objectAtIndex:0]];
        NSArray *timeDiff1 = [dateString componentsSeparatedByString:@":"];
        NSString *sec,*min,*hrs;
        int t = [[timeDiff objectAtIndex:0] integerValue]-[[timeDiff1 objectAtIndex:0] integerValue];
        hrs = [NSString stringWithFormat:@"%d",t];
        t = [[timeDiff objectAtIndex:1] integerValue]-[[timeDiff1 objectAtIndex:1] integerValue];
        min = [NSString stringWithFormat:@"%d",t];
        t = [[timeDiff objectAtIndex:2] integerValue]-[[timeDiff1 objectAtIndex:2] integerValue];
        sec = [NSString stringWithFormat:@"%d",t];
        if ([sec integerValue] < 0)
        {
            sec = @"0";
            min = [NSString stringWithFormat:@"%d",[min integerValue]-1];
        }
        if ([min integerValue] < 0)
        {
            min = @"0";
            hrs = [NSString stringWithFormat:@"%d",[hrs integerValue]-1];
        }
        if ([hrs integerValue] < 0)
        {
            hrs = @"0";
        }
        totalTime1.text = [NSString stringWithFormat:@"%@:%@:%@",hrs,min,sec];
        
        currentTime = nil;
        dateString = nil;
        format = nil;
        sender.hidden = YES;
        startStatus = 2;
    }
 }

- (IBAction)CCRStartClicked:(UIButton *)sender
{
    if (stStatus == 0)
    {
        [iCelsius setSamplingPeriod:0.5];
        
        if (iCelsius.isConnected == NO)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"iCelcius device is not connected!!Or Not connected properly!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [sucess show];
            sucess = nil;
        }
        else
        {
            [self performSelector:@selector(stopConsuming) withObject:nil afterDelay:5.5];
            startTemp.text = [NSString stringWithFormat:@"%@",self.detuctedTemp];
        }
        [sender setBackgroundImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"hh:mm:ss a"];
        NSDate *currentTime = [[NSDate alloc] init];
        NSString *dateString = [format stringFromDate:currentTime];
        startTime.text = dateString;
        currentTime = nil;
        dateString = nil;
        format = nil;
        stStatus = 1;
        endTemp.text = @"--";
        endTime.text = @"--";
        totalTime.text = @"--";
        
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"start_button.png"] forState:UIControlStateNormal];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [self performSelector:@selector(stopConsuming) withObject:nil afterDelay:5.5];
        endTemp.text = [NSString stringWithFormat:@"%@",self.detuctedTemp];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"hh:mm:ss a"];
        NSDate *currentTime = [[NSDate alloc] init];
        NSString *dateString = [format stringFromDate:currentTime];
        endTime.text = dateString;
        currentTime = nil;
        dateString = nil;
        format = nil;
        stStatus  = 0;
        NSArray *timeD = [endTime.text componentsSeparatedByString:@" "];
        dateString = @"";
        dateString = [NSString stringWithFormat:@"%@",[timeD objectAtIndex:0]];
        NSArray *timeDiff = [dateString componentsSeparatedByString:@":"];
        
        NSLog(@"END time %@",timeDiff);
        
        dateString = @"";
        dateString = startTime.text;
        timeD = [dateString componentsSeparatedByString:@" "];
        dateString = [NSString stringWithFormat:@"%@",[timeD objectAtIndex:0]];
        NSArray *timeDiff1 = [dateString componentsSeparatedByString:@":"];
        NSLog(@"START time %@",timeDiff1);
        NSString *sec,*min,*hrs;
        int t = [[timeDiff objectAtIndex:0] integerValue]-[[timeDiff1 objectAtIndex:0] integerValue];
        hrs = [NSString stringWithFormat:@"%d",t];
        t = [[timeDiff objectAtIndex:1] integerValue]-[[timeDiff1 objectAtIndex:1] integerValue];
        min = [NSString stringWithFormat:@"%d",t];
        t = [[timeDiff objectAtIndex:2] integerValue]-[[timeDiff1 objectAtIndex:2] integerValue];
        sec = [NSString stringWithFormat:@"%d",t];
        if ([sec integerValue] < 0)
        {
            sec = @"0";
            min = [NSString stringWithFormat:@"%d",[min integerValue]-1];
        }
        if ([min integerValue] < 0)
        {
            min = @"0";
            hrs = [NSString stringWithFormat:@"%d",[hrs integerValue]-1];
        }
        if ([hrs integerValue] < 0)
        {
            hrs = @"0";
        }
        totalTime.text = [NSString stringWithFormat:@"%@:%@:%@",hrs,min,sec];
        sender.hidden = YES;
        stStatus = 2;
    }

}

- (IBAction)scanclicked:(UIButton *)sender
{
    iCelsius = [iCelsiusAPI sharedManager];
    iCelsius.dataConsumer = (DataProtocol*)self;
    [iCelsius setSamplingPeriod:0.5];
    if (iCelsius.isConnected == NO)
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"iCelcius device is not connected!!Or Not connected properly!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        sucess = nil;
    }
    else
    {
        [self performSelector:@selector(stopConsuming) withObject:nil afterDelay:5.5];
        equipmentTemp.text = [NSString stringWithFormat:@"%@",self.detuctedTemp];
    }

}

- (IBAction)editClicked:(UIButton *)sender
{
    BOOL status;
    status = [dbManager.fmDatabase  executeUpdate:@"UPDATE temp SET tempStorageValue = ? WHERE id = 1",[NSMutableString stringWithFormat:@"%d",foodID]];
    
    if (sender.tag == 1)
    {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {    // The iOS device = iPhone or iPod Touch
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            if (iOSDeviceScreenSize.height == 480)
            {
                ALEditViewController *edit = [[ALEditViewController alloc]initWithNibName:@"ALEditViewController" bundle:nil];
                [self.navigationController pushViewController:edit animated:YES];
                edit = nil;
            }
            if (iOSDeviceScreenSize.height > 480)
            {
                ALEditViewController *edit = [[ALEditViewController alloc]initWithNibName:@"ALEditViewController5" bundle:nil];
                [self.navigationController pushViewController:edit animated:YES];
                edit = nil;
            }
        }
        
    }
    else
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"This will delete the Food Item! \nAre you sure you want to delete this Food Item ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        sucess.tag = 12;
        [sucess show];
        sucess = nil;
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
    toolBar = nil;
    [actionSheet addSubview:picker];
    [actionSheet  showInView:self.view];
    [actionSheet setBounds:CGRectMake(0,0,320, 464)];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [equipmentNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [equipmentNames objectAtIndex:row];
}

-(void)DatePickerDoneClick
{
    equipmentName.text = [equipmentNames objectAtIndex:[picker selectedRowInComponent:0]];
    picker = nil;
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    actionSheet = nil;
}

-(void)CancelPickerDoneClick
{
    picker = nil;
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    actionSheet = nil;
}


#pragma iCelsius API implementation
- (void)consumeData:(Data*)data
{
    NSLog(@"Data from the device %@",data);
    data.timestamp = 2.0;
    if (data)
    {
        self.detuctedTemp = [NSString stringWithFormat:@"%f",[data.m1 floatValue]];
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
    self.detuctedTemp = [NSString stringWithFormat:@"-"];
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
