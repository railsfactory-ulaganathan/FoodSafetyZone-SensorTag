//
//  StorageUnitTypeEditViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 02/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "StorageUnitTypeEditViewController.h"

@interface StorageUnitTypeEditViewController ()

@end

@implementation StorageUnitTypeEditViewController
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
    self.navigationItem.title = @"STORAGE UNITS";

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbmanager = [DBManager sharedInstance];
    [self loadDataForView];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadDataForView
{
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM AddStorageUnitType WHERE id = (?)",dbmanager.tempStorageValues];
    while([dbmanager.fmResults next])
    {
        unitTypeField.text = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"storageUnitType"]];
        minTempField.text = [NSString stringWithFormat:@"%.2f",[dbmanager.fmResults doubleForColumn:@"minTemp"]];
        maxTempField.text = [NSString stringWithFormat:@"%.2f",[dbmanager.fmResults doubleForColumn:@"maxTemp"]];
    }
}

-(void)doneClicked
{
    NSString *errorString;
    if ([unitTypeField.text length]<=0)
    {
        errorString = [errorString stringByAppendingFormat:@"Unit Type can not be empty!"];
    }
    if ([minTempField.text length]<=0)
    {
        errorString = [errorString stringByAppendingFormat:@"\n Minimum temp cannot be empty!"];
    }
    if ([maxTempField.text length]<=0)
    {
        errorString = [errorString stringByAppendingFormat:@"\n Maximum temp cannot be empty!"];
    }
    
    if ([errorString length]<=0)
    {
        BOOL status;
        status =[dbmanager.fmDatabase executeUpdate:@"update AddStorageUnitType set storageUnitType = ?, minTemp = ?, maxTemp = ? where id =?",  unitTypeField.text,minTempField.text,maxTempField.text,dbmanager.tempStorageValues];
        NSLog(@"%c",status);

        
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Storage Unit Type edited" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            sucess.tag = 1;
            [sucess show];
        }
        else
        {
            NSString *alertValue = [[NSString alloc]init];
            if ([dbmanager.fmDatabase hadError]) {
                NSLog(@"%@",[dbmanager.fmDatabase lastErrorMessage]);
                if ([dbmanager.fmDatabase lastErrorCode]==19)
                {
                    alertValue = [NSString stringWithFormat:@"Unit Type Name already taken!"];
                }
                UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:alertValue delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [sucess show];
            }
        }

    }
    else
    {
        UIAlertView *validation = [[UIAlertView alloc]initWithTitle:@"Alert" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [validation show];
    }
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
