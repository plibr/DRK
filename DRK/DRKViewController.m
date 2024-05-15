//
//  DRKViewController.m
//  DRK
//
//  Created by Jumamidin on 13/5/24.
//

#import "DRKViewController.h"
#import "DRKEpubController.h"
#import "DRKEpubContentModel.h"

@interface DRKViewController ()<DRKEpubControllerDelegate, UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet WKWebView *webView;

@property (nonatomic, strong) DRKEpubController *epubController;

@property (nonatomic, strong) DRKEpubContentModel *contentModel;

@property (nonatomic) NSUInteger spineIndex;


@end


@implementation DRKViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *epubURL = [[NSBundle mainBundle] URLForResource:@"Winnie-the-Pooh" withExtension:@"epub"];
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    self.epubController = [[DRKEpubController alloc] initWithEpubURL:epubURL andDestinationFolder:documentsURL];
    self.epubController.delegate = self;
    [self.epubController openAsynchronous:YES];
    
    UISwipeGestureRecognizer *swipeRecognizer;
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRecognizer.delegate = self;
    [self.webView addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRecognizer.delegate = self;
    [self.webView addGestureRecognizer:swipeRecognizer];
}


- (void)didSwipeRight:(UIGestureRecognizer *)recognizer
{
    if (self.spineIndex > 1)
    {
        self.spineIndex--;
        [self updateContentForSpineIndex:self.spineIndex];
    }
    NSLog(@"didSwipeRight method");
}


- (void)didSwipeLeft:(UIGestureRecognizer *)recognizer
{
    if (self.spineIndex < self.contentModel.spine.count)
    {
        self.spineIndex++;
        [self updateContentForSpineIndex:self.spineIndex];
    }
    NSLog(@"didSwipeLeft method");
}


#pragma mark Epub Contents


- (void)updateContentForSpineIndex:(NSUInteger)currentSpineIndex
{
    NSString *contentFile = self.contentModel.manifest[self.contentModel.spine[currentSpineIndex]][@"href"];
    NSLog(@"content File :%@", contentFile);
    NSURL *contentURL = [self.epubController.epubContentBaseURL URLByAppendingPathComponent:contentFile];
    NSLog(@"content URL :%@", contentURL);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:contentURL];
    [self.webView loadRequest:request];
}


#pragma mark KFEpubControllerDelegate Methods


- (void)epubController:(DRKEpubController *)controller willOpenEpub:(NSURL *)epubURL
{
    NSLog(@"will open epub");
}


- (void)epubController:(DRKEpubController *)controller didOpenEpub:(DRKEpubContentModel *)contentModel
{
    NSLog(@"opened: %@", contentModel.metaData[@"title"]);
    self.contentModel = contentModel;
    self.spineIndex = 4;
    [self updateContentForSpineIndex:self.spineIndex];
}


- (void)epubController:(DRKEpubController *)controller didFailWithError:(NSError *)error
{
    NSLog(@"epubController:didFailWithError: %@", error.description);
}


#pragma mark - UIGestureRecognizerDelegate Methods


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end

