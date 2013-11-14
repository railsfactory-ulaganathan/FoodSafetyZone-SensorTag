//
//  iCelsiusAPITest.h
//  iCelsiusAPI
//
//  Created by Reshad Moussa on 20.12.11.
//  Copyright (c) 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductOriginaliCelsius.h"
#import "ProductiCelsiusPro.h"
#import "ProductComfort.h"
#import "ProductGrill.h"

#import "iCelsiusAPIProtocol.h"

@class ProductProtocol;

@interface iCelsiusAPITest : NSObject <iCelsiusAPIProtocol>{
    NSTimer *updateTimer;
    
        
    // Temperature & humidity generated during demo
    float generatedTemp;
    float generatedHum;
}

// The current product
@property (nonatomic, retain) ProductProtocol* currentProduct;
//@property (retain) DataProtocol* dataConsumer;
@property (nonatomic, assign) float samplingPeriod;

// The singleton instance
+ (id)sharedManager;

// Implementation of the iCelsiusAPIProtocol
- (bool) isConnected;

// private
-(void)updateData;

@end
