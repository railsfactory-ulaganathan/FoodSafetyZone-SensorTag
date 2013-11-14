//
//  EditStorageUnitsViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 12/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface EditStorageUnitsViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    DBManager *dbManager;
    
    UIActionSheet *actionSheet;
    UIToolbar *toolBar;
    UIPickerView *picker;
    NSMutableArray *unitTypes;
    NSMutableArray *tempRange;
    UIImage *selectedImage;
    NSMutableString *tempName;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UITextField *storageUnitNameField;
- (IBAction)UnitTypeClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *alertMessage;

- (IBAction)storageUnitImageClicked:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *unitTypeField;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIButton *addImage;
- (IBAction)infoClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIView *helpText;
- (IBAction)resignHelpText:(id)sender;
@end
