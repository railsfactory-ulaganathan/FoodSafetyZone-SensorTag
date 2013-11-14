//
//  TimelogReportCell.m
//  FoodSafetyZone
//
//  Created by railsfactory on 04/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "TimelogReportCell.h"

@implementation TimelogReportCell
@synthesize foodNameValue,activityNameValue,foodTempValue,startTimeValue,stopTimeValue,totalTimeValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
