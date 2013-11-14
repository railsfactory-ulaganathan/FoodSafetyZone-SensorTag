//
//  ECEditViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 21/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ECEditViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    DBManager *dbManager;
    NSMutableString *tempStorageValues;
    int selectedID;
}

@property (strong, nonatomic) IBOutlet UITextField *equipmentNameField;
@property (strong, nonatomic) IBOutlet UIButton *equipmentImage;


- (IBAction)addPhotoClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *backView;
- (IBAction)deleteClicked:(id)sender;

@end
