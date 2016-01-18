//
//  AppTableViewCell.h
//  Grability
//
//  Created by Camilo Morales on 14/1/16.
//  Copyright © 2016 Camilo Morales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic, strong) NSString *appID;
- (void)downloadAppImageWithURL:(NSString *) urlStr;
@end
