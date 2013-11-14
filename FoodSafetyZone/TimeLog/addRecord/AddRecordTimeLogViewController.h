//
//  AddRecordTimeLogViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 22/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import <QuartzCore/QuartzCore.h>
#import "EditTimeLogsViewController.h"
@interface AddRecordTimeLogViewController : UIViewController<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    DBManager *dbmanager;
    NSTimer *stopWatch;
    NSString *startTime,*stopTime;
    NSDateFormatter *dateFormatter;
    UIActionSheet *actionSheet;
    UIToolbar *toolBar;
    UIPickerView *picker;
    
    NSString *selectedFoodID;
    NSString *selectedActivityID;
    NSString *actionTaken;
    
    NSMutableArray *ActivityNames;
    NSMutableArray *foodTemps;
    NSMutableArray *actionTakenArray;
    int receivedStatus,hrsStatus;
    NSString *receivedStartTime;
}
@property (strong, nonatomic) IBOutlet UITextField *actionTakenTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UITextField *foodNameField;
@property (strong, nonatomic) IBOutlet UITextField *activityField;
@property (strong, nonatomic) IBOutlet UITextField *foodTempField;
@property (strong, nonatomic) IBOutlet UILabel *timerLbl;
@property (strong, nonatomic) IBOutlet UIImageView *foodItemImage;
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UIView *timerAlertView;
@property (strong, nonatomic) IBOutlet UIButton *timerAlertTimeValue;
@property (strong, nonatomic) IBOutlet UIImageView *overlayView;
@property (strong, nonatomic) IBOutlet UIButton *activityButton;

- (IBAction)editClicked:(UIButton *)sender;
- (IBAction)alertCloseClicked:(id)sender;
- (IBAction)actionTakenClicked:(UIButton *)sender;
- (IBAction)activityButtonClicked:(UIButton *)sender;
- (IBAction)startButtonClicked:(id)sender;
- (IBAction)timerContinueClicked:(id)sender;
- (IBAction)timerStopClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *actionTakenButton;
@end
