//
//  AddRecordsStorageUnitViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 22/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCelsiusAPIPack/iCelsiusAPI.h>
#import "DBManager.h"

@interface AddRecordsStorageUnitViewController : UIViewController<UIActionSheetDelegate,DataProtocol>
{
    DBManager *dbmanager;
    iCelsiusAPI* iCelsius;
    UIActionSheet *actionSheet;
    UIView *blockView;
    
    UIDatePicker *datePicker;
    UIToolbar *toolBar;
    NSDateFormatter *FormatDate;
    UIPickerView *picker;
    int confirmDelete;
    NSString *alertViewTemp;
    
    NSString *tempRangeStatus;
}
@property (strong, nonatomic) IBOutlet UIView *helpView;
@property (strong, nonatomic) IBOutlet UILabel *storageUnitNamefield;
@property (strong, nonatomic) IBOutlet UILabel *unitTypeField;
@property (strong, nonatomic) IBOutlet UILabel *tempRangeField;

@property (strong, nonatomic) IBOutlet UIImageView *storageUnitImage;
@property (strong, nonatomic) IBOutlet UITextField *tempField;

@property (strong, nonatomic) IBOutlet UITextView *correctiveActionTextView;
@property (strong, nonatomic) IBOutlet UIImageView *correctiveActionImageView;
@property (strong, nonatomic) IBOutlet UILabel *correctiveActionLabel;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIScrollView *Scroll;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *helpInfo;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIView *helpText;
@property (strong, nonatomic) IBOutlet UILabel *tempAlert;
@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UITextField *timeField;
@property (strong, nonatomic) IBOutlet UIImageView *dateBack;
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *timeBack;



- (IBAction)scanButtonClicked:(id)sender;
- (IBAction)infoClicked:(id)sender;
- (IBAction)removeHelpText:(id)sender;
- (IBAction)helpInfoClicked:(id)sender;
- (IBAction)editClicked:(UIButton *)sender;

- (IBAction)alertTextDisplay:(id)sender;

@end
