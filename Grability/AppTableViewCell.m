//
//  AppTableViewCell.m
//  Grability
//
//  Created by Camilo Morales on 14/1/16.
//  Copyright © 2016 Camilo Morales. All rights reserved.
//

#import "AppTableViewCell.h"
#import "Model.h"

@implementation AppTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)downloadAppImageWithURL:(NSString *)urlStr{

    if ([[Model sharedModel] loadImageWithAppID:self.appID]) {
        self.icon.image = [[Model sharedModel] loadImageWithAppID:self.appID];
    }else{
        dispatch_queue_t downloadAppIcon = dispatch_queue_create("DownloadAppIcon", NULL);
        
        dispatch_async(downloadAppIcon, ^{
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image){
                    [self.icon setImage:image];
                    [[Model sharedModel] saveImage:image AppID:self.appID];
                }
            });
        });
    }
}



@end
