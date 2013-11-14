//
//  ProductProtocol.h
//  iCelsius3
//
//  Created by Aginova on 3/22/11.
//  Copyright 2011 Aginova Sàrl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data.h"
#import "ProductDefinitions.h"
#import "RangeDefinition.h"

@protocol ProductProtocol <NSObject>

@required

// The range definition for sensor M1
- (RangeDefinition*) sensorM1Range;

// The range definition for sensor M2
- (RangeDefinition*) sensorM2Range;


/*
// Upper limit for sensor 1 (for temperatures in °C)
- (float)maxLimitM1;

// Lower limit for sensor 1 (for temperatures in °C)
- (float)minLimitM1;

// Upper limit for sensor 2 (for temperatures in °C)
- (float)maxLimitM2;

// Lower limit for sensor 2 (for temperatures in °C)
- (float)minLimitM2;
*/

// Number of sensors on this product
- (unsigned int)sensorsCount;

// Number of digits of resolution for this product
- (unsigned int)numberOfDigits;

// Product number
- (unsigned int)productNumber;

// Product name
- (NSString*)productName;

// NON-PUBLIC API
- (Data*)extractData:(uint8_t*)buf;

@end
