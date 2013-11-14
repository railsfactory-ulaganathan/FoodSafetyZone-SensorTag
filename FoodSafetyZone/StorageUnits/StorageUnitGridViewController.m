//
//  StorageUnitGridViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 29/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "StorageUnitGridViewController.h"
#import "AddRecordsStorageUnitViewController.h"
#import "AddStorageUnitsViewController.h"
#import "EditStorageUnitsViewController.h"
#import "deviceSelector.h"

@interface StorageUnitGridViewController ()
{
    int searchtag;
    NSString *tempRangeForSelected;
    NSMutableString *accessibility;
}

@end

@implementation StorageUnitGridViewController
@synthesize filteredListContent,listContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive,filteredImagesList,ImagesList,search,mainScroll;
@synthesize d,p,manager,setupData,sensorsEnabled;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"STORAGE UNITS";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 40);
    [addButton setImage:[UIImage imageNamed:@"new-add-icon.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    addButton = nil;
    self.navigationItem.rightBarButtonItem = rightBarButton;
    rightBarButton = nil;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 40);
    [back setImage:[UIImage imageNamed:@"new-main-menu-button.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    back = nil;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftBarButton = nil;
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search.png"]forState:UIControlStateNormal];
    [self loadDataForPage];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [search setSearchFieldBackgroundImage:[UIImage imageNamed:@"search.png"]forState:UIControlStateNormal];
    search.showsCancelButton = YES;
    search.tintColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view from its nib.
    searchWasActive = NO;
    searchtag = 0;
}

-(void)loadDataForPage
{
    accessibility = [[NSMutableString alloc]init];
    listContent = [[NSMutableArray alloc]init];
    ImagesList = [[NSMutableArray alloc]init];
    dbmanager = [DBManager sharedInstance];
    if (dbmanager.d)
    {
        self.d = dbmanager.d;
        
        self.sensorsEnabled = [[NSMutableArray alloc] init];
        if (!self.d.p.isConnected)
        {
            self.d.manager.delegate = self;
            [self.d.manager connectPeripheral:self.d.p options:nil];
        }
        else
        {
            self.d.p.delegate = self;
            [self configureSensorTag];
            self.navigationItem.title = @"STORAGE UNIT";
        }
    }

    self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
    self.filteredImagesList = [NSMutableArray arrayWithCapacity:[self.ImagesList count]];
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
    if (listContent)
    {
        [listContent removeAllObjects];
        [ImagesList removeAllObjects];
    }
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM AddStorageUnits"];
    while([dbmanager.fmResults next])
    {
        [listContent addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"StorageUnitName"]]];
        NSData *tempData = [dbmanager.fmResults dataForColumn:@"storageUnitImage"];
        [ImagesList addObject:[UIImage imageWithData:tempData]];
        tempData = nil;
    }
    [self gridViewGeneration:[listContent count] :listContent :ImagesList];
}

-(void)gridViewGeneration:(int)count :(NSArray *)list :(NSArray *)imgList
{
    NSArray *viewsToRemove = [mainScroll subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    int xpos,ypos;
    xpos = 5;
    ypos = 10;
    int position = 0;
    for (int i = 0; i<count; i++)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridViewCell" owner:nil options:nil];
        GridViewCell *cell  = [nib objectAtIndex:0];
        cell.imgView.layer.cornerRadius = 8.0;
        cell.backgroundColor = [UIColor clearColor];
        cell.imgView.layer.masksToBounds = YES;
        cell.imgView.layer.borderWidth = 1;
        cell.imgView.layer.borderColor = [[UIColor greenColor] CGColor];
        nib = nil;
        if (i%2==0)
        {
            cell.frame = CGRectMake(xpos, ypos, 150, 150);
            cell.imgView.image = [imgList objectAtIndex:position];
            cell.titleLbl.text = [NSString stringWithFormat:@"%@",[list objectAtIndex:position]];
            cell.titleLbl.backgroundColor = [UIColor whiteColor];
            [mainScroll addSubview:cell];
            xpos += 160;
        }
        else
        {
            cell.frame = CGRectMake(xpos, ypos, 150, 150);
            cell.imgView.image = [imgList objectAtIndex:position];
            cell.titleLbl.text = [NSString stringWithFormat:@"%@",[list objectAtIndex:position]];
            cell.titleLbl.backgroundColor = [UIColor whiteColor];
            [mainScroll addSubview:cell];
            ypos += 160;
            xpos = 10;
        }
        UITapGestureRecognizer *single = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        single.accessibilityLabel = [NSString stringWithFormat:@"%d",position];
        single.numberOfTapsRequired = 1;
        [cell addGestureRecognizer:single];
        single = nil;
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGes:)];
        longpress.minimumPressDuration = 1;
        longpress.accessibilityLabel = [NSString stringWithFormat:@"%d",position];
        [cell addGestureRecognizer:longpress];
        [single requireGestureRecognizerToFail:longpress];
        longpress = nil;
        [mainScroll addSubview:cell];
        cell = nil;
        position +=1;
    }
    mainScroll.contentSize = CGSizeMake(320, ypos + 200);
}

