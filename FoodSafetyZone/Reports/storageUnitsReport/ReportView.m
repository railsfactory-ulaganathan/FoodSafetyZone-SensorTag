//
//  ReportView.m
//  FoodSafetyZone
//
//  Created by railsfactory on 31/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ReportView.h"

@implementation ReportView
@synthesize unitNameLbl,mondayTimeLbl,mondayTempLbl,tuesdayTimeLbl,tuesdayTempLbl,wednesdayTimeLbl,wednesdayTempLbl,thursdayTimeLbl,thursdayTempLbl,fridayTimeLbl,fridayTempLbl,saturdayTimeLbl,saturdayTempLbl,sundayTimeLbl,sundayTempLbl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
