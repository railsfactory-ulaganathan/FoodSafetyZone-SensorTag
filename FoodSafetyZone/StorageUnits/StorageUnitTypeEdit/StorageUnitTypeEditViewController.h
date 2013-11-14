//
//  StorageUnitTypeEditViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 02/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface StorageUnitTypeEditViewController : UIViewController<UIAlertViewDelegate>
{
     DBManager *dbmanager;
}
@property (strong, nonatomic) IBOutlet UITextField *unitTypeField;
@property (strong, nonatomic) IBOutlet UITextField *minTempField;
@property (strong, nonatomic) IBOutlet UITextField *maxTempField;

@end
