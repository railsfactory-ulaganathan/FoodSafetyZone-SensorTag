//
//  AddStorageUnitTypeViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 20/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AddStorageUnitTypeViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    DBManager *dbManager;
}

@property (strong, nonatomic) IBOutlet UITextField *unitTypeField;
@property (strong, nonatomic) IBOutlet UITextField *minTempField;
@property (strong, nonatomic) IBOutlet UITextField *maxTempField;
@end
