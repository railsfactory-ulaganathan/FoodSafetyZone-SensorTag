//
//  CSAddRecordViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 22/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "CSAddRecordViewController.h"
#import "CSEditViewController.h"
#define SOURCETYPE UIImagePickerControllerSourceTypeCamera

@interface CSAddRecordViewController ()
{
    UIImage *selectedImage;
}

@end

@implementation CSAddRecordViewController
@synthesize equipmentNameField,frequencyField,commentsField,cleaningInstrField,productsToUseField,responsiblePersonField,reviewedByField,specialInstrField,equipmentImage,mainScroll,backView;

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
    self.navigationItem.title = @"CLEANING SCHEDULE";
    [self loadDataForPage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainScroll.contentSize = backView.bounds.size;
    [mainScroll addSubview:backView];
    frequencyArray = [[NSMutableArray alloc]initWithObjects:@"Daily",@"Weekly",@"Monthly", nil];
}

-(void)loadDataForPage
{
    dbManager = [DBManager sharedInstance];
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbManager.fmResults next])
    {
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM cleaningEquipments WHERE id = ?",[NSNumber numberWithInt:[tempStorageValues integerValue]]];
    while([dbManager.fmResults next])
    {
        equipmentNameField.text = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"equipmentName"]];
        NSData *tempData = [dbManager.fmResults dataForColumn:@"equipmentImage"];
        [equipmentImage setImage:[UIImage imageWithData:tempData] forState:UIControlStateNormal];
        tempData = nil;
        selectedId = [dbManager.fmResults intForColumn:@"id"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEquipmentNameField:nil];
    [self setFrequencyField:nil];
    [self setCommentsField:nil];
    [self setCleaningInstrField:nil];
    [self setProductsToUseField:nil];
    [self setResponsiblePersonField:nil];
    [self setReviewedByField:nil];
    [self setSpecialInstrField:nil];
    [self setEquipmentImage:nil];
    [self setMainScroll:nil];
    [self setBackView:nil];
    [super viewDidUnload];
}

- (IBAction)frequencyClicked:(id)sender
{
    [self createPicker];
}

- (IBAction)editClicked:(UIButton *)sender
{
    BOOL status;
    status = [dbManager.fmDatabase  executeUpdate:@"UPDATE temp SET tempStorageValue = ? WHERE id = 1",[NSMutableString stringWithFormat:@"%d",selectedId]];
    
    if (sender.tag == 1)
    {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {    // The iOS device = iPhone or iPod Touch
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            if (iOSDeviceScreenSize.height == 480)
            {
                CSEditViewController *edit = [[CSEditViewController alloc]initWithNibName:@"CSEditViewController" bundle:nil];
                [self.navigationController pushViewController:edit animated:YES];
                edit = nil;
            }
            if (iOSDeviceScreenSize.height > 480)
            {
                CSEditViewController *edit = [[CSEditViewController alloc]initWithNibName:@"CSEditViewController5" bundle:nil];
                [self.navigationController pushViewController:edit animated:YES];
                edit = nil;
            }
        }
        
    }
    else
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"This will delete the Equipment! \nAre you sure you want to delete this Equipment ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        sucess.tag = 12;
        [sucess show];
        sucess = nil;
    }
}

- (void)addPhotoClicked
{
    UIActionSheet *selectionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery",@"Cancel", nil];
    selectionSheet.tag = 2;
    [selectionSheet showInView:self.view];
    selectionSheet = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self backClicked];
    }
    if (alertView.tag == 12)
    {
        if (buttonIndex == 0)
        {
            [self deleteData];
        }
    }
}

-(void)deleteData
{
    bool bScuees;
    bScuees =[dbManager.fmDatabase executeUpdate:@"DELETE FROM cleaningEquipments WHERE id = ?",[NSNumber numberWithInt:selectedId]];
    
    if ([dbManager.fmDatabase hadError])
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:[dbManager.fmDatabase lastErrorMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        sucess.tag = 1;
        [sucess show];
        sucess = nil;
    }
    if (bScuees == YES)
    {
        [self backClicked];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet1 didDismissWithButtonIndex :(NSInteger)buttonIndex
{
    
    if (actionSheet1.tag == 2)
    {
        if(buttonIndex == 0)
        {
            [actionSheet1 dismissWithClickedButtonIndex:0 animated:YES];
            UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
            if ([UIImagePickerController isSourceTypeAvailable:SOURCETYPE])
            {
                cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else
            {
                cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            cameraUI.allowsEditing = NO;
            cameraUI.delegate = self;
            [self presentViewController:cameraUI animated:YES completion:Nil];
            cameraUI = nil;
        }
        else if (buttonIndex == 1)
        {
            [actionSheet1 dismissWithClickedButtonIndex:1 animated:YES];
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            imagePicker.allowsEditing=YES;
            imagePicker.navigationBarHidden = NO;
            [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
            self.navigationController.navigationBar.tintColor = [UIColor greenColor];
            imagePicker = nil;
            
        }
        else
        {
            [actionSheet1 dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [equipmentImage setImage:selectedImage forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)doneClicked
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd,EEE"];
    NSDate *currentTime = [[NSDate alloc] init];
    NSString *dateString = [format stringFromDate:currentTime];
    NSString *validations = [[NSString alloc]init];
    if ([equipmentNameField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Equipment Name cannot be empty!"];
    }
    if ([frequencyField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n Frequency cannot be empty!"];
    }
    if ([responsiblePersonField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Responsible person cannot be empty!"];
    }
    if ([productsToUseField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n Products to use cannot be empty!"];
    }
    if ([responsiblePersonField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n Reviewer Name cannot be empty!"];
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
        NSData *imgData = UIImageJPEGRepresentation(equipmentImage.currentImage, 50);

        status = [dbManager.fmDatabase  executeUpdate:@"INSERT INTO recordForCleaningSchedule(id,equipmentName,equipmentImage,frequency,cleaningInstruction,productsToUse,responsiblePerson,reviewedBy,specialInstruction,frequencyComments,date) VALUES(NULL,?,?,?,?,?,?,?,?,?,?)",equipmentNameField.text,imgData,frequencyField.text,cleaningInstrField.text,productsToUseField.text,responsiblePersonField.text,reviewedByField.text,specialInstrField.text,commentsField.text,dateString,nil];
        imgData = nil;
        currentTime = nil;
        dateString = nil;
        format = nil;
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Record created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            sucess.tag = 1;
            [sucess show];
            sucess = nil;
        }
        else
        {
            if ([dbManager.fmDatabase hadError])
            {
                NSString *alertValue;
                if ([dbManager.fmDatabase lastErrorCode]==19)
                {
                    alertValue = [NSString stringWithFormat:@"Equipment Name already taken!"];
                }
                else
                {
                    alertValue = [dbManager.fmDatabase lastErrorMessage];
                }
                UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:alertValue delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                sucess.tag = 1;
                [sucess show];
                sucess = nil;
                alertValue = nil;
            }
        }
        NSLog(@"%c",status);
    }
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [frequencyArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        return [frequencyArray objectAtIndex:row];
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

-(void)DatePickerDoneClick
{
    frequencyField.text = [frequencyArray objectAtIndex:[picker selectedRowInComponent:0]];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    actionSheet = nil;
}

-(void)CancelPickerDoneClick
{
    picker = nil;
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    actionSheet = nil;
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
