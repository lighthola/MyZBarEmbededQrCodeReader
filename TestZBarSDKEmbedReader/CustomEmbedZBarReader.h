//
//  CustomEmbedZBarReader.h
//  TestZBarSDKEmbedReader
//
//  Created by Bevis Chen on 6/28/16.
//  Copyright © 2016 Bevis Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarReaderView.h"

@interface CustomEmbedZBarReader : UIView

@property (strong, nonatomic) IBOutlet ZBarReaderView *readerView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

-(void)setZBarReaderView;
-(void)setScanRegion;
@end
