//
//  MlChartView.m
//  MoodLog
//
//  Created by Barry Langdon-Lassagne on 6/11/13.
//  Copyright (c) 2013 Barry A. Langdon-Lassagne. All rights reserved.
//

#import "MlChartView.h"

@implementation MlChartView

- (void)setBounds:(CGRect)bounds {
    NSLog(@"Chart View: %@", NSStringFromCGRect(bounds));
    [super setBounds:bounds];
}

@end