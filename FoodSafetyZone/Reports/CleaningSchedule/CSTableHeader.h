//
//  CSTableHeader.h
//  FoodSafetyZone
//
//  Created by railsfactory on 22/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSTableHeader : UIView

@property (strong, nonatomic) IBOutlet UILabel *equipmentName;
@property (strong, nonatomic) IBOutlet UILabel *dailyFreqComment;
@property (strong, nonatomic) IBOutlet UILabel *weeklyFreqComment;
@property (strong, nonatomic) IBOutlet UILabel *monthlyFreqComment;
@property (strong, nonatomic) IBOutlet UILabel *cleaningInstr;
@property (strong, nonatomic) IBOutlet UILabel *productsToUse;
@property (strong, nonatomic) IBOutlet UILabel *responsiblePerson;
@property (strong, nonatomic) IBOutlet UILabel *reviewedBy;
@property (strong, nonatomic) IBOutlet UILabel *specialInstr;
@end
