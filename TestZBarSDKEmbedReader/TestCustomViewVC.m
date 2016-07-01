//
//  TestCustomViewVC.m
//  TestZBarSDKEmbedReader
//
//  Created by Bevis Chen on 6/29/16.
//  Copyright © 2016 Bevis Chen. All rights reserved.
//

#import "TestCustomViewVC.h"
#import "TestXibVC.h"

@interface TestCustomViewVC ()
{
    // Have to Strong!!
    __strong IBOutlet CustomEmbedZBarReader *customEmbedZBarReader;
    __weak IBOutlet UILabel *infoLabel;
    ZBarCameraSimulator *cameraSim;
    ZBarReaderView *readerView;
}

@end

@implementation TestCustomViewVC

- (void)viewDidLoad {
    [super viewDidLoad];

    readerView = customEmbedZBarReader.readerView;
    cameraSim = [[ZBarCameraSimulator alloc] initWithViewController:self];
    cameraSim.readerView = readerView;
    
    readerView.readerDelegate = self;
    // ZBarReaderView Setting
    [customEmbedZBarReader setZBarReaderView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set QRcode scan region, this method have to put in viewDidAppear.
    [customEmbedZBarReader setScanRegion];
    [readerView start];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [readerView stop];
}

- (IBAction)goBtnPressed:(id)sender {
    TestXibVC *testXibVC = [TestXibVC new];
    [self.navigationController pushViewController:testXibVC animated:YES];
}


#pragma mark - Detect Orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

// for iOS 8.0 or later
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        // To get current Orientation. If put this method outside of the block will get old Orientation.
        UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
        NSTimeInterval duration = [coordinator transitionDuration];

        // make sure camera Won't rotate
        readerView.previewTransform = CGAffineTransformIdentity;
        // compensate for view rotation so camera preview is not rotated
        [readerView willRotateToInterfaceOrientation: orient duration: duration];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        // do nothing
    }];
}

// for iOS 2.0 - 7.0
- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
                                 duration: (NSTimeInterval) duration
{
    // make sure camera Won't rotate
    readerView.previewTransform = CGAffineTransformIdentity;
    // compensate for view rotation so camera preview is not rotated
    [readerView willRotateToInterfaceOrientation: orient duration: duration];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
