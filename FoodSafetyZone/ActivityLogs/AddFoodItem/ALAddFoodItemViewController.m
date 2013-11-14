//
//  ALAddFoodItemViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 23/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ALAddFoodItemViewController.h"
#define SOURCETYPE UIImagePickerControllerSourceTypeCamera

@interface ALAddFoodItemViewController ()
{
    UIImage *selectedImage;
}

@end

@implementation ALAddFoodItemViewController
@synthesize mainScroll,backView,foodImage,foodNameField;
@synthesize preparation,cookingfood,coolingfood,reheating,hotholding,serving,foodpacking;

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
    self.navigationItem.title = @"ACTIVITY LOGS";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainScroll.contentSize = backView.bounds.size;
    [mainScroll addSubview:backView];
    dbManager = [DBManager sharedInstance];
    selectedActivities = [[NSMutableString alloc] init];
    selButtons = [[NSMutableArray alloc]init];
    [selButtons addObject:preparation];
    [selButtons addObject:cookingfood];
    [selButtons addObject:coolingfood];
    [selButtons addObject:reheating];
    [selButtons addObject:hotholding];
    [selButtons addObject:serving];
    [selButtons addObject:foodpacking];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)editClicked:(UIButton *)sender
{
    
}

- (IBAction)addPhotoClicked:(UIButton *)sender
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
    [foodImage setImage:selectedImage forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)doneClicked
{
    
    for (int jk = 0;  jk < [selButtons count]; jk++)
    {
        UIButton *tempBut = [selButtons objectAtIndex:jk];
        if (tempBut.currentImage == [UIImage imageNamed:@"checkbox_select.png"])
        {
            switch (tempBut.tag)
            {
                case 1:
                {
                    [selectedActivities appendString:[NSString stringWithFormat:@"((/Preparation))"]];
                }
                    break;
                case 2:
                {
                    [selectedActivities appendString:[NSString stringWithFormat:@"((/Cooking food))"]];
                }
                    break;
                case 3:
                {
                    [selectedActivities appendString:[NSString stringWithFormat:@"((/Cooling food))"]];
                }
                    break;
                case 4:
                {
                    [selectedActivities appendString:[NSString stringWithFormat:@"((/Reheating))"]];
                }
                    break;
                case 5:
                {
                    [selectedActivities appendString:[NSString stringWithFormat:@"((/Hot holding))"]];
                }
                    break;
                case 6:
                {
                    [selectedActivities appendString:[NSString stringWithFormat:@"((/Serving))"]];
                }
                    break;
                case 7:
                {
                    [selectedActivities appendString:[NSString stringWithFormat:@"((/Food packing))"]];
                }
                    break;
            }
        }
        tempBut = nil;
    }
    
    
    NSString *validations = [[NSString alloc]init];
    if ([foodNameField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Food Name cannot be empty!"];
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
        NSData *imgData = UIImageJPEGRepresentation(foodImage.currentImage, 50);
        
        status = [dbManager.fmDatabase  executeUpdate:@"INSERT INTO activityLogFoodItem(id,foodName,foodImage,activity) VALUES(NULL,?,?,?)",foodNameField.text,imgData,selectedActivities,nil];
        imgData = nil;
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Food item created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
                    alertValue = [NSString stringWithFormat:@"Food  Name already taken!"];
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
    scrollPoint.x = 0;
    scrollPoint.y = 0;// you can customize this value
    [mainScroll  setContentOffset:scrollPoint animated:YES];
    return YES;
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFoodImage:nil];
    [self setFoodNameField:nil];
    [self setMainScroll:nil];
    [self setBackView:nil];
    [self setPreparation:nil];
    [self setCookingfood:nil];
    [self setCoolingfood:nil];
    [self setReheating:nil];
    [self setHotholding:nil];
    [self setServing:nil];
    [self setFoodpacking:nil];
    [super viewDidUnload];
}

- (IBAction)optionSelected:(UIButton *)sender
{
    if (sender.currentImage == [UIImage imageNamed:@"checkbox.png"])
    {
        [sender setImage:[UIImage imageNamed:@"checkbox_select.png"] forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
}

-(void)cutString:(NSString *)sender
{
    NSRange r;
    for(int i = 0; i < [selectedActivities length]; i++)
    {
        //findout the range with "sub" string
        r = [selectedActivities rangeOfString:sender options:NSCaseInsensitiveSearch];
        
        if(r.location != NSNotFound)
        {
            //Delete the characters in that range
            [selectedActivities deleteCharactersInRange:r];
        }
        else
        {
            //break the loop if sub string not found as there is no more recurrence.
            break;
        }
    }
    NSLog(@"----->>>>>> %@ ",selectedActivities);
}

@end
