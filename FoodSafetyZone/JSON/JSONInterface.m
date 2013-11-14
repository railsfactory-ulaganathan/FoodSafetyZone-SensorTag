//
//  JSONInterface.m
//  BrentInterview
//
//  Copyright 20011 company. All rights reserved.
//

#import "JSONInterface.h"
#import "JSON.h"


@implementation JSONInterface

	
-(NSString *)encodeRequest:(NSDictionary *)toEncodeDictionary
{
	//NSLog(@"come to dic ");
	NSString* jsonString = [toEncodeDictionary JSONRepresentation];
	//NSString* jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSLog(@"Json file strcuture is %@",jsonString);
	return jsonString;
	
}

-(NSDictionary *)decodeResponse:(NSString *)jsonDecode
{
	NSLog(@"before Decode %@",jsonDecode);
	parser = [[SBJSON alloc] init];
	
	NSError *error = nil;
	
	NSDictionary *results = [parser objectWithString:jsonDecode error:&error];
	
	if(error)
	{
		return nil;
	}
	
	return results;	
}

- (void) dealloc
{
	
	
}


@end