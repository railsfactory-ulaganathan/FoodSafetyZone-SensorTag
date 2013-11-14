//
//  ProductCalibrated.h
//  iCelsius3
//
//  Created by Reshad Moussa on 01.09.11.
//  Copyright 2011 Aginova Sàrl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductProtocol.h"
#import "Utilities.h"

@interface ProductCalibrated : NSObject <ProductProtocol>{
    double _A;
    double _B;
    double _C;
    double _D;
    
    float _minTemperature;
    float _maxTemperature;
}

-(void) setCalibrationWithA:(double)A andB:(double)B andC:(double)C andD:(double)D andMinT:(float)minTemperature andMaxT:(float)maxTemperature;
    
@property (nonatomic, assign) double A;
@property (nonatomic, assign) double B;
@property (nonatomic, assign) double C;
@property (nonatomic, assign) double D;
@property (nonatomic, assign) float minTemperature;
@property (nonatomic, assign) float maxTemperature;

@property (retain, nonatomic) RangeDefinition* rangeDefinitionM1;

@end


