//
//  ApprovedSuppliersViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 07/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DBManager.h"
#import "GridViewCell.h"

@interface ApprovedSuppliersViewController : UIViewController<UISearchBarDelegate,UIAlertViewDelegate>
{
    NSMutableArray	*filteredListContent;
    NSMutableArray  *filteredImagesList;
    NSMutableArray  *filteredTimerStatus;
    NSMutableArray	*listContent;
    NSMutableArray  *ImagesList;
    NSMutableArray  *timerStatus;
    NSMutableArray  *allIDS;
    NSMutableArray  *filteredIDS;
    
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    DBManager *dbmanager;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UISearchBar *search;

@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSMutableArray *filteredImagesList;
@property (nonatomic, retain) NSMutableArray *filteredIDS;
@property (nonatomic, retain) NSMutableArray *allIDS;
@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *ImagesList;
@property (nonatomic, retain) NSMutableArray *timerStatus;
@property (nonatomic, retain) NSMutableArray *filteredTimerStatus;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@end
