//
//  TopLabel.h
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/25.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface TopLabel : UILabel
{
    @private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
