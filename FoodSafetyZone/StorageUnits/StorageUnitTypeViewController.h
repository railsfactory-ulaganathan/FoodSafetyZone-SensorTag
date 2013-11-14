//
//  StorageUnitTypeViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 20/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface StorageUnitTypeViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate,NSURLConnectionDelegate>
{
    NSMutableArray	*filteredListContent;
    NSMutableArray	*listContent;
    NSMutableArray *idForList;
    NSMutableArray *filteredId;
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    DBManager *dbmanager;
}

@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *idForList;
@property (nonatomic, retain) NSMutableArray *filteredId;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@end
