//
//  iCelsius API.h
//  iCelsius API
//
//  Created by Reshad Moussa on 12.10.11.
//  Copyright 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mchp_mfi.h"
#import "iCelsiusAPIProtocol.h"
#import "DataProtocol.h"
#import "ProductComfort.h"
#import "ProductiCelsiusPro.h"
#import "ProductCalibrated.h"
#import "ProductOriginaliCelsius.h"
#import "ProductOriginaliCelsiusRevB.h"
#import "ProductGrill.h"
#import "ProductInspect.h"
#import "ProductIP2.h"
#import "ProductIP3.h"
#import "ProductBodyOral.h"
#import "ProductBodySkin.h"
#import "ProductTest.h"
#import "Data.h"
#import "Utilities.h"

#define MFI_UNKNOWN_HW -1

@class DataProtocol;

@interface iCelsiusAPI : mchp_mfi <iCelsiusAPIProtocol> {
    
@private
    
    // Listener
    DataProtocol* _dataConsumer;
    
    
    uint8_t AccStatus;
    uint8_t AccMajor;
    uint8_t AccMinor;
    uint8_t AccRev;
    int BoardID;
	
	NSThread *updateThread;
    
    // How many data packets were received since connected
    int dataCounter;
    
    // Is the probe ready?
    BOOL _probeReady;
    
    // The current product
    ProductProtocol* _currentProduct;

}

@property (readonly) uint8_t AccStatus;
@property (readonly) uint8_t AccMajor;
@property (readonly) uint8_t AccMinor;
@property (readonly) uint8_t AccRev;
@property (readonly) int BoardID;
@property (readonly) int adcCode;
@property (retain) DataProtocol* dataConsumer;
@property (nonatomic, assign) BOOL probeReady;
@property (nonatomic, retain) ProductProtocol* currentProduct;
@property (nonatomic, assign) float samplingPeriod;

// The singleton instance
+ (id)sharedManager;

// Checks incoming calls
// NOT PUBLIC API
- (void) updateData;

// Sends the calibration parameters to the device
// NOT PUBLIC API
+ (NSData*) getCalibrationWithA:(double)A andB:(double)B andC:(double)C andD:(double)D;

// Sends a request to set the values stored in flash
// NOT PUBLIC API
- (void) setStoredValues:(NSData*)data;

// Sends a request to set the product stored in flash
// NOT PUBLIC API
- (void)flashProductNumber:(unsigned short)productNumber;

// Sends the calibration parameters to the device
- (void) sendCalibrationWithA:(double)A andB:(double)B andC:(double)C andD:(double)D andMinT:(float)minTemperature andMaxT:(float)maxTemperature andProductNumber:(unsigned short)prodNum;

@end
