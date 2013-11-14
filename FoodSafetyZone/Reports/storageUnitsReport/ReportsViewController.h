//
//  ReportsViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 19/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ReportsViewController : UIViewController<UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIActionSheet *actionSheet;
    UIDatePicker *datePicker;
    UIToolbar *toolBar;
    NSDateFormatter *FormatDate;
    UIPickerView *picker;
    DBManager *dbmanager;
}
- (IBAction)processClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *fromDateField;
@property (strong, nonatomic) IBOutlet UITextField *toDateField;
@property (strong, nonatomic) IBOutlet UITextField *selectRecordField;

@end
