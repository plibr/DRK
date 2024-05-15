//
//  DRKEpubController.h
//  DRK
//
//  Created by Jumamidin on 13/5/24.
//

#import <Foundation/Foundation.h>


@class DRKEpubController;
@class DRKEpubContentModel;


@protocol DRKEpubControllerDelegate <NSObject>


- (void)epubController:(DRKEpubController *)controller didOpenEpub:(DRKEpubContentModel *)contentModel;

- (void)epubController:(DRKEpubController *)controller didFailWithError:(NSError *)error;

@optional

- (void)epubController:(DRKEpubController *)controller willOpenEpub:(NSURL *)epubURL;


@end


@interface DRKEpubController : NSObject


@property (nonatomic, weak) id<DRKEpubControllerDelegate> delegate;


@property (nonatomic, readonly, strong) NSURL *epubURL;

@property (nonatomic, readonly, strong) NSURL *destinationURL;

@property (nonatomic, readonly, strong) NSURL *epubContentBaseURL;

@property (nonatomic, readonly, strong) DRKEpubContentModel *contentModel;


- (instancetype)initWithEpubURL:(NSURL *)epubURL andDestinationFolder:(NSURL *)destinationURL;

- (void)openAsynchronous:(BOOL)asynchronous;


@end
