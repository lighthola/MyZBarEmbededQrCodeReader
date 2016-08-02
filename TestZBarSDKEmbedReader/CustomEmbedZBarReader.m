//
//  CustomEmbedZBarReader.m
//  TestZBarSDKEmbedReader
//
//  Created by Bevis Chen on 6/28/16.
//  Copyright © 2016 Bevis Chen. All rights reserved.
//

#import "CustomEmbedZBarReader.h"


@interface CustomEmbedZBarReader()
{
    
}
@end

@implementation CustomEmbedZBarReader

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self baseInit];
        [self setBaseData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
        [self setBaseData];
    }
    return self;
}

-(void)baseInit
{
    // for xib
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    UIView *view = (UIView*)[views lastObject];
    view.frame = self.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:view];
}

-(void)setBaseData
{
    _readerView.readerDelegate = self;
    
    // set zbar camera simulator
    ZBarCameraSimulator *cameraSim = [[ZBarCameraSimulator alloc] initWithViewController:[self viewController]];
    cameraSim.readerView = _readerView;
}

#pragma mark - private methods
- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

#pragma mark - public methods
-(void)start
{
    [_readerView start];
}

-(void)stop
{
    [_readerView stop];
}

-(void)setZBarReaderView
{
    // 0 off 1 on
    _readerView.torchMode = 0;
    // default yes
    _readerView.tracksSymbols = NO;
    // default green
    _readerView.trackingColor = [UIColor redColor];
    // resize reader view, default 1.25 , 0 don't resize
    [_readerView setZoom:0 animated:NO];
    // enable pinch gesture recognition for zooming the preview/decode.
    // default yes
    _readerView.allowsPinchZoom = NO;
}

-(void)setRotationSupporterWithOrient:(UIInterfaceOrientation)orient duration:(NSTimeInterval)duration
{
    // make sure camera Won't rotate
    _readerView.previewTransform = CGAffineTransformIdentity;
    // compensate for view rotation so camera preview is not rotated
    [_readerView willRotateToInterfaceOrientation: orient duration: duration];
}

-(void)setScanRegionWithImage:(UIImage*)image
{
//    UIView *myView = [[UIView alloc] initWithFrame:_myImageView.bounds];
//    NSLog(@"frame:%@ , bounds:%@",NSStringFromCGRect(_myImageView.frame),NSStringFromCGRect(_myImageView.bounds));
//    NSLog(@"frame:%@ , bounds:%@",NSStringFromCGRect(_readerView.frame),NSStringFromCGRect(_readerView.bounds));
//    [_myImageView addSubview:myView];
//    myView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    
    _myImageView.image = image;
    
    CGFloat x,y,width,height;
    x = _myImageView.frame.origin.x / _readerView.bounds.size.width;
    y = _myImageView.frame.origin.y / _readerView.bounds.size.height;
    width = _myImageView.frame.size.width / _readerView.bounds.size.width;
    height = _myImageView.frame.size.height / _readerView.bounds.size.height;
    
    _readerView.scanCrop = CGRectMake(x, y, width, height);
    NSLog(@"x:%f , y:%f , width:%f , height:%f",x, y, width, height);
}

#pragma mark - ZBarReaderViewDelegate
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    
    ZBarSymbol* symbol = nil;
    for (symbol in symbols)
        break;
    
    [_delegate CustomEmbedZBarReader:self didReadText:symbol.data fromImage:image];
    NSLog(@"%@",symbol.data);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
