//
//  ViewController.m
//  TestZBarSDKEmbedReader
//
//  Created by Bevis Chen on 6/28/16.
//  Copyright © 2016 Bevis Chen. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
//    __weak IBOutlet ZBarReaderView *readerView;
    __weak IBOutlet UILabel *infoLabel;
    ZBarCameraSimulator *cameraSim;
    
}
@property (strong, nonatomic) IBOutlet ZBarReaderView *myReaderView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cameraSim = [[ZBarCameraSimulator alloc] initWithViewController:self];
    cameraSim.readerView = _myReaderView;
    
    _myReaderView.readerDelegate = self;
    _myReaderView.torchMode = 0;
    _myReaderView.tracksSymbols = NO;
    _myReaderView.trackingColor = [UIColor redColor];
    [_myReaderView setZoom:0 animated:NO];
    _myReaderView.allowsPinchZoom = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_myReaderView start];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_myReaderView stop];
}

#pragma mark - Detect Orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
//    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

// for iOS 8.0 or later
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        // To get current Orientation. If put this method outside of the block will get old Orientation.
        UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
        NSTimeInterval duration = [coordinator transitionDuration];
        
        // make sure camera Won't rotate
        _myReaderView.previewTransform = CGAffineTransformIdentity;
        // compensate for view rotation so camera preview is not rotated
        [_myReaderView willRotateToInterfaceOrientation: orient duration: duration];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        // do nothing
    }];
}

// for iOS 2.0 - 7.0
- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
                                 duration: (NSTimeInterval) duration
{
    // make sure camera Won't rotate
    _myReaderView.previewTransform = CGAffineTransformIdentity;
    // compensate for view rotation so camera preview is not rotated
    [_myReaderView willRotateToInterfaceOrientation: orient duration: duration];
}

#pragma mark - ZBarReaderViewDelegate
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    
    ZBarSymbol* symbol = nil;
    for (symbol in symbols)
        break;
    infoLabel.text = symbol.data;
}

#pragma mark - Others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
