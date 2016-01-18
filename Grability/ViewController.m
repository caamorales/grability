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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Model sharedModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReady) name:DATA_READY_NOTIFICATION object:nil];
}

- (void)dataReady{
    if ([self isiPad]){
        [self performSegueWithIdentifier:@"toCollectionView" sender:self];
    }else{
        [self performSegueWithIdentifier:@"toTableView" sender:self];
    }
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
