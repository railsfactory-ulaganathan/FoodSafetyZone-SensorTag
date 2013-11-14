//
//  NetworkProtocol.h
//  iCelsiusAPI
//
//  Created by Reshad Moussa on 20.10.11.
//  Copyright (c) 2011 -. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol NetworkProtocol <NSObject>

@required

// Call-back when wireless data is received from the sensor
- (void) wirelessData:(float)temperature andVoltage:(float)batteryVoltage andRSSI:(int)rssi forSensor:(int)sensorId;

// Call-back when wireless data is not received from the sensor anymore
- (void) wirelessDataStop;

// Call-back when the configuration was sent
- (void) reconfigurationSent:(int)oldSensorId;

@end


