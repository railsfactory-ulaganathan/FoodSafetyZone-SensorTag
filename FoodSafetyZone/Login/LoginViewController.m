//
//  LoginViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 01/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "LoginViewController.h"
#import "MenuViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginClicked:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if (iOSDeviceScreenSize.height == 480)
        {
            MenuViewController *menu = [[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
            [self.navigationController pushViewController:menu animated:YES];
            menu = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            MenuViewController *menu = [[MenuViewController alloc]initWithNibName:@"MenuViewController5" bundle:nil];
            [self.navigationController pushViewController:menu animated:YES];
            menu = nil;
        }
    }

}
@end
