//
//  MenuViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 15/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "MenuViewController.h"
#import "MasterViewController.h"
#import "ReportsViewController.h"
#import "TimeLogsViewController.h"
#import "SettingsViewController.h"
#import "ApprovedSuppliersViewController.h"
#import "SyncApiData.h"
#import "StorageUnitGridViewController.h"
#import "AddSuppliersViewController.h"
#import "GRSupplierListViewController.h"
#import "EquipmentsListViewController.h"
#import "CSListViewController.h"
#import "ALListViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize menuScroll,scrollBackView;

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
    
    self.navigationItem.title = @"SAFETY FOOD ZONE";
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // SyncApiData *sync = [[SyncApiData alloc]init];
   // [sync getDataFromApi];
//    dbmanager = [DBManager sharedInstance];
//    NSString *lastDate;
//    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM syncfreq"];
//    while([dbmanager.fmResults next])
//    {
//    lastDate= [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"lastSyncDate"]];
//    }
//
//    if (lastDate) {
//        NSString*currentDate= [NSString stringWithFormat:@"%@",[NSDate date]];
//        NSArray *new = [currentDate componentsSeparatedByString:@" "];
//        currentDate=  [new objectAtIndex:0];
//        
//        
//             
//        NSDateFormatter *f = [[NSDateFormatter alloc] init];
//        [f setDateFormat:@"yyyy-MM-dd"];
//        NSDate *startDate = [f dateFromString:currentDate];
//        NSDate *endDate = [f dateFromString:lastDate];
//        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
//                                                            fromDate:startDate
//                                                              toDate:endDate
//                                                             options:0];
//        int diff=[components day];
//        if (diff>7) {
//            
//            
//            
//        }
//        
//    }
//    else{
//        NSString*currentDate= [NSString stringWithFormat:@"%@",[NSDate date]];
//        NSArray *new = [currentDate componentsSeparatedByString:@" "];
//
//        bool status = [dbmanager.fmDatabase  executeUpdate:@"INSERT INTO syncfreq(lastSyncDate) VALUES(?)",[NSString stringWithFormat:@"%@",[new objectAtIndex:0]], nil];
//    }
    
    self.navigationController.navigationBarHidden = NO;
    [menuScroll addSubview:scrollBackView];
    menuScroll.contentSize = scrollBackView.frame.size;
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(0, 0, 60, 40);
    [logoutButton setImage:[UIImage imageNamed:@"logout-button.png"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(LogoutClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *riteBarButton = [[UIBarButtonItem alloc]initWithCustomView:logoutButton];
    self.navigationItem.rightBarButtonItem = riteBarButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)approvedSupplierClicked:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            ApprovedSuppliersViewController *approvedSuppliers = [[ApprovedSuppliersViewController alloc]initWithNibName:@"ApprovedSuppliersViewController" bundle:nil];
            [self.navigationController pushViewController:approvedSuppliers animated:YES];
            approvedSuppliers = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            ApprovedSuppliersViewController *approvedSuppliers = [[ApprovedSuppliersViewController alloc]initWithNibName:@"ApprovedSuppliersViewController5" bundle:nil];
            [self.navigationController pushViewController:approvedSuppliers animated:YES];
            approvedSuppliers = nil;
        }
    }
}

- (IBAction)goodsReceivingClicked:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            GRSupplierListViewController *suppliersList = [[GRSupplierListViewController alloc]initWithNibName:@"GRSupplierListViewController" bundle:nil];
            [self.navigationController pushViewController:suppliersList animated:YES];
            suppliersList = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            GRSupplierListViewController *suppliersList = [[GRSupplierListViewController alloc]initWithNibName:@"GRSupplierListViewController5" bundle:nil];
            [self.navigationController pushViewController:suppliersList animated:YES];
            suppliersList = nil;
        }
    }
}

- (IBAction)storageUnitsClicked:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            StorageUnitGridViewController *storageUnits = [[StorageUnitGridViewController alloc]initWithNibName:@"StorageUnitGridViewController" bundle:nil];
            [self.navigationController pushViewController:storageUnits animated:YES];
            storageUnits = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            StorageUnitGridViewController *storageUnits = [[StorageUnitGridViewController alloc]initWithNibName:@"StorageUnitGridViewController5" bundle:nil];
            [self.navigationController pushViewController:storageUnits animated:YES];
            storageUnits = nil;
        }
    }
}

- (IBAction)timeLogsClicked:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            TimeLogsViewController *timelog = [[TimeLogsViewController alloc]initWithNibName:@"TimeLogsViewController" bundle:nil];
            [self.navigationController pushViewController:timelog animated:YES];
            timelog = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            TimeLogsViewController *timelog = [[TimeLogsViewController alloc]initWithNibName:@"TimeLogsViewController5" bundle:nil];
            [self.navigationController pushViewController:timelog animated:YES];
            timelog = nil;
        }
    }

}

- (IBAction)equipCalibClicked:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            EquipmentsListViewController *equip = [[EquipmentsListViewController alloc]initWithNibName:@"EquipmentsListViewController" bundle:nil];
            [self.navigationController pushViewController:equip animated:YES];
            equip = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            EquipmentsListViewController *equip = [[EquipmentsListViewController alloc]initWithNibName:@"EquipmentsListViewController5" bundle:nil];
            [self.navigationController pushViewController:equip animated:YES];
            equip = nil;
        }
    }

}

- (IBAction)activityLogsClicked:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            ALListViewController *reports = [[ALListViewController alloc]initWithNibName:@"ALListViewController" bundle:nil];
            [self.navigationController pushViewController:reports animated:YES];
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            ALListViewController *reports = [[ALListViewController alloc]initWithNibName:@"ALListViewController5" bundle:nil];
            [self.navigationController pushViewController:reports animated:YES];
        }
    }

}

- (IBAction)cleaningScheduleClicked:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            CSListViewController *CSList = [[CSListViewController alloc]initWithNibName:@"CSListViewController" bundle:nil];
            [self.navigationController pushViewController:CSList animated:YES];
            CSList = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            CSListViewController *CSList = [[CSListViewController alloc]initWithNibName:@"CSListViewController5" bundle:nil];
            [self.navigationController pushViewController:CSList animated:YES];
            CSList = nil;
        }
    }

}

- (IBAction)mastersClicked:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            MasterViewController *master = [[MasterViewController alloc]initWithNibName:@"MasterViewController" bundle:nil];
            [self.navigationController pushViewController:master animated:YES];
            master = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            MasterViewController *master = [[MasterViewController alloc]initWithNibName:@"MasterViewController5" bundle:nil];
            [self.navigationController pushViewController:master animated:YES];
            master = nil;
        }
    }
}

- (IBAction)settingsClicked:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            SettingsViewController *settings = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
            [self.navigationController pushViewController:settings animated:YES];
            settings = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            SettingsViewController *settings = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController5" bundle:nil];
            [self.navigationController pushViewController:settings animated:YES];
            settings = nil;
        }
    }

}

- (IBAction)reportsClicked:(id)sender
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            ReportsViewController *reports = [[ReportsViewController alloc]initWithNibName:@"ReportsViewController" bundle:nil];
            [self.navigationController pushViewController:reports animated:YES];
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            ReportsViewController *reports = [[ReportsViewController alloc]initWithNibName:@"ReportsViewController5" bundle:nil];
            [self.navigationController pushViewController:reports animated:YES];
        }
    }
}

- (IBAction)helpClicked:(id)sender {
}

-(void)LogoutClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
