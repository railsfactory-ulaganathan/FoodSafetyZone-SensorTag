//
//  FoodCategoryViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 05/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DBManager.h"
#import "GridViewCell.h"
#import "AddFoodCategoryViewController.h"
#import "EditFoodCategoryViewController.h"


@interface FoodCategoryViewController : UIViewController
{
    NSMutableArray	*filteredListContent;
    NSMutableArray  *filteredImagesList;
    NSMutableArray  *filteredTimerStatus;
    NSMutableArray	*listContent;
    NSMutableArray  *ImagesList;
    NSMutableArray  *timerStatus;
    
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    DBManager *dbmanager;

}
@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSMutableArray *filteredImagesList;
@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *ImagesList;
@property (nonatomic, retain) NSMutableArray *timerStatus;
@property (nonatomic, retain) NSMutableArray *filteredTimerStatus;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@end
