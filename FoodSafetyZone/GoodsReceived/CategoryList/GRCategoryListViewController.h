//
//  GRCategoryListViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 09/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GridViewCell.h"
#import "DBManager.h"
#import "GRFoodItemListViewController.h"

@interface GRCategoryListViewController : UIViewController
{
    NSMutableArray	*filteredListContent;
    NSMutableArray  *filteredImagesList;
    NSMutableArray	*listContent;
    NSMutableArray  *ImagesList;
    
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    DBManager *dbmanager;

}

@property (strong, nonatomic) IBOutlet UILabel *supplierNameLbl;
@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSMutableArray *filteredImagesList;
@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *ImagesList;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@end
