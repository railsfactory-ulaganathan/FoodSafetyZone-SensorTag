//
//  iCelsiusAPIProtocol.h
//  iCelsiusAPI
//
//  Created by Reshad Moussa on 20.12.11.
//  Copyright (c) 2011 -. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataProtocol;
@class ProductProtocol;

@protocol iCelsiusAPIProtocol

@required

@property (retain) DataProtocol* dataConsumer;
@property (nonatomic, assign) float samplingPeriod;

- (bool) isConnected;

@end
