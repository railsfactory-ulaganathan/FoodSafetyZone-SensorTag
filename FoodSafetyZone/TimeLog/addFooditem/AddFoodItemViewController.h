//
//  AddFoodItemViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 20/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AddFoodItemViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    DBManager *dbManager;
    NSMutableArray *ActivityNames;
    NSMutableArray *foodTemps;
    NSMutableArray *activityId;
    
    UIActionSheet *actionSheet;
    UIToolbar *toolBar;
    UIPickerView *picker;
}
- (IBAction)activityClicked:(UIButton *)sender;
- (IBAction)foodTempClicked:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *activity;
@property (strong, nonatomic) IBOutlet UIButton *foodTemp;
@property (strong, nonatomic) IBOutlet UITextField *foodNameField;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
- (IBAction)addImageClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addImageButton;
@property (strong, nonatomic) IBOutlet UITextField *activityField;
@property (strong, nonatomic) IBOutlet UITextField *foodTempField;
@property (strong, nonatomic) IBOutlet UIButton *FoodItemImage;

@end
