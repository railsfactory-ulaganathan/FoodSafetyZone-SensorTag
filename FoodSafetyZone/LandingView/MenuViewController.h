//
//  MenuViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 15/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
@interface MenuViewController : UIViewController
{
    DBManager *dbmanager;
}
@property (strong, nonatomic) IBOutlet UIScrollView *menuScroll;
- (IBAction)approvedSupplierClicked:(id)sender;
- (IBAction)goodsReceivingClicked:(id)sender;
- (IBAction)storageUnitsClicked:(id)sender;
- (IBAction)timeLogsClicked:(id)sender;
- (IBAction)equipCalibClicked:(id)sender;
- (IBAction)activityLogsClicked:(id)sender;
- (IBAction)cleaningScheduleClicked:(id)sender;
- (IBAction)mastersClicked:(id)sender;
- (IBAction)settingsClicked:(id)sender;
- (IBAction)reportsClicked:(id)sender;
- (IBAction)helpClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *scrollBackView;
@end
