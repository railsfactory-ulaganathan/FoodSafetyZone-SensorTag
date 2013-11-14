//
//  TimeLogReportView.h
//  FoodSafetyZone
//
//  Created by railsfactory on 19/09/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLogReportView : UIView
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (strong, nonatomic) IBOutlet UILabel *relatedActivityLbl;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *coldFoodLbl;
@property (strong, nonatomic) IBOutlet UILabel *hotFoodLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeOfActionLbl;
@property (strong, nonatomic) IBOutlet UIImageView *usedInImg;
@property (strong, nonatomic) IBOutlet UIImageView *eatenServedImg;
@property (strong, nonatomic) IBOutlet UIImageView *disposedImg;

@end
