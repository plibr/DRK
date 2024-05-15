//
//  DRKEpubContentModel.h
//  DRK
//
//  Created by Jumamidin on 13/5/24.
//

#import <Foundation/Foundation.h>
#import "DRKEpubConstants.h"

@interface DRKEpubContentModel : NSObject


@property (nonatomic) DRKEpubKitBookType bookType;
@property (nonatomic) DRKEpubKitBookEncryption bookEncryption;

@property (nonatomic, strong) NSDictionary *metaData;
@property (nonatomic, strong) NSString *coverPath;
@property (nonatomic, strong) NSDictionary *manifest;
@property (nonatomic, strong) NSArray *spine;
@property (nonatomic, strong) NSArray *guide;
@property (nonatomic, assign) BOOL isRTL;


@end
