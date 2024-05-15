//
//  DRKEpubConstants.h
//  DRK
//
//  Created by Jumamidin on 13/5/24.
//

#import <Foundation/Foundation.h>


extern NSString *const DRKEpubKitErrorDomain;


typedef NS_ENUM(NSUInteger, DRKEpubKitBookType)
{
    DRKEpubKitBookTypeUnknown,
    DRKEpubKitBookTypeEpub2,
    DRKEpubKitBookTypeEpub3,
    DRKEpubKitBookTypeiBook
};


typedef NS_ENUM(NSUInteger, DRKEpubKitBookEncryption)
{
    DRKEpubKitBookEnryptionNone,
    DRKEpubKitBookEnryptionFairplay
};


@interface DRKEpubConstants : NSObject

@end
