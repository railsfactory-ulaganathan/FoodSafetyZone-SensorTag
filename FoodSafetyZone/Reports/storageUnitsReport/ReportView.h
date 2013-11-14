//
//  ReportView.h
//  FoodSafetyZone
//
//  Created by railsfactory on 31/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportView : UIView
@property (strong, nonatomic) IBOutlet UILabel *unitNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *mondayTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *mondayTempLbl;
@property (strong, nonatomic) IBOutlet UILabel *tuesdayTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *tuesdayTempLbl;
@property (strong, nonatomic) IBOutlet UILabel *wednesdayTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *wednesdayTempLbl;
@property (strong, nonatomic) IBOutlet UILabel *thursdayTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *thursdayTempLbl;
@property (strong, nonatomic) IBOutlet UILabel *fridayTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *fridayTempLbl;
@property (strong, nonatomic) IBOutlet UILabel *saturdayTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *saturdayTempLbl;
@property (strong, nonatomic) IBOutlet UILabel *sundayTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *sundayTempLbl;

@end
