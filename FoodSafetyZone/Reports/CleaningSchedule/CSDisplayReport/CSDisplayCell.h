//
//  CSDisplayCell.h
//  FoodSafetyZone
//
//  Created by railsfactory on 29/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSDisplayCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *frequency;
@property (strong, nonatomic) IBOutlet UILabel *cleaningInstr;
@property (strong, nonatomic) IBOutlet UILabel *productsToUse;
@property (strong, nonatomic) IBOutlet UILabel *responsiblePerson;
@property (strong, nonatomic) IBOutlet UILabel *reviewedBy;
@property (strong, nonatomic) IBOutlet UILabel *specialInstr;
@end
