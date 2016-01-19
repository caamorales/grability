//
//  ViewController.m
//  Grability
//
//  Created by Camilo Morales on 12/1/16.
//  Copyright © 2016 Camilo Morales. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "Constants.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Model sharedModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReady:) name:DATA_READY_NOTIFICATION object:nil];
    self.networkErrorView.hidden = true;
}

- (void)dataReady:(NSNotification *) notification{
    if (!notification.userInfo[@"error"]) {
        if ([self isiPad]){
            [self performSegueWithIdentifier:@"toCollectionView" sender:self];
        }else{
            [self performSegueWithIdentifier:@"toTableView" sender:self];
        }
    }else{
        [[Model sharedModel] downloadData];
        self.networkErrorView.hidden = false;
        
    }
}

- (IBAction)tryAgain:(id)sender {
    self.networkErrorView.hidden = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) isiPad
{
    static BOOL isIPad = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    });
    return isIPad;
}

@end
