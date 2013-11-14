//
//  JSONInterface.h
//  BrentInterview
//
//  Copyright 20011 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface JSONInterface : NSObject {
	SBJSON *parser;
}

-(NSString *)encodeRequest:(NSDictionary *)toEncodeDictionary;
-(NSDictionary *)decodeResponse:(NSString *)jsonDecode;


@end
