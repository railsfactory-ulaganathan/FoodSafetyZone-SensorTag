//
//  TimelogReportCell.h
//  FoodSafetyZone
//
//  Created by railsfactory on 04/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelogReportCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *foodNameValue;
@property (strong, nonatomic) IBOutlet UILabel *activityNameValue;
@property (strong, nonatomic) IBOutlet UILabel *foodTempValue;
@property (strong, nonatomic) IBOutlet UILabel *startTimeValue;
@property (strong, nonatomic) IBOutlet UILabel *stopTimeValue;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeValue;
@property (strong, nonatomic) IBOutlet UILabel *actionNameValue;

@end
