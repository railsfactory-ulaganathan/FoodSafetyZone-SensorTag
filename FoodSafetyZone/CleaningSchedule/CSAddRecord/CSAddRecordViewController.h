//
//  CSAddRecordViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 22/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface CSAddRecordViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    DBManager *dbManager;
    NSMutableString *tempStorageValues;
    NSMutableArray *frequencyArray;
    UIActionSheet *actionSheet;
    UIToolbar *toolBar;
    UIPickerView *picker;
    int selectedId;
}

@property (strong, nonatomic) IBOutlet UITextField *equipmentNameField;
@property (strong, nonatomic) IBOutlet UITextField *frequencyField;
@property (strong, nonatomic) IBOutlet UITextView *commentsField;
@property (strong, nonatomic) IBOutlet UITextView *cleaningInstrField;
@property (strong, nonatomic) IBOutlet UITextView *productsToUseField;
@property (strong, nonatomic) IBOutlet UITextField *responsiblePersonField;
@property (strong, nonatomic) IBOutlet UITextField *reviewedByField;
@property (strong, nonatomic) IBOutlet UITextView *specialInstrField;
@property (strong, nonatomic) IBOutlet UIButton *equipmentImage;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *backView;


- (IBAction)frequencyClicked:(id)sender;
- (IBAction)editClicked:(id)sender;

@end
