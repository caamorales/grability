//
//  AppDetailViewController.m
//  Grability
//
//  Created by Camilo Morales on 18/1/16.
//  Copyright © 2016 Camilo Morales. All rights reserved.
//

#import "AppDetailViewController.h"
#import "Model.h"

@interface AppDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *appIcon;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@end

@implementation AppDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.copyrightLabel.text = self.appEntry.rights;
    self.nameLabel.text = self.appEntry.title;
    self.categoryLabel.text = self.appEntry.category;
    self.priceLabel.text = self.appEntry.price;
    self.summaryTextView.text = self.appEntry.summary;
    self.appIcon.image = [UIImage imageNamed:@"AppPlaceholder"];
    [self getAppIconWithURL:self.appEntry.iconURL AppID:self.appEntry.idNumber];
    self.appIcon.layer.cornerRadius = 16;
    self.appIcon.layer.masksToBounds = true;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)downloadApp:(id)sender {
    
    if (!TARGET_IPHONE_SIMULATOR){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appEntry.linkURL]];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Simulator can't open the AppStore, try on an actual device." delegate:nil cancelButtonTitle:@"Return" otherButtonTitles:nil, nil] show];
    }

}

- (void)getAppIconWithURL:(NSString *) url AppID:(NSString *) AppID{
    if ([[Model sharedModel] loadImageWithAppID:AppID]) {
        self.appIcon.image = [[Model sharedModel] loadImageWithAppID:AppID];
    }else{
        dispatch_queue_t downloadAppIcon = dispatch_queue_create("DownloadAppIcon", NULL);
        
        dispatch_async(downloadAppIcon, ^{
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image){
                    [self.appIcon setImage:image];
                    [[Model sharedModel] saveImage:image AppID:AppID];
                }
            });
        });
    }
}


@end
