//
//  ReportTableHeader.m
//  FoodSafetyZone
//
//  Created by railsfactory on 31/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ReportTableHeader.h"

@implementation ReportTableHeader
@synthesize unit,mon,tue,wed,thu,fri,sat,sun,empty,t1,tp1,t2,tp2,t3,tp3,t4,tp4,t5,tp5,t6,tp6,t7,tp7;

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
