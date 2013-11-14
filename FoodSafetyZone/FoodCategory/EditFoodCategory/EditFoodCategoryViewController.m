//
//  EditFoodCategoryViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 05/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "EditFoodCategoryViewController.h"
#define SOURCETYPE UIImagePickerControllerSourceTypeCamera

@interface EditFoodCategoryViewController ()
{
    int selectedID;
    UIImage *selectedImage;
}

@end

@implementation EditFoodCategoryViewController
@synthesize foodCategoryField,foodCategoryImage,minTempField,maxTempField,mainScroll;

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
    [self loadDataForPage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbmanager = [DBManager sharedInstance];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadDataForPage
{
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM foodCategory WHERE foodCategoryName = ?",dbmanager.tempStorageValues];
    while([dbmanager.fmResults next])
    {
        foodCategoryField.text = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"foodCategoryName"]];
        minTempField.text = [NSString stringWithFormat:@"%.2f",[dbmanager.fmResults doubleForColumn:@"minTemp"]];
        maxTempField.text = [NSString stringWithFormat:@"%.2f",[dbmanager.fmResults doubleForColumn:@"maxTemp"]];
        NSData *tempImgData = [dbmanager.fmResults dataForColumn:@"foodCategoryImage"];
        [foodCategoryImage setImage:[UIImage imageWithData:tempImgData]];
        tempImgData = nil;
        selectedID = [dbmanager.fmResults doubleForColumn:@"id"];
    }
}

-(void)doneClicked
{
    NSString *validations = [[NSString alloc]init];
    if ([foodCategoryField.text length]<=0)
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
    }
    else
    {
        BOOL status;
        NSData *imgData = UIImageJPEGRepresentation(foodCategoryImage.image, 50);
        
        status = [dbmanager.fmDatabase  executeUpdate:@"UPDATE foodCategory SET  foodCategoryName = ?, minTemp = ?, maxTemp = ?, foodCategoryImage = ?  WHERE id = ?",foodCategoryField.text,[NSNumber numberWithDouble:[minTempField.text floatValue]],[NSNumber numberWithDouble:[maxTempField.text floatValue]],imgData,[NSNumber numberWithInt:selectedID]];
        imgData = nil;
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Food category edited !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [sucess show];
            sucess.tag = 1;
            sucess = nil;
        }
        else
        {
            if ([dbmanager.fmDatabase hadError])
            {
                NSLog(@"%d",[dbmanager.fmDatabase lastErrorCode]);
                UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:[dbmanager.fmDatabase lastErrorMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [sucess show];
                sucess = nil;
            }
        }
        NSLog(@"%c",status);
    }
}

- (IBAction)addPhotoClicked:(id)sender
{
    UIActionSheet *selectionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery",@"Cancel", nil];
    selectionSheet.tag = 2;
    [selectionSheet showInView:self.view];
    selectionSheet = nil;
}

- (IBAction)deleteData:(id)sender
{
    UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"This will delete the Food Category! \nAre you sure you want to delete this Food Category ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    sucess.tag = 12;
    [sucess show];
    sucess = nil;
}

-(void)dataDelete
{
    bool bScuees;
    bScuees =[dbmanager.fmDatabase executeUpdate:@"DELETE FROM foodCategory WHERE foodCategoryName = ?",dbmanager.tempStorageValues];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self backClicked];
    }
    if ((alertView.tag == 12)&&(buttonIndex == 0))
    {
        [self dataDelete];
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
    foodCategoryImage.image = selectedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
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
