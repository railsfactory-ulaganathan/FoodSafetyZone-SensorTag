//
//  RangeDefinition.h
//  iCelsiusAPI
//
//  Created by Reshad Moussa on 20.03.12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RangeDefinition : NSObject

// The upper limit for measurement
@property (retain,nonatomic) NSNumber* upperLimit;

// The upper limit to display in Dial in °C
@property (retain,nonatomic) NSNumber* upperLimitDialC;

// The upper limit to display in Dial in °F
@property (retain,nonatomic) NSNumber* upperLimitDialF;

// The lower limit for measurement
@property (retain,nonatomic) NSNumber* lowerLimit;

// The lower limit to display in Dial in °C
@property (retain,nonatomic) NSNumber* lowerLimitDialC;

// The lower limit to display in Dial in °F
@property (retain,nonatomic) NSNumber* lowerLimitDialF;

@end
