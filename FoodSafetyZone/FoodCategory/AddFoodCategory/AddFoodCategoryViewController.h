//
//  AddFoodCategoryViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 05/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AddFoodCategoryViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    DBManager *dbManager;
}
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIImageView *foodCategoryImage;
@property (strong, nonatomic) IBOutlet UITextField *foodCategoryNameField;
@property (strong, nonatomic) IBOutlet UITextField *minTempField;
@property (strong, nonatomic) IBOutlet UITextField *maxTempField;
- (IBAction)AddImageClicked:(id)sender;

@end
