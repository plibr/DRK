//
//  DRKEpubExtractor.h
//  DRK
//
//  Created by Jumamidin on 13/5/24.
//

#import <Foundation/Foundation.h>

@class DRKEpubExtractor;

@protocol DRKEpubExtractorDelegate <NSObject>


- (void)epubExtractorDidFinishExtracting:(DRKEpubExtractor *)epubExtractor;

- (void)epubExtractor:(DRKEpubExtractor *)epubExtractor didFailWithError:(NSError *)error;

@optional

- (void)epubExtractorDidStartExtracting:(DRKEpubExtractor *)epubExtractor;

- (void)epubExtractorDidCancelExtraction:(DRKEpubExtractor *)epubExtractor;

@end


@interface DRKEpubExtractor : NSObject


@property (nonatomic, weak) id<DRKEpubExtractorDelegate> delegate;

@property (nonatomic, readonly) NSURL *epubURL;

@property (nonatomic, readonly) NSURL *destinationURL;


- (id)initWithEpubURL:(NSURL *)epubURL andDestinationURL:(NSURL *)destinationURL;

- (BOOL)start:(BOOL)asynchronous;

- (void)cancel;


@end
