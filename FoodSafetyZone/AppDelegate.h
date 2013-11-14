//
//  AppDelegate.h
//  FoodSafetyZone
//
//  Created by railsfactory on 15/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DBManager *dbManager;
}

@property (strong, nonatomic) UIWindow *window;

@end
