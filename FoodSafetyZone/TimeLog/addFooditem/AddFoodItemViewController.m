//
//  AddFoodItemViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 20/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "AddFoodItemViewController.h"
#define SOURCETYPE UIImagePickerControllerSourceTypeCamera

@interface AddFoodItemViewController ()
{
    UIImage *selectedImage;
    int tftag,selectedActivityId;
}

@end

@implementation AddFoodItemViewController
@synthesize activity,foodTemp,foodNameField,mainScroll,addImageButton,activityField,foodTempField,FoodItemImage;

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainScroll.contentSize = self.view.frame.size;
    ActivityNames = [[NSMutableArray alloc]init];
    foodTemps = [[NSMutableArray alloc]initWithObjects:@"Cold Food",@"Hot Food", nil];
    activityId = [[NSMutableArray alloc]init];
    selectedImage = FoodItemImage.currentImage;
    dbManager = [DBManager sharedInstance];
    [FoodItemImage setContentMode:UIViewContentModeRedraw];
    [self loadDataForPage];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadDataForPage
{
    if (ActivityNames)
    {
        [ActivityNames removeAllObjects];
        [activityId removeAllObjects];
    }
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM Purpose"];
    while([dbManager.fmResults next])
    {
        [ActivityNames addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"purposeName"]]];
        [activityId addObject:[NSString stringWithFormat:@"%d",[dbManager.fmResults intForColumn:@"id"]]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)foodTempClicked:(UIButton *)sender
{
    tftag = sender.tag;
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [sender bounds];
    inputFieldBounds = [sender convertRect:inputFieldBounds toView:mainScroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y -= 100; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
    
    if ([foodTemps count]>0)
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
    else
    {
        UIAlertView *noUnitTypes = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Add Activity in Settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [noUnitTypes show];
        noUnitTypes = nil;
    }

}

- (IBAction)activityClicked:(UIButton *)sender
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
    else
    {
        UIAlertView *noUnitTypes = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Add Activity in Settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [noUnitTypes show];
        noUnitTypes = nil;
    }

}

-(void)DatePickerDoneClick
{
    CGPoint scrollPoint;
    CGRect inputFieldBounds;
    if (tftag == 1)
    {
        activityField.text = [NSString stringWithFormat:@"%@",[ActivityNames objectAtIndex:[picker selectedRowInComponent:0]]];
        selectedActivityId = [[activityId objectAtIndex:[picker selectedRowInComponent:0]] intValue];
        inputFieldBounds = [activityField bounds];
        inputFieldBounds = [activityField convertRect:inputFieldBounds toView:mainScroll];
    }
    else
    {
        foodTempField.text = [NSString stringWithFormat:@"%@",[foodTemps objectAtIndex:[picker selectedRowInComponent:0]]];
        inputFieldBounds = [foodTempField bounds];
        inputFieldBounds = [foodTempField convertRect:inputFieldBounds toView:mainScroll];
    }
    
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y = 0; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
    
    [foodNameField resignFirstResponder];
    [activityField resignFirstResponder];
    [foodTempField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)CancelPickerDoneClick
{
    [foodNameField resignFirstResponder];
    [activityField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    CGPoint scrollPoint;
    scrollPoint.x = 0;
    scrollPoint.y = 0; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
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
        return [foodTemps count];
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
        return [foodTemps objectAtIndex:row];
    }
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [textField bounds];
    inputFieldBounds = [textField convertRect:inputFieldBounds toView:mainScroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y = 0; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)addImageClicked:(id)sender
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
    [FoodItemImage setImage:selectedImage forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)doneClicked
{
    NSString *validations = [[NSString alloc]init];
    if ([foodNameField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Food Name cannot be empty!"];
    }
    if ([foodTempField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n Food temperature cannot be empty!"];
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
        NSData *imgData = UIImageJPEGRepresentation(selectedImage, 50.0);
        status = [dbManager.fmDatabase executeUpdate:@"INSERT INTO FoodItem(id,foodName,purposeName,foodTemp,foodImage,purposeId,startTime,startStatus) VALUES(NULL,?,?,?,?,?,NULL,NULL)",foodNameField.text,activityField.text,foodTempField.text,imgData,[NSNumber numberWithInt:selectedActivityId],nil];
        
        imgData = nil;
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Food Item created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            sucess.tag = 1;
            [sucess show];
            sucess = nil;
        }
        else
        {
            if ([dbManager.fmDatabase hadError])
            {
                NSString *err;
                if ([dbManager.fmDatabase lastErrorCode] == 19)
                {
                    err = @"Food Name already taken!!!";
                }
                UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:err delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [sucess show];
                sucess = nil;
                err = nil;
            }
        }
        NSLog(@"%c",status);
    }
}

-(void)backClicked
{
    picker = nil;
    actionSheet= nil;
    toolBar = nil;
    ActivityNames = nil;
    activityId = nil;
    activity = nil;
    foodTemp = nil;
    foodNameField = nil;
    mainScroll = nil;
    addImageButton = nil;
    activityField = nil;
    foodTempField = nil;
    FoodItemImage = nil;;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
