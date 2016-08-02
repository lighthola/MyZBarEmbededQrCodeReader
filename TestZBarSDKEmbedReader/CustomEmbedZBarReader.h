//
//  CustomEmbedZBarReader.h
//  TestZBarSDKEmbedReader
//
//  Created by Bevis Chen on 6/28/16.
//  Copyright © 2016 Bevis Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarReaderView.h"
#import "ZBarCameraSimulator.h"

@class CustomEmbedZBarReader;
@protocol CustomEmbedZBarReaderDelegate <NSObject>

@required
-(void)CustomEmbedZBarReader:(CustomEmbedZBarReader *)readerView didReadText:(NSString *)text fromImage:(UIImage *)image;

@end

@interface CustomEmbedZBarReader : UIView <ZBarReaderViewDelegate>

@property (weak, nonatomic) id<CustomEmbedZBarReaderDelegate> delegate;
@property (strong, nonatomic) IBOutlet ZBarReaderView *readerView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

-(void)start;
-(void)stop;
-(void)setZBarReaderView;
-(void)setRotationSupporterWithOrient:(UIInterfaceOrientation)orient duration:(NSTimeInterval)duration;
-(void)setScanRegionWithImage:(UIImage*)image;
@end
