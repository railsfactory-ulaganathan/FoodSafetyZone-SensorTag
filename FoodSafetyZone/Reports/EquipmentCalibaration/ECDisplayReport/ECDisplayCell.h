//
//  ECDisplayCell.h
//  FoodSafetyZone
//
//  Created by railsfactory on 22/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECDisplayCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *equipmentName;
@property (strong, nonatomic) IBOutlet UILabel *contractorName;
@property (strong, nonatomic) IBOutlet UILabel *iceWaterTemp;
@property (strong, nonatomic) IBOutlet UILabel *boilingWaterTemp;
@property (strong, nonatomic) IBOutlet UILabel *correctiveAction;
@property (strong, nonatomic) IBOutlet UIImageView *passstatus;
@property (strong, nonatomic) IBOutlet UILabel *correctiveActionValue;
@end
