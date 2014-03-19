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
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

SpecBegin(ASCScreenBrightnessDetector)

describe(@"when newly initialized", ^{

    __block ASCScreenBrightnessDetector *sut;
    __block UIScreen *mockScreen;
    before(^{
        mockScreen = mock([UIScreen class]);
        [given([mockScreen brightness]) willReturnFloat:0.7];
        sut = [[ASCScreenBrightnessDetector alloc] initWithScreen:mockScreen];
    });

    it(@"should not be nil", ^{
        expect(sut).notTo.beNil();
    });

    it(@"should be the correct Class", ^{
        expect(sut).to.beKindOf([ASCScreenBrightnessDetector class]);
    });

    it(@"should have a default threshold", ^{
        expect(sut.threshold).to.equal(0.5);
    });

    it(@"should have a delegate", ^{
        expect(sut.delegate).to.beNil;
    });

    it(@"should return the connect brightness style", ^{
        expect(sut.screenBrightnessStyle).to.equal(ASCScreenBrightnessStyleLight);
    });

    it(@"should return the correct screen", ^{
        expect(sut.screen).to.equal(mockScreen);
    });

    it(@"should retrun the correct brightness", ^{
        expect(sut.screenBrightness).to.equal(0.7);
    });

    it(@"should use the mainscreen in the designated initializer", ^{
        ASCScreenBrightnessDetector *sut = [ASCScreenBrightnessDetector new];
        expect(sut.screen).to.equal([UIScreen mainScreen]);
    });
});

SpecEnd
