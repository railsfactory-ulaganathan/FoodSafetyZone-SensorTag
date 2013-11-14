//
//  ProductTest.h
//  iCelsiusAPI
//
//  Created by Karl on 5/31/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductProtocol.h"
#import "Utilities.h"

@interface ProductTest : NSObject <ProductProtocol>{
    
}

@property (retain, nonatomic) RangeDefinition* rangeDefinitionM1;
//@property (retain, nonatomic) RangeDefinition* rangeDefinitionM2;

@end
