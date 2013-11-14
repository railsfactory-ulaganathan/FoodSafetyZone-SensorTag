//
//  GRAddRecordViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 09/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCelsiusAPIPack/iCelsiusAPI.h>
#import "DBManager.h"
@interface GRAddRecordViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate>
{
    DBManager *dbManager;
    iCelsiusAPI* iCelsius;
    UIActionSheet *actionSheet;
    UIDatePicker *datePicker;
    UIToolbar *toolBar;
    NSDateFormatter *FormatDate;
    NSMutableString *tempStorageValues;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIImageView *foodItemImage;
@property (strong, nonatomic) IBOutlet UILabel *foodItemName;
@property (strong, nonatomic) IBOutlet UITextField *tempField;
@property (strong, nonatomic) IBOutlet UITextField *expDateField;
@property (strong, nonatomic) IBOutlet UITextField *bestBeforeField;
@property (strong, nonatomic) IBOutlet UISwitch *acceptSwitch;
@property (strong, nonatomic) IBOutlet UITextView *correctiveAction;
@property (strong, nonatomic) IBOutlet UIImageView *correctiveBack;
@property (strong, nonatomic) IBOutlet UILabel *correctiveLbl;
@property (strong, nonatomic) IBOutlet UILabel *alertLbl;
@property (strong, nonatomic) IBOutlet UILabel *alertValueLbl;

- (IBAction)scanClicked:(id)sender;
- (IBAction)switchChanged:(UISwitch *)sender;
- (IBAction)optionChanged:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *option1;
@property (strong, nonatomic) IBOutlet UIButton *option2;
@end
