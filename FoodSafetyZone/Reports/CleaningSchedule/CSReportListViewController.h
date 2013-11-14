//
//  CSReportListViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 22/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "CSTableHeader.h"
#import "CSTableRow.h"
#import "DBManager.h"

@interface CSReportListViewController : UITableViewController<MFMailComposeViewControllerDelegate>
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
