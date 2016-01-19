//
//  Model.h
//  Grability
//
//  Created by Camilo Morales on 12/1/16.
//  Copyright © 2016 Camilo Morales. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "AppEntry.h"
#import <UIKit/UIKit.h>

@interface Model : NSObject

@property (nonatomic, strong, readonly) NSArray<AppEntry *> *filteredEntries;
@property (nonatomic, strong, readonly) NSArray *availableCategories;

+ (Model *) sharedModel;

- (void)filterEntriesWithCategory:(NSString *)category;

- (void)saveImage:(UIImage *) image AppID:(NSString *) appID;
- (UIImage *)loadImageWithAppID:(NSString *) appID;

- (void)downloadData;
@end
