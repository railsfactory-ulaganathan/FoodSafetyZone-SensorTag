//
//  AddSuppliersViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 07/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AddSuppliersViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
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
    
    NSMutableArray *myarray;
}

@property (strong, nonatomic) IBOutlet UIButton *foodItemButton;
@property (strong, nonatomic) IBOutlet UITextView *otherInformationField;
@property (strong, nonatomic) IBOutlet UIImageView *supplierImage;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UITextField *supplierNameField;
@property (strong, nonatomic) IBOutlet UITextField *streetNameField;
@property (strong, nonatomic) IBOutlet UITextField *provinceField;
@property (strong, nonatomic) IBOutlet UITextField *cityField;
@property (strong, nonatomic) IBOutlet UITextField *pinField;
@property (strong, nonatomic) IBOutlet UITextField *victoriaField;
@property (strong, nonatomic) IBOutlet UITextField *countryField;
@property (strong, nonatomic) IBOutlet UITextField *businessNoField;
@property (strong, nonatomic) IBOutlet UITextField *mobileField;
@property (strong, nonatomic) IBOutlet UITextField *workPhoneField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UITextField *foodCategoryField;
@property (strong, nonatomic) IBOutlet UITextField *foodItemField;
@property (strong, nonatomic) IBOutlet UILabel *FoodBusinessNo;


- (IBAction)addFoodItemClicked:(UIButton *)sender;
- (IBAction)addImageFoodItemClicked:(UIButton *)sender;
- (IBAction)foodCategoryClicked:(UIButton *)sender;
- (IBAction)dateFieldClicked:(UIButton *)sender;
- (IBAction)countryClicked:(UIButton *)sender;
- (IBAction)victoriaClicked:(UIButton *)sender;
- (IBAction)addPhotoClicked:(UIButton *)sender;

@end
