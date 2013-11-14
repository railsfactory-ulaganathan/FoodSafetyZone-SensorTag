//
//  ReportsDisplayViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 24/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
@interface ReportsDisplayViewController : UITableViewController<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
{
    DBManager *dbmanager;
    NSMutableArray *unitNames;
    NSMutableArray *time;
    NSMutableArray *temp;
    NSMutableArray *correctiveActions;
    NSMutableArray *rangeStatus;
    NSMutableString *tempStorageValues;
}
@property(nonatomic,strong)NSMutableArray *unitNames;
@property(nonatomic,strong) NSMutableArray *time;
@property(nonatomic,strong)NSMutableArray *temp;
@property(nonatomic,strong)NSMutableArray *correctiveActions;
@property(nonatomic,strong)NSMutableArray *rangeStatus;


@end