-(void)singleTap:(UITapGestureRecognizer *)position
{
    dbmanager.tempArray = [[NSMutableArray alloc]init];
    if([filteredListContent count]==0)
    {
        [dbmanager.tempArray addObject:[NSMutableString stringWithFormat:@"%@",[listContent objectAtIndex:[position.accessibilityLabel intValue]]]];
        [dbmanager.tempArray addObject:[NSString stringWithFormat:@"singlePress"]];
    }
    else
    {
        [dbmanager.tempArray addObject:[NSMutableString stringWithFormat:@"%@",[filteredListContent objectAtIndex:[position.accessibilityLabel intValue]]]];
        [dbmanager.tempArray addObject:[NSString stringWithFormat:@"singlePress"]];
        //searchtag = 0;
    }
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        [self clearMemory];
        if (iOSDeviceScreenSize.height == 480)
        {
            AddRecordsStorageUnitViewController *addRecords = [[AddRecordsStorageUnitViewController alloc]initWithNibName:@"AddRecordsStorageUnitViewController" bundle:nil];
            [self.navigationController pushViewController:addRecords animated:YES];
            addRecords = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            AddRecordsStorageUnitViewController *addRecords = [[AddRecordsStorageUnitViewController alloc]initWithNibName:@"AddRecordsStorageUnitViewController5" bundle:nil];
            [self.navigationController pushViewController:addRecords animated:YES];
            addRecords = nil;
        }
    }
}

-(void)longPressGes:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([self scanTemperature] == YES)
        {
            accessibility = [NSString stringWithFormat:@"%@",sender.accessibilityLabel];
            deviceSelector *dS = [[deviceSelector alloc]initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:dS animated:YES];
            NSString *scanValue = [NSString stringWithFormat:@"%.2f",[scanedtemp floatValue]];
            NSString *check;
            if([filteredListContent count]==0)
            {
                dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM AddStorageUnits WHERE StorageUnitName = ?",[listContent objectAtIndex:[sender.accessibilityLabel intValue]]];
            }
            else
            {
                dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM AddStorageUnits WHERE StorageUnitName = ?",[filteredListContent objectAtIndex:[sender.accessibilityLabel intValue]]];
                //searchtag = 0;
            }
            while([dbmanager.fmResults next])
            {
                
                selStorageName = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"StorageUnitName"]];
                selStorageUnitType = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"UnitType"]];
                tempRangeForSelected = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"tempRange"]];
                selStorageImage = [UIImage imageWithData:[dbmanager.fmResults dataForColumn:@"storageUnitImage"]];
                selAlertMes = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"alertMessage"]];
            }
            NSArray *splitTemp = [tempRangeForSelected componentsSeparatedByString:@"to"];
            if (([scanValue floatValue]>=[[splitTemp objectAtIndex:0] floatValue])&&([scanValue floatValue]<=[[splitTemp objectAtIndex:1] floatValue]))
            {
                tempRangeForSelected = @"IN";
                NSLog(@"TEMP in Range!!!");
                check = @"";
                
                NSDate *new = [NSDate date];
                NSDateFormatter *FormatDate = [[NSDateFormatter alloc]init];
                [FormatDate setDateFormat:@"hh:mm a"];
                NSString *timeFiel = [FormatDate stringFromDate:new];
                [FormatDate setDateFormat:@"yyyy-MM-dd,EEE"];
                NSString *dateFiel = [FormatDate stringFromDate:new];
                FormatDate = nil;
                
                BOOL status = [dbmanager.fmDatabase  executeUpdate:@"INSERT INTO recordsForStorageUnit(storageUnitName,timeField,temperature,tempRangeStatus,dateField,lastUpdated,correctiveAction) VALUES(?,?,?,?,?,?,?)",selStorageName,timeFiel,[NSNumber numberWithFloat:[scanValue floatValue]],tempRangeForSelected,dateFiel,dateFiel,check,nil];
                if (status == YES)
                {
                    UIAlertView *success = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Record created Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [success show];
                    success = nil;
                    timeFiel = nil;
                    dateFiel = nil;
                    check = nil;
                }
            }
            else
            {
                if (dbmanager.tempArray)
                {
                    [dbmanager.tempArray removeAllObjects];
                }
                dbmanager.tempArray = [[NSMutableArray alloc]init];
                NSLog(@"TEMP OUT OF RANGE");
                [dbmanager.tempArray addObject:[NSMutableString stringWithFormat:@"%@",[listContent objectAtIndex:[sender.accessibilityLabel intValue]]]];
                [dbmanager.tempArray addObject:[NSString stringWithFormat:@"longPress"]];
                [dbmanager.tempArray addObject:scanValue];
                if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
                {    // The iOS device = iPhone or iPod Touch
                    [self clearMemory];
                    
                    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
                    
                    if (iOSDeviceScreenSize.height == 480)
                    {
                        AddRecordsStorageUnitViewController *addRecords = [[AddRecordsStorageUnitViewController alloc]initWithNibName:@"AddRecordsStorageUnitViewController" bundle:nil];
                        [self.navigationController pushViewController:addRecords animated:YES];
                        addRecords = nil;
                    }
                    if (iOSDeviceScreenSize.height > 480)
                    {
                        AddRecordsStorageUnitViewController *addRecords = [[AddRecordsStorageUnitViewController alloc]initWithNibName:@"AddRecordsStorageUnitViewController5" bundle:nil];
                        [self.navigationController pushViewController:addRecords animated:YES];
                        addRecords = nil;
                    }
                }
            }
        }
    }
}

