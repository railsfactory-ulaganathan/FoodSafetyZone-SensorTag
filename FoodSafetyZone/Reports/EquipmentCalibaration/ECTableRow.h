//
//  ECTableRow.h
//  FoodSafetyZone
//
//  Created by railsfactory on 21/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECTableRow : UIView

@property (strong, nonatomic) IBOutlet UILabel *equipmentName;
@property (strong, nonatomic) IBOutlet UILabel *contractorName;
@property (strong, nonatomic) IBOutlet UILabel *dateOfService;
@property (strong, nonatomic) IBOutlet UILabel *passStatus;
@property (strong, nonatomic) IBOutlet UILabel *iceWaterTemp;
@property (strong, nonatomic) IBOutlet UILabel *boilingWaterTemp;
@property (strong, nonatomic) IBOutlet UILabel *correctiveAction;
@end
