//
//  GRCustomCell.h
//  FoodSafetyZone
//
//  Created by railsfactory on 15/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *foodTypeLbl;
@property (strong, nonatomic) IBOutlet UILabel *supplierLbl;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLbl;
@property (strong, nonatomic) IBOutlet UILabel *usedByLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UILabel *correctiveActionLbl;
@property (strong, nonatomic) IBOutlet UILabel *correctiveActionValueLbl;
@property (strong, nonatomic) IBOutlet UIImageView *acceptImage;
@end
