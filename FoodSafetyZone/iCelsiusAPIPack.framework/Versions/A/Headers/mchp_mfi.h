//
//  mchp_mfi.h
//  MCHP MFI
//
//  Created by Joseph Julicher on 6/10/10.
//  Copyright 2010 Microchip Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>


@interface mchp_mfi : NSObject <EAAccessoryDelegate, NSStreamDelegate>
{
    uint8_t appMajorVersion;
    uint8_t appMinorVersion;
    uint8_t appRev;
    
	NSString *theProtocol;
	
    EASession *_eas;
    
    BOOL streamReady;
    BOOL receivedAccPkt;
    NSMutableData *rxData;
    NSMutableData *txData;
    NSData *FSresponse_data;
}
- (id) initWithProtocol:(NSString *)protocol;
- (void) queueTxBytes:(NSData *)buf;
- (void) txBytes;
- (void) rxBytes:(const void *)buf length:(int)len;
- (EASession *)openSessionForProtocol:(NSString *)protocolString;
- (void)accessoryDidDisconnect:(NSNotification *)notification;
- (void)accessoryDidConnect:(NSNotification *)notification;
- (bool) isConnected;
- (NSString *) name;
- (NSString *) manufacturer;
- (NSString *) modelNumber;
- (NSString *) serialNumber;
- (NSString *) firmwareRevision;
- (NSString *) hardwareRevision;
// You implement this function

- (int) readData:(NSData *) data;

@property (nonatomic, retain) EASession *eas;

@end
