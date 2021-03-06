//
//  MlChartCollectionViewCell.m
//  MoodLog
//
//  Created by Barry A. Langdon-Lassagne on 2/22/13.
//  Copyright (c) 2013 Barry A. Langdon-Lassagne.
//  See LICENSE.rtf for full license agreement.
//

#import "MlChartCollectionViewCell.h"
#import "MlChartCellEntryViewController.h"

@implementation MlChartCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)pressDetailButton:(id)sender {
    self.myViewController.detailItem = self.detailItem;
    [self.myViewController performSegueWithIdentifier:@"chartCellDetail" sender:self.myViewController];
}
@end
