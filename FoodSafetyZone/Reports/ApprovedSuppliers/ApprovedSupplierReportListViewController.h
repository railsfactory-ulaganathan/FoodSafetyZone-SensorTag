//
//  ApprovedSupplierReportListViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 07/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "ApprovedSupplierTblHeader.h"
#import "ApprovedSupplierTblRow.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@interface ApprovedSupplierReportListViewController : UITableViewController<MFMailComposeViewControllerDelegate>
{
    DBManager *dbmanager;
    UIView *GeneratePDF;
    NSMutableArray *listOfSuppliers;
    NSMutableArray *listOfRecords;
    UITextField *myTextField;
    int totalRows,totalColumns,xpos,ypos,cellWidth,cellHeight,viewTags;
    
    NSMutableArray *allIds;
    NSMutableArray *rowwise;
    NSMutableArray *listOfFoodItems;
    NSMutableArray *allViews;
}

@property (strong, nonatomic) IBOutlet UIView *TLHeaderView;
@property (strong, nonatomic) IBOutlet UIView *TLFooterView;
@end
