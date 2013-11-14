//
//  NetworkListener.h
//  iCelsius3
//
//  Created by Aginova on 27.07.11.
//  Copyright 2011 Aginova Sàrl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <unistd.h>

#import <assert.h>
#import <pthread.h>
#import <iCelsiusAPIPack/Utilities.h>
#import "NetworkProtocol.h"
#import "WirelessConfiguration.h"

@class NetworkProtocol;

@interface NetworkListener : NSObject {
    
@private 
    // When the last data was sent
    NSTimeInterval lastSent;
    
    // Last temperature sent
    float lastTemperature;
    
    // Last voltage from the sensor
    float lastVoltage;
    
    // Last RSSI from sensor
    float lastRSSI;
    
    // Last sensor id
    int lastSensorID;
    
    // Register a delegate to listen to incoming packets
    NetworkProtocol* _delegate;
    
    // The reconfigurations that are scheduled to run for each sensor
    //NSMutableDictionary* _scheduledReconfigurations;
    
    // Do we receive any packet?
    boolean_t _wirelessActive;
}

// the delegate, handling the incoming packets
@property (nonatomic, retain) NetworkProtocol* delegate;

// The reconfigurations that are scheduled to run for each sensor
@property (nonatomic, retain) NSMutableDictionary* scheduledReconfigurations;

// Schedules a reconfiguration of the sensor
- (void)scheduleReconfigurationForSensorId:(int)sensorId withConfiguration:(WirelessConfiguration*)wirelessConfiguation;

// Starts listening for incoming packets
- (void)startListening;

// Singleton instance
+ (id)sharedManager;

@end
