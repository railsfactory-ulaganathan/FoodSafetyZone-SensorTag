//
//  ECAddRecordsViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 21/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "ECEditViewController.h"

@interface ECAddRecordsViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    DBManager *dbManager;
    NSMutableString *tempStorageValues;
    int selectedId;
}

@property (strong, nonatomic) IBOutlet UITextField *equipmentNameField;
@property (strong, nonatomic) IBOutlet UITextField *contractorField;
@property (strong, nonatomic) IBOutlet UITextField *iceWaterTempField;
@property (strong, nonatomic) IBOutlet UITextField *boilingWaterTempField;
@property (strong, nonatomic) IBOutlet UISwitch *passStatusSwitch;
@property (strong, nonatomic) IBOutlet UITextView *correctiveActionField;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIButton *equipmentImage;

- (IBAction)editClicked:(UIButton *)sender;

- (IBAction)addPhotoClicked:(id)sender;
- (IBAction)passStatusChanged:(UISwitch *)sender;

@end
