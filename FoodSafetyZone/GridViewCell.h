//
//  GridViewCell.h
//  newGridView
//
//  Created by railsfactory on 29/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridViewCell : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
- (IBAction)quickScanClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *quickScan;
@property (strong, nonatomic) IBOutlet UIImageView *timer;

@end
