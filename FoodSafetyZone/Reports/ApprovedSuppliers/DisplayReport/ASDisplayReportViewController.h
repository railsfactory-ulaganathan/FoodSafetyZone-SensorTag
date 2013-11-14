//
//  ASDisplayReportViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 10/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ASDisplayReportViewController : UIViewController
{
    DBManager *dbManager;
    NSMutableArray      *sectionTitleArray;
    NSMutableDictionary *sectionContentDict;
    NSMutableArray      *arrayForBool;
    NSMutableString *tempStorageValues;
}
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UITableView *foodItemTable;
@property (strong, nonatomic) IBOutlet UILabel *supplierName;
@property (strong, nonatomic) IBOutlet UILabel *addressNPhone;
@property (strong, nonatomic) IBOutlet UILabel *supplyStartDate;
@property (strong, nonatomic) IBOutlet UILabel *otherInfo;

@property (strong, nonatomic) IBOutlet UIView *backView;
@end
