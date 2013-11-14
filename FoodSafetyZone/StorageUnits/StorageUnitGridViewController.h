//
//  StorageUnitGridViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 29/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "GridViewCell.h"
#import "AddRecordsStorageUnitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEUtility.h"
#import <MessageUI/MessageUI.h>
#import "Sensors.h"
#import "BLEDevice.h"
#define MIN_ALPHA_FADE 0.2f
#define ALPHA_FADE_STEP 0.05f
@interface StorageUnitGridViewController : UIViewController<UISearchBarDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>
{
    NSMutableArray	*filteredListContent;
    NSMutableArray  *filteredImagesList;
    NSMutableArray	*listContent;
    NSMutableArray  *ImagesList;
    
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    DBManager *dbmanager;
    NSString *selStorageName;
    NSString *selStorageUnitType;
    NSString *selAlertMes;
    UIImage *selStorageImage;
    NSString *scanedtemp;
}

@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSMutableArray *filteredImagesList;
@property (nonatomic, retain) NSMutableArray *listContent;
@property (nonatomic, retain) NSMutableArray *ImagesList;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;


//SENSOR TAG

@property (strong,nonatomic) BLEDevice *d;
/// Pointer to CoreBluetooth peripheral
@property (strong,nonatomic) CBPeripheral *p;
/// Pointer to CoreBluetooth manager that found this peripheral
@property (strong,nonatomic) CBCentralManager *manager;
/// Pointer to dictionary with device setup data
@property NSMutableDictionary *setupData;
@property NSMutableArray *sensorsEnabled;
@property (strong,nonatomic) NSMutableArray *vals;

-(void) configureSensorTag;
-(void) deconfigureSensorTag;
//SENSOR TAG


@end
