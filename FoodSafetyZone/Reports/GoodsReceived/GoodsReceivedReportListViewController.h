//
//  GoodsReceivedReportListViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 14/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "DBManager.h"
#import "GRTableHeader.h"
#import "GRTableRow.h"

@interface GoodsReceivedReportListViewController : UITableViewController<MFMailComposeViewControllerDelegate>
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
