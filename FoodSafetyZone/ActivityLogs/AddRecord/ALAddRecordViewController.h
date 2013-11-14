//
//  ALAddRecordViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 23/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import <iCelsiusAPIPack/iCelsiusAPI.h>

@interface ALAddRecordViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,DataProtocol>
{
    DBManager *dbManager;
    iCelsiusAPI* iCelsius;
    NSMutableString *tempStorageValues;
    int selectedId,sts,idd,startStatus,stStatus;
    NSMutableArray *activityArray;
    NSMutableArray *availableActivities;
    NSMutableString *tempStr;
    NSMutableString *dataForActivity;
    NSMutableArray *equipmentNames;
    NSMutableString *detuctedTemp;
    
    UIActionSheet *actionSheet;
    UIToolbar *toolBar;
    UIPickerView *picker;
}

@property (strong, nonatomic) IBOutlet UITextField *portionSize;
@property (strong, nonatomic) IBOutlet UITextField *equipmentName;
@property (strong, nonatomic) IBOutlet UITextField *equipmentTemp;
@property (strong, nonatomic) IBOutlet UITextField *startTime;
@property (strong, nonatomic) IBOutlet UITextField *startTemp;
@property (strong, nonatomic) IBOutlet UITextField *endTime;
@property (strong, nonatomic) IBOutlet UITextField *endTemp;
@property (strong, nonatomic) IBOutlet UITextField *totalTime;
@property (strong, nonatomic) IBOutlet UITextView *comments;
@property (strong, nonatomic) IBOutlet UILabel *foodName;
@property (strong, nonatomic) IBOutlet UIView *CCRView;
@property (strong, nonatomic) IBOutlet UIView *otherActivityView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *tabScroll;
@property (strong, nonatomic) IBOutlet UIButton *foodImage;


@property (strong, nonatomic) IBOutlet UITextField *startTime1;
@property (strong, nonatomic) IBOutlet UITextField *startTemp1;
@property (strong, nonatomic) IBOutlet UITextField *endTime1;
@property (strong, nonatomic) IBOutlet UITextField *endTemp1;
@property (strong, nonatomic) IBOutlet UITextField *totalTime1;
@property (strong, nonatomic) IBOutlet UITextView *comments1;

@property (strong, nonatomic) NSMutableString *detuctedTemp;
- (IBAction)equipmentNameListClicked:(UIButton *)sender;
- (IBAction)otherActivitiesStartClicked:(UIButton *)sender;
- (IBAction)CCRStartClicked:(UIButton *)sender;
- (IBAction)scanclicked:(UIButton *)sender;
- (IBAction)editClicked:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *CCRStartButt;
@property (strong, nonatomic) IBOutlet UIButton *otherStartButt;
@end
