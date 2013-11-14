//
//  ALTableHeader.h
//  FoodSafetyZone
//
//  Created by railsfactory on 28/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALTableHeader : UIView

@property (strong, nonatomic) IBOutlet UIImageView *preparationImageView;
@property (strong, nonatomic) IBOutlet UIImageView *cookingImageView;
@property (strong, nonatomic) IBOutlet UIImageView *coolingImageView;
@property (strong, nonatomic) IBOutlet UIImageView *reheatingImageView;
@property (strong, nonatomic) IBOutlet UIImageView *hotholdingImageView;
@property (strong, nonatomic) IBOutlet UIImageView *servingImageView;
@property (strong, nonatomic) IBOutlet UIImageView *foodPackingImageView;
@property (strong, nonatomic) IBOutlet UILabel *dateValue;
@property (strong, nonatomic) IBOutlet UILabel *menuItemValue;
@property (strong, nonatomic) IBOutlet UILabel *activity1;
@property (strong, nonatomic) IBOutlet UILabel *activity2;
@property (strong, nonatomic) IBOutlet UILabel *activity3;
@property (strong, nonatomic) IBOutlet UILabel *activity4;
@property (strong, nonatomic) IBOutlet UILabel *activity5;
@property (strong, nonatomic) IBOutlet UILabel *activity6;
@property (strong, nonatomic) IBOutlet UILabel *activity7;
@end
