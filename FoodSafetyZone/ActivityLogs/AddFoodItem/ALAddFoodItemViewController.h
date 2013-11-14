//
//  ALAddFoodItemViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 23/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ALAddFoodItemViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    DBManager *dbManager;
    NSMutableString *selectedActivities;
    NSMutableArray *selButtons;
}

@property (strong, nonatomic) IBOutlet UIButton *foodImage;
@property (strong, nonatomic) IBOutlet UITextField *foodNameField;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIButton *preparation;
@property (strong, nonatomic) IBOutlet UIButton *cookingfood;
@property (strong, nonatomic) IBOutlet UIButton *coolingfood;
@property (strong, nonatomic) IBOutlet UIButton *reheating;
@property (strong, nonatomic) IBOutlet UIButton *hotholding;
@property (strong, nonatomic) IBOutlet UIButton *serving;
@property (strong, nonatomic) IBOutlet UIButton *foodpacking;


- (IBAction)optionSelected:(UIButton *)sender;
- (IBAction)addPhotoClicked:(UIButton *)sender;
@end
