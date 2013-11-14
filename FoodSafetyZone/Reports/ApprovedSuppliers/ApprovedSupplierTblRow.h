//
//  ApprovedSupplierTblRow.h
//  FoodSafetyZone
//
//  Created by railsfactory on 07/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApprovedSupplierTblRow : UIView

@property (strong, nonatomic) IBOutlet UILabel *foodSuppliedLbl;
@property (strong, nonatomic) IBOutlet UILabel *supplierTradingName;
@property (strong, nonatomic) IBOutlet UILabel *supplierAddressPhone;
@property (strong, nonatomic) IBOutlet UILabel *dateSupplyStartedLbl;
@property (strong, nonatomic) IBOutlet UILabel *otherInformationLbl;
@end
