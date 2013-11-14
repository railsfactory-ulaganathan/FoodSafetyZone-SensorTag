//
//  ProductGrill.h
//  iCelsius3
//
//  Created by Reshad Moussa on 07.10.11.
//  Copyright 2011 Aginova Sàrl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductProtocol.h"

@interface ProductGrill : NSObject <ProductProtocol>

@property (retain, nonatomic) RangeDefinition* rangeDefinitionM1;

@end
