//
//  AddEquipmentsViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 21/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AddEquipmentsViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    DBManager *dbManager;
}

@property (strong, nonatomic) IBOutlet UITextField *equipmentNameField;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIButton *equipmentImage;


- (IBAction)addPhotoClicked:(id)sender;

@end
