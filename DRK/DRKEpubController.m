//
//  DRKEpubController.m
//  DRK
//
//  Created by Jumamidin on 13/5/24.
//

#import "DRKEpubController.h"
#import "DRKEpubConstants.h"
#import "DRKEpubExtractor.h"
#import "DRKEpubParser.h"
#import "DRKEpubContentModel.h"


@interface DRKEpubController ()<DRKEpubExtractorDelegate>


@property (nonatomic, strong) DRKEpubExtractor *extractor;
@property (nonatomic, strong) DRKEpubParser *parser;


@end


@implementation DRKEpubController


- (instancetype)initWithEpubURL:(NSURL *)epubURL andDestinationFolder:(NSURL *)destinationURL
{
    self = [super init];
    if (self)
    {
        _epubURL = epubURL;
        _destinationURL = destinationURL;
    }
    return self;
}


- (void)openAsynchronous:(BOOL)asynchronous
{
    self.extractor = [[DRKEpubExtractor alloc] initWithEpubURL:self.epubURL andDestinationURL:self.destinationURL];
    self.extractor.delegate = self;
    [self.extractor start:asynchronous];
}


#pragma mark DRKEpubExtractorDelegate Methods


- (void)epubExtractorDidStartExtracting:(DRKEpubExtractor *)epubExtractor
{
    if ([self.delegate respondsToSelector:@selector(epubController:willOpenEpub:)])
    {
        [self.delegate epubController:self willOpenEpub:self.epubURL];
    }
}


- (void)epubExtractorDidFinishExtracting:(DRKEpubExtractor *)epubExtractor
{
    self.parser = [DRKEpubParser new];
    NSURL *rootFile = [self.parser rootFileForBaseURL:self.destinationURL];
    
    if (!rootFile) {
        NSError *error = [NSError errorWithDomain:DRKEpubKitErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"No root file"}];
        [self.delegate epubController:self didFailWithError:error];
        return;
    }
    
    _epubContentBaseURL = [rootFile URLByDeletingLastPathComponent];
    
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfURL:rootFile encoding:NSUTF8StringEncoding error:&error];
    DDXMLDocument *document = [[DDXMLDocument alloc] initWithXMLString:content options:kNilOptions error:&error];
    if (document)
    {
        _contentModel = [DRKEpubContentModel new];
        
        self.contentModel.bookType = [self.parser bookTypeForBaseURL:self.destinationURL];
        self.contentModel.bookEncryption = [self.parser contentEncryptionForBaseURL:self.destinationURL];
        self.contentModel.metaData = [self.parser metaDataFromDocument:document];
        self.contentModel.coverPath = [self.parser coverPathComponentFromDocument:document];
        self.contentModel.isRTL = [self.parser isRTLFromDocument:document];
        
        if (!self.contentModel.metaData)
        {
            NSError *error = [NSError errorWithDomain:DRKEpubKitErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"No meta data found"}];
            [self.delegate epubController:self didFailWithError:error];
        }
        else
        {
            self.contentModel.manifest = [self.parser manifestFromDocument:document];
            self.contentModel.spine = [self.parser spineFromDocument:document];
            self.contentModel.guide = [self.parser guideFromDocument:document];

            if (self.delegate)
            {
                [self.delegate epubController:self didOpenEpub:self.contentModel];
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:DRKEpubKitErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"No document found"}];
        [self.delegate epubController:self didFailWithError:error];
    }
}


- (void)epubExtractor:(DRKEpubExtractor *)epubExtractor didFailWithError:(NSError *)error
{
    if (self.delegate)
    {
        [self.delegate epubController:self didFailWithError:error];
    }
}


@end
