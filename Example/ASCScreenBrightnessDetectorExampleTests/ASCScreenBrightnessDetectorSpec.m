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
        [given([mockScreen brightness]) willReturnFloat:0.7f];
        sut = [[ASCScreenBrightnessDetector alloc] initWithScreen:mockScreen];
    });

    it(@"should not be nil", ^{
        expect(sut).notTo.beNil();
    });

    it(@"should be the correct Class", ^{
        expect(sut).to.beKindOf([ASCScreenBrightnessDetector class]);
    });

    it(@"should have a default threshold", ^{
        expect(sut.threshold).to.equal(0.5f);
    });

    it(@"should have a delegate", ^{
        expect(sut.delegate).to.beNil;
    });

    it(@"should return the correct brightness style", ^{
        expect(sut.screenBrightnessStyle).to.equal(ASCScreenBrightnessStyleLight);
    });

    it(@"should return the correct screen", ^{
        expect(sut.screen).to.equal(mockScreen);
    });

    it(@"should return the correct brightness", ^{
        expect(sut.screenBrightness).to.equal(0.7f);
    });

    it(@"should use the mainscreen in the designated initializer", ^{
        ASCScreenBrightnessDetector *sut = [ASCScreenBrightnessDetector new];
        expect(sut.screen).to.equal([UIScreen mainScreen]);
    });
});



describe(@"when notificationcenter post a brightness did change notification", ^{

    __block UIViewController <ASCScreenBrightnessDetectorDelegate> *mockController;
    __block UIScreen *mockScreen;
    __block ASCScreenBrightnessDetector *sut;
    before(^{
        mockScreen = mock([UIScreen class]);
        [given([mockScreen brightness]) willReturnFloat:0.4f];
        sut = [[ASCScreenBrightnessDetector alloc] initWithScreen:mockScreen];
        mockController = mockObjectAndProtocol([UIViewController class],
                                               @protocol(ASCScreenBrightnessDetectorDelegate));
        sut.delegate = mockController;
    });

    context(@"also below the threshold", ^{
        before(^{
            [given([mockScreen brightness]) willReturnFloat:0.2f];
            [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                                object:mockScreen];
        });

        it(@"should call screen brightness did change on delegate", ^{
            [MKTVerify(mockController) screenBrightnessDidChange:0.2f];
        });

        it(@"should not call screen brightness style did change on delegate", ^{
            [[verifyCount(mockController, never()) withMatcher:anything()] screenBrightnessStyleDidChange:0];
        });
    });

    context(@"above the threshold", ^{
        before(^{
            [given([mockScreen brightness]) willReturnFloat:0.7f];
            [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                                object:mockScreen];
        });

        it(@"should call screen brightness did change on delegate", ^{
            [MKTVerify(mockController) screenBrightnessDidChange:0.7f];
        });

        it(@"should call screen brightness style did change on delegate", ^{
            [MKTVerify(mockController) screenBrightnessStyleDidChange:ASCScreenBrightnessStyleLight];
        });
    });
});

SpecEnd
