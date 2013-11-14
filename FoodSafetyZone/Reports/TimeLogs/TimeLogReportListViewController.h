//
//  TimeLogReportListViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 20/09/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "TimeLogTableHeader.h"
#import "TimeLogReportView.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@interface TimeLogReportListViewController : UITableViewController<MFMailComposeViewControllerDelegate>
{
    DBManager *dbmanager;
    UIView *GeneratePDF;
    NSMutableArray *listOfDates;
    NSMutableArray *listOfRecords;
    UITextField *myTextField;
    int totalRows,totalColumns,xpos,ypos,cellWidth,cellHeight,viewTags;
    
    NSMutableArray *allIds;
    NSMutableArray *rowwise;
    NSMutableArray *allViews;
}

@property (strong, nonatomic) IBOutlet UIView *TLHeaderView;
@property (strong, nonatomic) IBOutlet UIView *TLFooterView;
@end
