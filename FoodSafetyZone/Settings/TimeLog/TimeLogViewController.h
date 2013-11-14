//
//  TimeLogViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 20/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import <QuartzCore/QuartzCore.h>

@interface TimeLogViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>
{
    NSMutableArray	*filteredListContent;
    NSMutableArray	*listContent;
    NSMutableArray *idForList;
    NSMutableArray *filteredId;
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    DBManager *dbmanager;
    NSString *selectedPurpose;
    UITapGestureRecognizer *overlayViewTapped;
}

@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *idForList;
@property (nonatomic, retain) NSMutableArray *filteredId;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property (strong, nonatomic) IBOutlet UIView *addPurposeView;
@property (strong, nonatomic) IBOutlet UILabel *addPurposeHeaderLbl;
@property (strong, nonatomic) IBOutlet UITextField *addPurposeTextField;
@property (strong, nonatomic) IBOutlet UIButton *addPurposeDoneButton;
- (IBAction)addPurposeDoneCicked:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *editPurposeView;

@property (strong, nonatomic) IBOutlet UILabel *editPurposeHeaderLbl;
@property (strong, nonatomic) IBOutlet UITextField *editPurposeTextField;
@property (strong, nonatomic) IBOutlet UIButton *editPurposeDoneButton;
@property (strong, nonatomic) IBOutlet UIButton *editPurposeDeleteButton;
- (IBAction)editPurposeDoneClicked:(UIButton *)sender;
- (IBAction)editPurposeDeleteClicked:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *overlayView;
- (IBAction)CloseClicked:(id)sender;
@end
