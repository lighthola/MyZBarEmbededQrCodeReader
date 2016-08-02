//
//  TestCustomViewVC.m
//  TestZBarSDKEmbedReader
//
//  Created by Bevis Chen on 6/29/16.
//  Copyright © 2016 Bevis Chen. All rights reserved.
//

#import "TestCustomViewVC.h"
#import "TestXibVC.h"

@interface TestCustomViewVC () <CustomEmbedZBarReaderDelegate>
{
    // Have to Strong!!
    __strong IBOutlet CustomEmbedZBarReader *customEmbedZBarReader;
    __weak IBOutlet UILabel *infoLabel;
}

@end

@implementation TestCustomViewVC

- (void)viewDidLoad {
    [super viewDidLoad];

    customEmbedZBarReader.delegate = self;
    
    // ZBarReaderView Setting
    [customEmbedZBarReader setZBarReaderView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set QRcode scan region, this method have to put in viewDidAppear.
    [customEmbedZBarReader setScanRegionWithImage:[UIImage imageNamed:@"image3"]];
    [customEmbedZBarReader start];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [customEmbedZBarReader stop];
}

- (IBAction)goBtnPressed:(id)sender {
//    TestXibVC *testXibVC = [TestXibVC new];
//    [self.navigationController pushViewController:testXibVC animated:YES];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:infoLabel.text]];
//    UIWebView *myWebView = [UIWebView new];
//    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:infoLabel.text]]];
//    myWebView.frame = self.view.frame;
//    [self.view addSubview:myWebView];
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

        // Rotation Supporter
        [customEmbedZBarReader setRotationSupporterWithOrient:orient duration:duration];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        // do nothing
    }];
}

// for iOS 2.0 - 7.0
- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
                                 duration: (NSTimeInterval) duration
{
    // Rotation Supporter
    [customEmbedZBarReader setRotationSupporterWithOrient:orient duration:duration];
}

#pragma mark - CustomEmbedZBarReaderDelegate
-(void)CustomEmbedZBarReader:(CustomEmbedZBarReader *)readerView didReadText:(NSString *)text fromImage:(UIImage *)image
{
    infoLabel.text = text;
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
