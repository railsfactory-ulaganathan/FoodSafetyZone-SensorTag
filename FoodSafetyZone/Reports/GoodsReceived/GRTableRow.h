//
//  GRTableRow.h
//  FoodSafetyZone
//
//  Created by railsfactory on 14/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRTableRow : UIView

@property (strong, nonatomic) IBOutlet UILabel *dateField;
@property (strong, nonatomic) IBOutlet UILabel *TimeField;
@property (strong, nonatomic) IBOutlet UILabel *SuppliersField;
@property (strong, nonatomic) IBOutlet UILabel *FoodType;
@property (strong, nonatomic) IBOutlet UILabel *FoodTemp;
@property (strong, nonatomic) IBOutlet UILabel *DateCodeField;
@property (strong, nonatomic) IBOutlet UILabel *AcceptField;
@property (strong, nonatomic) IBOutlet UILabel *initialsField;
@property (strong, nonatomic) IBOutlet UILabel *ProblemsAndCorrectiveActionField;
@end
