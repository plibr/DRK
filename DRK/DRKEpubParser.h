//
//  DRKEpubParser.h
//  DRK
//
//  Created by Jumamidin on 13/5/24.
//

#import <Foundation/Foundation.h>
#import "DRKEpubConstants.h"
#import <KissXML/DDXMLDocument.h>

@class DRKEpubParser;


@interface DRKEpubParser : NSObject


- (DRKEpubKitBookType)bookTypeForBaseURL:(NSURL *)baseURL;

- (DRKEpubKitBookEncryption)contentEncryptionForBaseURL:(NSURL *)baseURL;

- (NSURL *)rootFileForBaseURL:(NSURL *)baseURL;

- (NSString *)coverPathComponentFromDocument:(DDXMLDocument *)document;

- (NSDictionary *)metaDataFromDocument:(DDXMLDocument *)document;

- (NSArray *)spineFromDocument:(DDXMLDocument *)document;

- (BOOL)isRTLFromDocument:(DDXMLDocument *)document;

- (NSDictionary *)manifestFromDocument:(DDXMLDocument *)document;

- (NSArray *)guideFromDocument:(DDXMLDocument *)document;


@end
