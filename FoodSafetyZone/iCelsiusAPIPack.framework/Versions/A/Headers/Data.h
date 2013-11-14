//
//  Data.h
//  iCelsius3
//
//  Created by Aginova on 6/10/11.
//  Copyright 2011 Aginova Sàrl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Data : NSObject {
    
    // EPCH timestamp (since 1970) in seconds
    NSTimeInterval _timestamp;
    
    // Sensor ID - for iCelsius non wireless, this is the product type
    int _sensorId;
    
    // Measurements 1-4. Typically ch.1 is temperature
    NSNumber* _m1;
    NSNumber* _m2;
    NSNumber* _m3;
    NSNumber* _m4;
    
    // ADC value for ch.1 used for troubleshooting
    double _adc;
}

@property(nonatomic,assign) int sensorId;
@property(nonatomic,assign) NSTimeInterval timestamp;
@property(nonatomic,retain) NSNumber* m1;
@property(nonatomic,retain) NSNumber* m2;
@property(nonatomic,retain) NSNumber* m3;
@property(nonatomic,retain) NSNumber* m4;
@property(nonatomic, assign) double adc;

@end
