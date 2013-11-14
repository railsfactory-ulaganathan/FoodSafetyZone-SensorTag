//
//  EditSuppliersViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 08/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface EditSuppliersViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    DBManager *dbManager;
    UIActionSheet *actionSheet;
    UIToolbar *toolBar;
    UIPickerView *picker;
    UIDatePicker *datePicker;
    NSDateFormatter *FormatDate;
    
    NSMutableArray *foodCategories;
    NSMutableArray *countries;
    NSMutableArray *states;
}

@property (strong, nonatomic) IBOutlet UIButton *foodItemButton;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIImageView *supplierImage;
@property (strong, nonatomic) IBOutlet UITextField *supplierName;
@property (strong, nonatomic) IBOutlet UITextField *streetName;
@property (strong, nonatomic) IBOutlet UITextField *provinceField;
@property (strong, nonatomic) IBOutlet UITextField *cityField;
@property (strong, nonatomic) IBOutlet UITextField *pinField;
@property (strong, nonatomic) IBOutlet UITextField *stateField;
@property (strong, nonatomic) IBOutlet UITextField *countryField;
@property (strong, nonatomic) IBOutlet UITextField *foodBusinessNoField;
@property (strong, nonatomic) IBOutlet UITextField *mobileField;
@property (strong, nonatomic) IBOutlet UITextField *workPhoneField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *supplyStartDateField;
@property (strong, nonatomic) IBOutlet UITextView *otherInformationField;
@property (strong, nonatomic) IBOutlet UITextField *foodCategoryField;
@property (strong, nonatomic) IBOutlet UITextField *foodItemField;

- (IBAction)addPhotoClicked:(UIButton *)sender;
- (IBAction)countryClicked:(UIButton *)sender;
- (IBAction)stateClicked:(UIButton *)sender;
- (IBAction)foodCategoryClicked:(UIButton *)sender;
- (IBAction)dateClicked:(UIButton *)sender;
- (IBAction)addFoodItemClicked:(UIButton *)sender;
- (IBAction)addImageFoodItemClicked:(UIButton *)sender;
- (IBAction)viewClicked:(id)sender;

- (IBAction)deleteClicked:(id)sender;
@end
