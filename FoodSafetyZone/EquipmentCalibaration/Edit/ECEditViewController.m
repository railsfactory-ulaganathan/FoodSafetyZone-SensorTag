//
//  ECEditViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 21/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ECEditViewController.h"
#define SOURCETYPE UIImagePickerControllerSourceTypeCamera

@interface ECEditViewController ()
{
    UIImage *selectedImage;
}

@end

@implementation ECEditViewController
@synthesize equipmentNameField,equipmentImage,mainScroll,backView;

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
    self.navigationItem.title = @"EQUIPMENTS";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainScroll.contentSize = backView.bounds.size;
    [mainScroll addSubview:backView];
    dbManager = [DBManager sharedInstance];
    [self loadDataForPage];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadDataForPage
{
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbManager.fmResults next])
    {
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM Equipments WHERE id = ?",[NSNumber numberWithInt:[tempStorageValues integerValue]]];
    while([dbManager.fmResults next])
    {
        equipmentNameField.text = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"equipmentName"]];
        NSData *tempData = [dbManager.fmResults dataForColumn:@"equipmentImage"];
        [equipmentImage setImage:[UIImage imageWithData:tempData] forState:UIControlStateNormal];
        tempData = nil;
        selectedID = [dbManager.fmResults intForColumn:@"id"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setEquipmentNameField:nil];

    [self setEquipmentImage:nil];
    [self setMainScroll:nil];
    [self setBackView:nil];
    [super viewDidUnload];
}
- (IBAction)addPhotoClicked:(id)sender
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

- (IBAction)passStatusChanged:(id)sender
{
    
}

-(void)doneClicked
{
    NSString *validations = [[NSString alloc]init];
    if ([equipmentNameField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Equipment Name cannot be empty!"];
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
        
        status = [dbManager.fmDatabase  executeUpdate:@"UPDATE Equipments SET equipmentName = ?, equipmentImage = ?  WHERE id = ?",equipmentNameField.text,imgData,[NSNumber numberWithInt:selectedID]];
        imgData = nil;
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Equipment edited" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)deleteClicked:(id)sender
{
    UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"This will delete the Equipment! \nAre you sure you want to delete this Equipment ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    sucess.tag = 12;
    [sucess show];
    sucess = nil;
}

-(void)deleteData
{
    bool bScuees;
    bScuees =[dbManager.fmDatabase executeUpdate:@"DELETE FROM Equipments WHERE id = ?",[NSNumber numberWithInt:[tempStorageValues integerValue]]];
    
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
        sucess = nil;
        alertValue = nil;
    }
    if (bScuees == YES)
    {
        [self backClicked];
    }
}

@end
