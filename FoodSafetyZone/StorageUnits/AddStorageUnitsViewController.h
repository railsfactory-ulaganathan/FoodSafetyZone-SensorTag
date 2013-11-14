//
//  AddStorageUnitsViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 15/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AddStorageUnitsViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    DBManager *dbManager;
    NSMutableArray *unitTypes;
    NSMutableArray *tempRange;
    
    UIActionSheet *actionSheet;
    UIToolbar *toolBar;
    UIPickerView *picker;
}
- (IBAction)addStorageClicked:(id)sender;
- (IBAction)unitTypeClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *storageUnitNameField;
@property (strong, nonatomic) IBOutlet UITextField *unitTypeField;
@property (strong, nonatomic) IBOutlet UITextView *alertMessage;
@property (strong, nonatomic) IBOutlet UIImageView *addImage;
@property (strong, nonatomic) IBOutlet UIButton *infoBut;

@property(nonatomic,strong) NSMutableArray *unitTypes;
@property(nonatomic,strong) NSMutableArray *tempRange;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *helpText;
- (IBAction)infoClicked:(id)sender;
- (IBAction)helpTextResign:(id)sender;

@end
