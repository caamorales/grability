//
//  Model.m
//  Grability
//
//  Created by Camilo Morales on 12/1/16.
//  Copyright © 2016 Camilo Morales. All rights reserved.
//

#import "Model.h"
#import "AppEntry.h"

@interface Model ()
@property (nonatomic, strong) NSArray<AppEntry *> *entries;
@property (nonatomic, strong, readwrite) NSArray<AppEntry *> *filteredEntries;
@property (nonatomic, strong, readwrite) NSArray *availableCategories;
@end

static Model *shared = NULL;
typedef void(^requestCompletion)(NSDictionary *data, NSError *error);

@implementation Model

+ (Model *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init{
    self = [super init];
    if (self) {
        [self downloadData];
    }
    return self;
}

- (void)performRequestWithMethod:(NSString *)method url:(NSString *) url data:(NSDictionary *)requestData completion:(requestCompletion) completion
{
    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    [payload addEntriesFromDictionary:requestData];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (requestData) {
        NSError *dataEncodingError;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:payload options:kNilOptions error:&dataEncodingError];
        if (!dataEncodingError) [request setHTTPBody:jsonData];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (!connectionError) {
            NSError *decodingError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&decodingError];
            completion(json, decodingError);
        }else{
            completion(nil, connectionError);
        }
    }];
}

- (void)downloadData{
    
        [self performRequestWithMethod:@"GET" url:TARGET_URL data:nil completion:^(NSDictionary *data, NSError *error) {
            
            if (!error && data) {
                self.entries = [self parseData:data[@"feed"][@"entry"]];
                [self saveFileToCacheLibraryWithData:[NSKeyedArchiver archivedDataWithRootObject:data[@"feed"][@"entry"]] name:@"posts.cache"];
            
                [[NSNotificationCenter defaultCenter] postNotificationName:DATA_READY_NOTIFICATION object:nil];
            }else{
                if ([self loadFileFromCacheLibraryWithName:@"posts.cache"]){
                   // self.entries = [NSDictionar ][self loadFileFromCacheLibraryWithName:@"posts.cache"];
                    self.entries = [self parseData:[NSKeyedUnarchiver unarchiveObjectWithData:[self loadFileFromCacheLibraryWithName:@"posts.cache"]]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:DATA_READY_NOTIFICATION object:nil];
                }else{
                    self.entries = nil;
                    [[NSNotificationCenter defaultCenter] postNotificationName:DATA_READY_NOTIFICATION object:nil userInfo:error ? @{@"error": error.localizedDescription} : nil];
                }

            }
            
        }];
}

- (NSMutableArray <AppEntry *> *)parseData:(NSMutableArray *) data{
    
    NSMutableArray<AppEntry *> *parsedData = [[NSMutableArray alloc] initWithCapacity:data.count];
    NSMutableSet *availCat = [[NSMutableSet alloc] init];
    for (NSDictionary *anEntry in data) {
        AppEntry *entry = [[AppEntry alloc] init];
        entry.iconURL = [anEntry[ENTRY_ICON_KEY] lastObject][ENTRY_LABEL_KEY];
        entry.summary = anEntry[ENTRY_SUMMARY_KEY][ENTRY_LABEL_KEY];
        entry.price = anEntry[ENTRY_PRICE_KEY][ENTRY_LABEL_KEY];
        entry.rights = anEntry[ENTRY_RIGHTS_KEY][ENTRY_LABEL_KEY];
        entry.title = anEntry[ENTRY_TITLE_KEY][ENTRY_LABEL_KEY];
        entry.linkURL = anEntry[ENTRY_LINK_KEY][ENTRY_ATTRIBUTES_KEY][ENTRY_LINK_URL_KEY];
        entry.idNumber = anEntry[ENTRY_ID_KEY][ENTRY_ATTRIBUTES_KEY][ENTRY_ID_ATTRIBUTES_ID_KEY];
        entry.category = anEntry[ENTRY_CATEGORY_KEY][ENTRY_ATTRIBUTES_KEY][ENTRY_LABEL_KEY];
        [parsedData addObject:entry];
        [availCat addObject:entry.category];
    }
    
    self.availableCategories = [availCat allObjects];
    return parsedData;
}

#pragma mark Filtering 

- (void)filterEntriesWithCategory:(NSString *)category{
    NSPredicate *filteringPredicate = [NSPredicate predicateWithFormat:@"category == %@",category];
    self.filteredEntries = [self.entries filteredArrayUsingPredicate:filteringPredicate];
}

#pragma mark Cache Storage

- (void)saveFileToCacheLibraryWithData:(NSData *)data name:(NSString *) name
{
    if (data != nil)
    {
        [data writeToFile:[self pathForFileName:name] atomically:YES];
    }
}

- (NSData *)loadFileFromCacheLibraryWithName:(NSString *)name
{
    return [NSData dataWithContentsOfFile:[self pathForFileName:name]];
}

- (NSString *)pathForFileName:(NSString *) name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"/%@",name]];
}

- (void)saveImage:(UIImage *) image AppID:(NSString *) appID{
    [self saveImageToCacheLibrary:image name:appID];
}

- (UIImage *)loadImageWithAppID:(NSString *) appID{
    return [self loadImageFromCacheLibraryWithName:appID];
}

- (void)saveImageToCacheLibrary:(UIImage*)image name:(NSString *) name
{
    name = [NSString stringWithFormat:@"%@%@",name,@".icon"];
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"/%@",name]];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

- (UIImage*)loadImageFromCacheLibraryWithName:(NSString *)name
{
    name = [NSString stringWithFormat:@"%@%@",name,@".icon"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"/%@",name]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

@end
