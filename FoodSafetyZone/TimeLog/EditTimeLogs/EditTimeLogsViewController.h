//
//  EditTimeLogsViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 27/09/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface EditTimeLogsViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    DBManager *dbManager;
    
    UIActionSheet *actionSheet;
    UIToolbar *toolBar;
    UIPickerView *picker;
    NSMutableArray *activityArray;
    NSMutableArray *foodTempArray;
    UIImage *selectedImage;
    int selectedID,purposeID;
}
@property (strong, nonatomic) IBOutlet UIImageView *foodItemImage;
@property (strong, nonatomic) IBOutlet UITextField *foodNameField;
@property (strong, nonatomic) IBOutlet UITextField *activityField;
@property (strong, nonatomic) IBOutlet UITextField *foodTempField;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *backView;

- (IBAction)addPhotoClicked:(id)sender;
- (IBAction)activityButtonClicked:(UIButton *)sender;
- (IBAction)foodTempButtonClicked:(UIButton *)sender;
@end
