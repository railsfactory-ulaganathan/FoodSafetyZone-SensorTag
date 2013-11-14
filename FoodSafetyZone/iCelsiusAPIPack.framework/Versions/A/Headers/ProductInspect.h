//
//  ProductInspect.h
//  iCelsiusAPI
//
//  Created by Reshad Moussa on 18.10.11.
//  Copyright (c) 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductProtocol.h"


@interface ProductInspect : NSObject <ProductProtocol>{

}

@property (retain, nonatomic) RangeDefinition* rangeDefinitionM1;

@end
