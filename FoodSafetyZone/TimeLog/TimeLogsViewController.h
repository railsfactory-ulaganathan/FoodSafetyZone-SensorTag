//
//  TimeLogsViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 20/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import <QuartzCore/QuartzCore.h>

@interface TimeLogsViewController : UIViewController<UISearchBarDelegate,UIAlertViewDelegate>
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

@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSMutableArray *filteredImagesList;
@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *ImagesList;
@property (nonatomic, retain) NSMutableArray *timerStatus;
@property (nonatomic, retain) NSMutableArray *filteredTimerStatus;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;

@end
