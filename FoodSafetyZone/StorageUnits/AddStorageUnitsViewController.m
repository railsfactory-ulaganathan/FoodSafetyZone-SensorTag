//
//  AddStorageUnitsViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 15/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "AddStorageUnitsViewController.h"
#import "DBManager.h"
#import "AddRecordsStorageUnitViewController.h"
#define SOURCETYPE UIImagePickerControllerSourceTypeCamera

@interface AddStorageUnitsViewController ()
{
    UIImage *selectedImage;
}
@end
@implementation AddStorageUnitsViewController
@synthesize addImage,storageUnitNameField,unitTypeField,unitTypes,alertMessage,tempRange;
@synthesize mainScroll,backView,helpText,infoBut;

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
    self.navigationItem.title = @"STORAGE UNITS";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mainScroll addSubview:backView];
    mainScroll.contentSize = CGSizeMake(320, backView.frame.size.height + 50);
    
    unitTypes = [[NSMutableArray alloc]init];
    tempRange = [[NSMutableArray alloc]init];
    dbManager = [DBManager sharedInstance];
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM AddStorageUnitType"];
    
    if (unitTypes)
    {
        [unitTypes removeAllObjects];
        [tempRange removeAllObjects];
    }
    while([dbManager.fmResults next])
    {
        
        [unitTypes addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"storageUnitType"]]];
        [tempRange addObject:[NSString stringWithFormat:@"%.2f to %.2f",[dbManager.fmResults doubleForColumn:@"minTemp"],[dbManager.fmResults doubleForColumn:@"maxTemp"]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addStorageClicked:(id)sender
{
    UIActionSheet *selectionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery",@"Cancel", nil];
    selectionSheet.tag = 2;
    [selectionSheet showInView:self.view];
    selectionSheet = nil;
}


#pragma mark - Action Sheet Delegate

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
    selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [addImage setImage:selectedImage];
    NSLog(@"image selected %@",selectedImage);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)unitTypeClicked:(id)sender
{
    if ([unitTypes count]>0)
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
    else
    {
        UIAlertView *noUnitTypes = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Add Unit Type in Master" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [noUnitTypes show];
        noUnitTypes = nil;
    }
    

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [unitTypes count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [unitTypes objectAtIndex:row];
    
}

-(void)DatePickerDoneClick
{
    unitTypeField.text = [NSString stringWithFormat:@"%@",[unitTypes objectAtIndex:[picker selectedRowInComponent:0]]];
    [unitTypeField resignFirstResponder];
    [storageUnitNameField resignFirstResponder];
    [alertMessage resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)CancelPickerDoneClick
{
    [unitTypeField resignFirstResponder];
    [storageUnitNameField resignFirstResponder];
    [alertMessage resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)doneClicked
{
    
    
    NSString *validations = [[NSString alloc]init];
        if ([storageUnitNameField.text length]<=0)
        {
            validations = [validations stringByAppendingFormat:@"Storage Unit Name cannot be empty!"];
        }
        if ([unitTypeField.text length] <= 0)
        {
            validations = [validations stringByAppendingFormat:@"\n Unit Type cannot be empty!"];
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
        if (!selectedImage)
        {
            selectedImage = [UIImage imageNamed:@"no-image.png"];
        }
        NSData *imgData = UIImageJPEGRepresentation(selectedImage, 50);
        
        dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT id FROM AddStorageUnitType WHERE storageUnitType = ?",unitTypeField.text];
        NSMutableArray *selId = [[NSMutableArray alloc]init];
        while([dbManager.fmResults next])
        {
            
           [selId addObject:[NSString stringWithFormat:@"%d",[dbManager.fmResults intForColumn:@"id"]]];
        }
        
        status = [dbManager.fmDatabase  executeUpdate:@"INSERT INTO AddStorageUnits(StorageUnitName,UnitType,alertMessage,storageUnitImage,tempRange,storageUnitTypeId,id) VALUES(?,?,?,?,?,?,NULL)",storageUnitNameField.text,unitTypeField.text,alertMessage.text,imgData,[tempRange objectAtIndex:[picker selectedRowInComponent:0]],[selId objectAtIndex:0],nil];
        selId = nil;
        imgData = nil;
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Storage Unit created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            sucess.tag = 1;
            [sucess show];
            sucess = nil;
            if (selectedImage)
            {
                selectedImage = [UIImage imageNamed:@"add-image.png"];
            }
        }
        else
        {
            if ([dbManager.fmDatabase hadError])
            {
                NSString *alertValue;
                    if ([dbManager.fmDatabase lastErrorCode]==19)
                    {
                        alertValue = [NSString stringWithFormat:@"Storage Unit Name already taken!"];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [mainScroll  setContentOffset:mainScroll.bounds.origin animated:YES];
        return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [mainScroll  setContentOffset:mainScroll.bounds.origin animated:YES];
    return YES;
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self backClicked];
    }
}

-(void)backClicked
{
    picker = nil;
    actionSheet = nil;
    toolBar = nil;
    tempRange = nil;
    unitTypes = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)infoClicked:(id)sender
{
    helpText.frame = CGRectMake(infoBut.frame.origin.x - 20,infoBut.frame.origin.y - 100, 200, 100);
    helpText.alpha = 0;
    [UIView beginAnimations:@"showHelpText" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    helpText.alpha = 1.0;
    [UIView commitAnimations];
    
    [backView addSubview:helpText];
}

- (IBAction)helpTextResign:(id)sender
{
    if (helpText)
    {
        [helpText removeFromSuperview];
    }
}
@end
