//
//  CSAddEquipmentsViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 22/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface CSAddEquipmentsViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    DBManager *dbManager;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UITextField *equipmentNameField;
@property (strong, nonatomic) IBOutlet UIButton *equipmentImage;
- (IBAction)addPhotoClicked:(UIButton *)sender;
@end
