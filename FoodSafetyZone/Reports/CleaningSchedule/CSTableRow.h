//
//  CSTableRow.h
//  FoodSafetyZone
//
//  Created by railsfactory on 22/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSTableRow : UIView

@property (strong, nonatomic) IBOutlet UILabel *equipmentName;
@property (strong, nonatomic) IBOutlet UILabel *dailyFreq;
@property (strong, nonatomic) IBOutlet UILabel *weeklyFreq;
@property (strong, nonatomic) IBOutlet UILabel *monthlyFreq;
@property (strong, nonatomic) IBOutlet UILabel *cleaningInstr;
@property (strong, nonatomic) IBOutlet UILabel *productsToUse;
@property (strong, nonatomic) IBOutlet UILabel *responsiblePerson;
@property (strong, nonatomic) IBOutlet UILabel *reviewedBy;
@property (strong, nonatomic) IBOutlet UILabel *specialInstr;
@end
