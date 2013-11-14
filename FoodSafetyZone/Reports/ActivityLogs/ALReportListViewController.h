//
//  ALReportListViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 28/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "DBManager.h"
#import "ALTableHeader.h"
#import "ALTableRow.h"

@interface ALReportListViewController : UITableViewController<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
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
@end
