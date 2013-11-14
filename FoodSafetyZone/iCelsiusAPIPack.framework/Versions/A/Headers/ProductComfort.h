//
//  ProductComfort.h
//  iCelsius3
//
//  Created by Reshad Moussa on 13.09.11.
//  Copyright 2011 Aginova Sàrl. All rights reserved.
//

#import <sys/sysctl.h>
#import <Foundation/Foundation.h>
#import "ProductProtocol.h"
#import "Utilities.h"

@interface ProductComfort : NSObject <ProductProtocol>

@property (retain, nonatomic) RangeDefinition* rangeDefinitionM1;
@property (retain, nonatomic) RangeDefinition* rangeDefinitionM2;

@end
