//
//  EditSuppliersViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 08/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "EditSuppliersViewController.h"
#define SOURCETYPE UIImagePickerControllerSourceTypeCamera
#import "AddSupplierViewController.h"

@interface EditSuppliersViewController ()
{
    int tftag,supplierId;
}

@end

@implementation EditSuppliersViewController
@synthesize mainScroll,backView,supplierImage,supplierName,streetName,provinceField,cityField,pinField,stateField,countryField,foodBusinessNoField,mobileField,workPhoneField,emailField,supplyStartDateField,otherInformationField,foodCategoryField,foodItemField,foodItemButton;

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
    self.navigationItem.title = @"SUPPLIERS";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [DBManager sharedInstance];
    mainScroll.contentSize = backView.frame.size;
    [mainScroll addSubview:backView];
    foodCategories = [[NSMutableArray alloc]init];
    countries = [[NSMutableArray alloc]initWithObjects:@"Australia",nil];
    states = [[NSMutableArray alloc]initWithObjects:@"", nil];
    [self loadDataForPage];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadDataForPage
{
    if (foodCategories)
    {
        [foodCategories removeAllObjects];
    }
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM foodCategory"];
    while([dbManager.fmResults next])
    {
        [foodCategories addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodCategoryName"]]];
    }
    
    dbManager.fmResults = [dbManager.fmDatabase executeQuery:@"SELECT * FROM suppliers WHERE id = ?",dbManager.tempStorageValues];
    while([dbManager.fmResults next])
    {
        supplierName.text = [dbManager.fmResults stringForColumn:@"supplierName"];
        streetName.text = [dbManager.fmResults stringForColumn:@"streetName"];
        provinceField.text = [dbManager.fmResults stringForColumn:@"province"];
        cityField.text = [dbManager.fmResults stringForColumn:@"city"];
        pinField.text = [dbManager.fmResults stringForColumn:@"pin"];
        stateField.text = [dbManager.fmResults stringForColumn:@"state"];
        countryField.text = [dbManager.fmResults stringForColumn:@"country"];
        foodBusinessNoField.text = [dbManager.fmResults stringForColumn:@"foodBusinessNo"];
        mobileField.text = [dbManager.fmResults stringForColumn:@"mobile"];
        workPhoneField.text = [dbManager.fmResults stringForColumn:@"workPhone"];
        emailField.text = [dbManager.fmResults stringForColumn:@"emailId"];
        supplyStartDateField.text = [dbManager.fmResults stringForColumn:@"date"];
        otherInformationField.text = [dbManager.fmResults stringForColumn:@"otherInformation"];
        NSData *tempData = [dbManager.fmResults dataForColumn:@"supplierImage"];
        supplierImage.image = [UIImage imageWithData:tempData];
        tempData = nil;
        supplierId = [dbManager.fmResults intForColumn:@"id"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPhotoClicked:(UIButton *)sender
{
    tftag = sender.tag;
    [self chooseOption];
}

-(void)chooseOption
{
    UIActionSheet *selectionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery",@"Cancel", nil];
    selectionSheet.tag = 2;
    [selectionSheet showInView:self.view];
    selectionSheet = nil;
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
    if (tftag == 11)
    {
        supplierImage.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    else
    {
        [foodItemButton setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)countryClicked:(UIButton *)sender
{
    tftag = sender.tag;
    [self fieldAnimation:sender];
    [self createPicker];
}

- (IBAction)stateClicked:(UIButton *)sender
{
    tftag = sender.tag;
    [self fieldAnimation:sender];
    [self createPicker];
}
- (IBAction)foodCategoryClicked:(UIButton *)sender
{
    tftag = sender.tag;
    [self fieldAnimation:sender];
    if ([foodCategories count]>0)
    {
        [self createPicker];
    }
    else
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Add food category in Master!!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        sucess = nil;
    }

    
}

- (IBAction)dateClicked:(UIButton *)sender
{
    tftag = sender.tag;
    [self fieldAnimation:sender];
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

-(void)dateChanged
{
    if (tftag == 3)
    {
        FormatDate = [[NSDateFormatter alloc] init];
        [FormatDate setDateFormat:@"yyyy-MM-dd,EEE"];
    }
}

- (IBAction)addFoodItemClicked:(UIButton *)sender
{
    NSString *validations = [[NSString alloc]init];
    if ([foodItemField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Food Item Name cannot be empty!"];
    }
    if ([foodCategoryField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\nFood Category cannot be empty!"];
    }
    if ([validations length]>0)
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:validations delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        sucess = nil;
    }
    else
    {
        BOOL status;
        
        NSData *imgData = UIImageJPEGRepresentation(foodItemButton.currentImage, 50);
        
        status = [dbManager.fmDatabase  executeUpdate:@"INSERT INTO supplierFoodItems(id,foodItem,foodItemImage,foodCategory,supplierId) VALUES(NULL,?,?,?,?)",foodItemField.text,imgData,foodCategoryField.text,[NSNumber numberWithInt:supplierId],nil];
        imgData = nil;
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Food Item created under the category %@",foodCategoryField.text] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            sucess.tag = 1;
            [sucess show];
            sucess = nil;
            
            foodItemField.text = @"";
            [foodItemButton setImage:[UIImage imageNamed:@"no-image.png"] forState:UIControlStateNormal];
        }
        else
        {
            if ([dbManager.fmDatabase hadError])
            {
                NSString *alertValue;
                if ([dbManager.fmDatabase lastErrorCode]==19)
                {
                    alertValue = [NSString stringWithFormat:@"Supplier Name already taken!"];
                }
                else
                {
                    alertValue = [dbManager.fmDatabase lastErrorMessage];
                }
                UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:alertValue delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                sucess.tag = 1;
                [sucess show];
                sucess = nil;
            }
        }
        NSLog(@"%c",status);
    }
}

- (IBAction)addImageFoodItemClicked:(UIButton *)sender
{
    tftag = sender.tag;
    [self chooseOption];
}

- (IBAction)viewClicked:(id)sender
{
    dbManager.tempStorageValues = [NSMutableString stringWithFormat:@"%@",supplierName.text];
    AddSupplierViewController *addSupplier = [[AddSupplierViewController alloc]initWithNibName:@"AddSupplierViewController" bundle:nil];
    [self.navigationController pushViewController:addSupplier animated:YES];
    addSupplier = nil;
}

- (IBAction)deleteClicked:(id)sender
{
    bool bScuees;
    bScuees =[dbManager.fmDatabase executeUpdate:@"DELETE FROM suppliers WHERE id = ?",[NSNumber numberWithInt:[dbManager.tempStorageValues integerValue]]];
    
    if ([dbManager.fmDatabase hadError])
    {
        NSLog(@"%@",[dbManager.fmDatabase lastErrorMessage]);
        NSString *alertValue;
        if ([dbManager.fmDatabase lastErrorCode]==19)
        {
            alertValue = [NSString stringWithFormat:@"Storage Unit Name already taken!"];
        }
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:alertValue delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        sucess.tag = 1;
        [sucess show];
    }
    if (bScuees == YES)
    {
        [self backClicked];
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

-(void)fieldAnimation:(UIButton *)sender
{
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [sender bounds];
    inputFieldBounds = [sender convertRect:inputFieldBounds toView:mainScroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y -= 100; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
}

-(void)fieldCloseAnimation:(UITextField *)sender
{
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [sender bounds];
    inputFieldBounds = [sender convertRect:inputFieldBounds toView:mainScroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    //scrollPoint.y -= 25; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
}

-(void)doneClicked
{
    NSString *validations = [[NSString alloc]init];
    if ([supplierName.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Supplier Name cannot be empty!"];
    }
    if ([streetName.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n Street Name cannot be empty!"];
    }
    if ([workPhoneField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n Work Phone Number cannot be empty!"];
    }
    if ([supplyStartDateField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Start date cannot be empty!"];
    }
    if ([validations length]>0)
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:validations delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        sucess = nil;
    }
    else
    {
        BOOL status;
        
        NSData *imgData = UIImageJPEGRepresentation(supplierImage.image, 50);
        
         status = [dbManager.fmDatabase  executeUpdate:@"UPDATE suppliers SET supplierName = ?, foodBusinessNo = ?, mobile = ?, workPhone = ?,  emailId = ?, date = ? , otherInformation = ?, supplierImage = ?, streetName = ?, province = ?, city = ?,  pin = ?, state = ?, country = ?  WHERE id = ?",supplierName.text,foodBusinessNoField.text,mobileField.text,workPhoneField.text,emailField.text,supplyStartDateField.text,otherInformationField.text,imgData,streetName.text,provinceField.text,cityField.text,pinField.text,stateField.text,countryField.text,[NSNumber numberWithInt:[dbManager.tempStorageValues integerValue]]];
        imgData = nil;
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Supplier Edited" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
                    alertValue = [NSString stringWithFormat:@"Supplier Name already taken!"];
                }
                else
                {
                    alertValue = [dbManager.fmDatabase lastErrorMessage];
                }
                UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:alertValue delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                sucess.tag = 1;
                [sucess show];
                sucess = nil;
            }
        }
        NSLog(@"%c",status);
    }
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
        CGRect inputFieldBounds = [textView bounds];
        inputFieldBounds = [textView convertRect:inputFieldBounds toView:mainScroll];
        scrollPoint.x = 0;
        scrollPoint.y += inputFieldBounds.origin.y;// you can customize this value
        [mainScroll  setContentOffset:scrollPoint animated:YES];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [textField bounds];
    inputFieldBounds = [textField convertRect:inputFieldBounds toView:mainScroll];
    scrollPoint.x = 0;
    scrollPoint.y += inputFieldBounds.origin.y;// you can customize this value
    [mainScroll  setContentOffset:scrollPoint animated:YES];
    [mainScroll  setContentOffset:mainScroll.bounds.origin animated:YES];
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    if (tftag == 1)
    {
        return [states count];
    }
    else if (tftag == 2)
    {
        return [countries count];
    }
    else if(tftag == 4)
    {
        return [foodCategories count];
    }
    else
    {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (tftag == 1)
    {
        return [states objectAtIndex:row];
    }
    else if (tftag == 2)
    {
        return [countries objectAtIndex:row];
    }
    else if(tftag == 4)
    {
        return [foodCategories objectAtIndex:row];
    }
    else
    {
        return 0;
    }
}

-(void)DatePickerDoneClick
{
    if (tftag == 1)
    {
        stateField.text = [states objectAtIndex:[picker selectedRowInComponent:0]];
        [self fieldCloseAnimation:stateField];
    }
    else if (tftag == 2)
    {
        countryField.text = [countries objectAtIndex:[picker selectedRowInComponent:0]];
        [self fieldCloseAnimation:countryField];
    }
    else if (tftag == 3)
    {
        supplyStartDateField.text = [FormatDate stringFromDate:[datePicker date]];
        [self fieldCloseAnimation:supplyStartDateField];
        datePicker = nil;
    }
    else if(tftag == 4)
    {
        foodCategoryField.text = [foodCategories objectAtIndex:[picker selectedRowInComponent:0]];
        [self fieldCloseAnimation:foodCategoryField];
    }
    [self clearFields];
    picker = nil;
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    actionSheet = nil;
}

-(void)CancelPickerDoneClick
{
    [self clearFields];
    picker = nil;
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    actionSheet = nil;
}

-(void)clearFields
{
    [supplierName resignFirstResponder];
    [streetName resignFirstResponder];
    [provinceField resignFirstResponder];
    [cityField resignFirstResponder];
    [pinField resignFirstResponder];
    [stateField resignFirstResponder];
    [countryField resignFirstResponder];
    [foodBusinessNoField resignFirstResponder];
    [mobileField resignFirstResponder];
    [workPhoneField resignFirstResponder];
    [emailField resignFirstResponder];
    [supplyStartDateField resignFirstResponder];
    [foodCategoryField resignFirstResponder];
    [foodItemField resignFirstResponder];
}



@end
