//
//  AddFoodCategoryViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 05/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "AddFoodCategoryViewController.h"
#define SOURCETYPE UIImagePickerControllerSourceTypeCamera

@interface AddFoodCategoryViewController ()
{
    UIImage *selectedImage;
}

@end

@implementation AddFoodCategoryViewController
@synthesize foodCategoryNameField,foodCategoryImage,minTempField,mainScroll,maxTempField;

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
    self.navigationItem.title = @"FOOD CATEGORY";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [DBManager sharedInstance];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddImageClicked:(id)sender
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
    [foodCategoryImage setImage:selectedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneClicked
{
    NSString *validations = [[NSString alloc]init];
    if ([foodCategoryNameField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Food Category Name cannot be empty!"];
    }
    if ([minTempField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n Min temperature cannot be empty!"];
    }
    if ([maxTempField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n Max temp cannot be empty! "];
    }
    if ([maxTempField.text floatValue]<[minTempField.text floatValue])
    {
        validations = [validations stringByAppendingFormat:@"\n Max temp cannot be lesser than Min temp !"];
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
        if (!selectedImage)
        {
            selectedImage = [UIImage imageNamed:@"no-image.png"];
        }
        NSData *imgData = UIImageJPEGRepresentation(selectedImage, 50.0);
        status = [dbManager.fmDatabase executeUpdate:@"INSERT INTO foodCategory(id,foodCategoryName,minTemp,maxTemp,foodCategoryImage) VALUES(NULL,?,?,?,?)",foodCategoryNameField.text,minTempField.text,maxTempField.text,imgData,nil];
        
        imgData = nil;
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Food Category created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            sucess.tag = 1;
            [sucess show];
            sucess = nil;
        }
        else
        {
             NSString *err;
            if ([dbManager.fmDatabase hadError])
            {
               
                if ([dbManager.fmDatabase lastErrorCode] == 19)
                {
                    err = @"Food Category Name already taken!!!";
                }
            }
            else
            {
                err = [NSString stringWithFormat:@"%@",[dbManager.fmDatabase lastErrorMessage]];
            }
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:err delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [sucess show];
                sucess = nil;
                err = nil;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CGPoint scrollPoint;
    scrollPoint.x = 0;
    scrollPoint.y = 0; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
    [textField resignFirstResponder];
    return YES;
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
