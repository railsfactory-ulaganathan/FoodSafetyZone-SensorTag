//
//  AddStorageUnitTypeViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 20/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "AddStorageUnitTypeViewController.h"

@interface AddStorageUnitTypeViewController ()

@end

@implementation AddStorageUnitTypeViewController
@synthesize unitTypeField,minTempField,maxTempField;

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
    self.navigationItem.title = @"UNIT TYPE";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [DBManager sharedInstance];
    // Do any additional setup after loading the view from its nib.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 2 || textField.tag == 3)
    {
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barStyle = UIBarStyleBlackTranslucent;
        [numberToolbar setBackgroundImage:[UIImage imageNamed:@"header-bg-1.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        done.frame = CGRectMake(0, 0, 50, 40);
        [done addTarget:self action:@selector(DoneNumberPad) forControlEvents:UIControlEventTouchUpInside];
        [done setImage:[UIImage imageNamed:@"new-done.png"] forState:UIControlStateNormal];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithCustomView:done];
        textField.inputAccessoryView = numberToolbar;
        [barItems addObject:flexSpace];
        
        [numberToolbar setItems:barItems animated:YES];
        
        [numberToolbar sizeToFit];

    }
}

-(void)DoneNumberPad
{
    [minTempField resignFirstResponder];
    [maxTempField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)doneClicked
{
    
    NSString *validations = [[NSString alloc]init];
    if ([unitTypeField.text length]<=0)
    {
        validations = [validations stringByAppendingFormat:@"Unit Type cannot be empty!"];
    }
    if ([minTempField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n Minimum temperature cannot be empty!"];
    }
    if ([maxTempField.text length] <= 0)
    {
        validations = [validations stringByAppendingFormat:@"\n Maximum temperature cannot be empty!"];
    }
    if ([maxTempField.text intValue] < [minTempField.text intValue])
    {
         validations = [validations stringByAppendingFormat:@"\n Maximum temperature cannot be less than Minimum temperature!"];
    }
    if ([validations length]>0)
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:validations delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
    }
    
    else
    {
        BOOL status;
        status = [dbManager.fmDatabase  executeUpdate:@"INSERT INTO AddStorageUnitType(storageUnitType,minTemp,maxTemp,id) VALUES(?,?,?,NULL)",unitTypeField.text,[NSNumber numberWithFloat:[minTempField.text floatValue]],[NSNumber numberWithFloat:[maxTempField.text floatValue]],nil];
        
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Storage Unit Type created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            sucess.tag = 1;
            [sucess show];
        }
        else
        {
            NSString *alertValue = [[NSString alloc]init];
            if ([dbManager.fmDatabase hadError]) {
                if ([dbManager.fmDatabase lastErrorCode]==19)
                {
                    alertValue = [NSString stringWithFormat:@"Unit Type Name already taken!"];
                }
                UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:alertValue delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                sucess.tag = 1;
                [sucess show];
            }
        }
        NSLog(@"%c",status);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
