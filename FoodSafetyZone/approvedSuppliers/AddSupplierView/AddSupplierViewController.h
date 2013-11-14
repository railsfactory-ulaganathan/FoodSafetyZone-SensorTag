//
//  AddSupplierViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 08/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AddSupplierViewController : UIViewController
{
    DBManager *dbManager;
    NSMutableArray      *sectionTitleArray;
    NSMutableDictionary *sectionContentDict;
    NSMutableArray      *arrayForBool;
}
@property (strong, nonatomic) IBOutlet UITableView *foodItemTable;
@property (strong, nonatomic) IBOutlet UIImageView *supplierImage;
@property (strong, nonatomic) IBOutlet UILabel *supplierName;

@end
