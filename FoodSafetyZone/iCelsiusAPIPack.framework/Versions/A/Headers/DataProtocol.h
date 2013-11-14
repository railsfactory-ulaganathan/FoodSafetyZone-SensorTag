//
//  DataProtocol.h
//  iCelsius3
//
//  Created by Aginova on 4/8/11.
//  Copyright 2011 Aginova Sàrl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data.h"
#import "ProductProtocol.h"

@class ProductProtocol;

@protocol DataProtocol <NSObject>

@required

// Call-back when data is received from the sensor
- (void)consumeData:(Data*)data;

// Call-back received when the accessory (sensor) is disconnected and no longer available
- (void)stopConsuming;

// Call-back received when accessory is connected, to know its capabilities
- (void)setProduct:(ProductProtocol*)product;

// Call-back received when there was an error with the accessory
- (void)processError:(NSString*)errorMessage withTitle:(NSString*)errorTitle;

@end
