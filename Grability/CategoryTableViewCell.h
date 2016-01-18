//
//  CategoryTableViewCell.h
//  Grability
//
//  Created by Camilo Morales on 14/1/16.
//  Copyright © 2016 Camilo Morales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end
