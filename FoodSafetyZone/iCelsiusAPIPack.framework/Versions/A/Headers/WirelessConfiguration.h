//
//  WirelessConfiguration.h
//  iCelsiusAPI
//
//  Created by Reshad Moussa on 20.10.11.
//  Copyright (c) 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WirelessConfiguration : NSObject{
    @private
    
    // The new MAC address, nil if not set
    NSString* _macAddress;
    
    // The new Sensor ID, nil if not set
    NSNumber* _sensorId;
    
    // The new product number, nil if not set
    NSNumber* _productNumber;
    
    // Sampling Timer	 UNSIGNED SHORT	 2	 Sampling Timer in second	 1s
    NSNumber* _samplingTimer;
    
    // Max sending sampling	 UNSIGNED SHORT	 2	 largest number of sampling without sending data (multiple of sampling period)	 10
    NSNumber* _maxSamplingBeforeSending;
    
    // Reconfiguration time	 UNSIGNED SHORT	 2	 reconfiguration time in multiple of sampling period
    NSNumber* _reconfigurationPeriod;
    
}

@property (nonatomic, retain) NSString* macAddress;
@property (nonatomic, retain) NSNumber* sensorId;
@property (nonatomic, retain) NSNumber* productNumber;
@property (nonatomic, retain) NSNumber* samplingTimer;
@property (nonatomic, retain) NSNumber* maxSamplingBeforeSending;
@property (nonatomic, retain) NSNumber* reconfigurationPeriod;

@end
