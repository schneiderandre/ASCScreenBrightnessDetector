//
//  ASCScreenBrightnessDetectorSpec.m
//  ASCScreenBrightnessDetectorExample
//
//  Created by André Schneider on 18.03.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "ASCScreenBrightnessDetector.h"

SpecBegin(ASCScreenBrightnessDetector)

describe(@"when newly initialized", ^{

    __block ASCScreenBrightnessDetector *sut;
    before(^{
        sut = [ASCScreenBrightnessDetector new];
    });

    it(@"should have a default threshold", ^{
        expect(sut.threshold).to.equal(0.5);
    });

    it(@"should have a brightness style", ^{
        expect(sut.screenBrightnessStyle).to.equal(ASCScreenBrightnessStyleDark);
    });
});

SpecEnd
