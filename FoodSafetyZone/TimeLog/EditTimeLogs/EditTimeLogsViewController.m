//
//  EditTimeLogsViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 27/09/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "EditTimeLogsViewController.h"
#define SOURCETYPE UIImagePickerControllerSourceTypeCamera

@interface EditTimeLogsViewController ()
{
    int tftag;
}

@end

@implementation EditTimeLogsViewController
@synthesize foodItemImage,foodNameField,foodTempField,activityField,mainScroll,backView;

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
    self.navigationItem.title = @"TIME LOG";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 40);
    [addButton setImage:[UIImage imageNamed:@"new-done.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    addButton = nil;
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
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search.png"]forState:UIControlStateNormal];
    [self loadDataForPage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [DBManager sharedInstance];
    mainScroll.contentSize = CGSizeMake(320, self.view.frame.size.height);
    activityArray = [[NSMutableArray alloc]init];
    foodTempArray = [[NSMutableArray alloc]initWithObjects:@"Hot food",@"Cold food", nil];
    [foodItemImage setContentMode:UIViewContentModeRedraw];
    [mainScroll addSubview:backView];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadDataForPage
{
    dbManager.fmResults=[dbManager.fmDatabase executeQuery:@"SELECT * FROM FoodItem WHERE foodName = ?",dbManager.tempStorageValues];
    while([dbManager.fmResults next])
    {
        foodNameField.text = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodName"]];
        activityField.text = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"purposeName"]];
        foodTempField.text = [NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"foodTemp"]];
        NSData *tempImgData = [dbManager.fmResults dataForColumn:@"foodImage"];
        [foodItemImage setImage:[UIImage imageWithData:tempImgData]];
        tempImgData = nil;
        selectedID = [dbManager.fmResults intForColumn:@"id"];
        purposeID = [dbManager.fmResults intForColumn:@"purposeId"];
    }
    
    if (activityArray)
    {
        [activityArray removeAllObjects];
    }
    dbManager.fmResults = [dbManager.fmDatabase executeQuery:@"SELECT * FROM Purpose"];
    while ([dbManager.fmResults next])
    {
        [activityArray addObject:[NSString stringWithFormat:@"%@",[dbManager.fmResults stringForColumn:@"purposeName"]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneClicked
{
    NSString *validations = [[NSString alloc]init];
    if ([foodNameField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Storage Unit Name cannot be empty!"];
    }
    if ([foodTempField.text length] <= 0)
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
        int j = 0;
        NSData *imgData = UIImageJPEGRepresentation(foodItemImage.image, 50);
        
        status = [dbManager.fmDatabase  executeUpdate:@"UPDATE FoodItem SET  foodName = ?, purposeName = ?, foodTemp = ?, foodImage = ?,  purposeId = ?, startTime = ?, startStatus = ? WHERE id = ?", [NSString stringWithFormat:@"%@",foodNameField.text],[NSString stringWithFormat:@"%@",activityField.text],[NSString stringWithFormat:@"%@",foodTempField.text],imgData,[NSNumber numberWithInt:purposeID],[NSString stringWithFormat:@"%@",[NSDate date]],[NSNumber numberWithInt:j],[NSNumber numberWithInt:selectedID]];
        imgData = nil;
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Food Item edited !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            sucess.tag = 1;
            [sucess show];
            sucess = nil;
            dbManager.tempStorageValues = [NSMutableString stringWithFormat:@"%@",foodNameField.text];
            [self backClicked];
        }
        else
        {
            if ([dbManager.fmDatabase hadError])
            {
                NSLog(@"%d",[dbManager.fmDatabase lastErrorCode]);
                UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:[dbManager.fmDatabase lastErrorMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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

- (IBAction)addPhotoClicked:(id)sender
{
    UIActionSheet *selectionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery",@"Cancel", nil];
    selectionSheet.tag = 2;
    [selectionSheet showInView:self.view];
    selectionSheet = nil;
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
    [self createPicker];
}

- (IBAction)foodTempButtonClicked:(UIButton *)sender
{
    tftag = sender.tag;
    CGPoint scrollPoint;
    CGRect inputFieldBounds = [sender bounds];
    inputFieldBounds = [sender convertRect:inputFieldBounds toView:mainScroll];
    scrollPoint = inputFieldBounds.origin;
    scrollPoint.x = 0;
    scrollPoint.y -= 100; // you can customize this value
    [mainScroll setContentOffset:scrollPoint animated:YES];
    [self createPicker];
}

-(void)pickerClosingAnimation
{
    CGPoint scrollPoint;
    scrollPoint.x = 0;
    scrollPoint.y = 0;
    [mainScroll setContentOffset:scrollPoint animated:YES];
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
        return [activityArray count];
    }
    else
    {
        return [foodTempArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (tftag == 1)
    {
        return  [activityArray objectAtIndex:row];
    }
    else
    {
        return  [foodTempArray objectAtIndex:row];
    }
}

-(void)DatePickerDoneClick
{
    [self pickerClosingAnimation];
    if (tftag == 1)
    {
        activityField.text = [NSString stringWithFormat:@"%@",[activityArray objectAtIndex:[picker selectedRowInComponent:0]]];
    }
    else
    {
        foodTempField.text = [NSString stringWithFormat:@"%@",[foodTempArray objectAtIndex:[picker selectedRowInComponent:0]]];
    }
    [activityField resignFirstResponder];
    [foodNameField resignFirstResponder];
    [foodTempField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)CancelPickerDoneClick
{
    [self pickerClosingAnimation];
    [activityField resignFirstResponder];
    [foodNameField resignFirstResponder];
    [foodTempField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
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
    [self pickerClosingAnimation];
    [textField resignFirstResponder];
    return  YES;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"INFO %@",info);
    selectedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.foodItemImage.image = selectedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
