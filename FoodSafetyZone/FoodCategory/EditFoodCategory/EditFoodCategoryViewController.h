//
//  EditFoodCategoryViewController.h
//  FoodSafetyZone
//
//  Created by railsfactory on 05/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface EditFoodCategoryViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    DBManager *dbmanager;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UITextField *foodCategoryField;
@property (strong, nonatomic) IBOutlet UITextField *minTempField;
@property (strong, nonatomic) IBOutlet UITextField *maxTempField;
@property (strong, nonatomic) IBOutlet UIImageView *foodCategoryImage;
- (IBAction)addPhotoClicked:(id)sender;
- (IBAction)deleteData:(id)sender;
@end