-(BOOL)scanTemperature
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addClicked
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        [self clearMemory];
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            AddStorageUnitsViewController *addUnits = [[AddStorageUnitsViewController alloc]initWithNibName:@"AddStorageUnitsViewController" bundle:nil];
            [self.navigationController pushViewController:addUnits animated:YES];
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            AddStorageUnitsViewController *addUnits = [[AddStorageUnitsViewController alloc]initWithNibName:@"AddStorageUnitsViewController5" bundle:nil];
            [self.navigationController pushViewController:addUnits animated:YES];
        }
    }
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.filteredListContent removeAllObjects];
    [self.filteredImagesList removeAllObjects];// First clear the filtered array.
    for (int i = 0; i<[listContent count];i++)
    {
        NSComparisonResult result = [[listContent objectAtIndex:i] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self.filteredListContent addObject:[listContent objectAtIndex:i]];
            [self.filteredImagesList addObject:[ImagesList objectAtIndex:i]];
            searchtag = 1;
            
        }
        
    }
    if (searchtag == 0)
    {
        [self gridViewGeneration:[listContent count] :listContent :ImagesList];
    }
    else
    {
        [self gridViewGeneration:[filteredListContent count] :filteredListContent :filteredImagesList];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([filteredListContent count]==0)
    {
        UIAlertView *searchAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Search not found!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [searchAlert show];
        searchAlert = nil;
    }
}
-(void)backClicked
{
    [self clearMemory];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clearMemory
{
    listContent = nil;
    ImagesList = nil;
    filteredListContent = nil;
    filteredImagesList = nil;
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


//SENSOR Tag
-(void) configureSensorTag
{
    // Configure sensortag, turning on Sensors and setting update period for sensors etc ...
    
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"]))
    {
        // Enable Temperature sensor
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature config UUID"]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        
        if ([self sensorEnabled:@"Ambient temperature active"]) [self.sensorsEnabled addObject:@"Ambient temperature"];
        if ([self sensorEnabled:@"IR temperature active"]) [self.sensorsEnabled addObject:@"IR temperature"];
        
    }
}

-(void) deconfigureSensorTag
{
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"]))
    {
        // Enable Temperature sensor
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature config UUID"]];
        unsigned char data = 0x00;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
}

-(bool)sensorEnabled:(NSString *)Sensor
{
    NSString *val = [self.d.setupData valueForKey:Sensor];
    if (val)
    {
        if ([val isEqualToString:@"1"]) return TRUE;
    }
    return FALSE;
}

-(int)sensorPeriod:(NSString *)Sensor
{
    NSString *val = [self.d.setupData valueForKey:Sensor];
    return [val integerValue];
}

#pragma mark - CBCentralManager delegate function
-(void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}


#pragma mark - CBperipheral delegate functions

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"..");
    if ([service.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope service UUID"]]])
    {
        [self configureSensorTag];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@".");
    for (CBService *s in peripheral.services) [peripheral discoverCharacteristics:nil forService:s];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateNotificationStateForCharacteristic %@, error = %@",characteristic.UUID, error);
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //NSLog(@"didUpdateValueForCharacteristic = %@",characteristic.UUID);
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"IR temperature data UUID"]]])
    {
        float tAmb = [sensorTMP006 calcTAmb:characteristic.value];
        float tObj = [sensorTMP006 calcTObj:characteristic.value];
        scanedtemp = [NSString stringWithFormat:@"%f",tAmb];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic.UUID,error);
}

//SENSOR TAG

-(void)viewWillDisappear:(BOOL)animated
{
    [self deconfigureSensorTag];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.sensorsEnabled = nil;
    self.d.manager.delegate = nil;
}

@end
