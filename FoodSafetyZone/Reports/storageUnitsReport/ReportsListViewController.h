//
//  ReportsListViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 23/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import <CoreText/CoreText.h>
#import <MessageUI/MessageUI.h>

@interface ReportsListViewController : UITableViewController<MFMailComposeViewControllerDelegate>
{
    DBManager *dbmanager;
    UIView *GeneratePDF;
    NSMutableArray *listOfDates;
    NSMutableArray *listOfRecords;
    UITextField *myTextField;
    NSMutableArray *allViews;
    NSMutableArray *UnitNames;
    NSMutableArray *temperature;
    NSMutableArray *time;
    NSMutableArray *correctAction;
    NSMutableArray *dateTake;
    
    NSMutableArray *daywise;
    NSMutableArray *rowwise;
    NSMutableArray *wed;
    NSMutableArray *thu;
    NSMutableArray *fri;
    NSMutableArray *sat;
    NSMutableArray *sun;
    
    int totalRows,totalColumns,xpos,ypos,cellWidth,cellHeight,viewTags;
    
    NSMutableArray *tableHeaders;
    NSMutableArray *tableSubHeaders;
}
@property (nonatomic,strong) UIView *GeneratePDF;
@property (nonatomic,strong) NSMutableArray *allViews;

@property(nonatomic ,strong) NSMutableArray *daywise;
@property(nonatomic ,strong) NSMutableArray *rowwise;
@property(nonatomic ,strong) NSMutableArray *wed;
@property(nonatomic ,strong) NSMutableArray *thu;
@property(nonatomic ,strong) NSMutableArray *fri;
@property(nonatomic ,strong) NSMutableArray *sat;
@property(nonatomic ,strong) NSMutableArray *sun;

@property (strong, nonatomic) IBOutlet UIView *headerViewForReports;
@property (strong, nonatomic) IBOutlet UILabel *headerStartDateLbl;
@property (strong, nonatomic) IBOutlet UIView *footerViewForReports;
@property (strong, nonatomic) IBOutlet UIView *correctiveHeading;


@end
