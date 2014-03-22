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

describe(@"when screen brightness did change", ^{

    __block UIViewController <ASCScreenBrightnessDetectorDelegate> *mockController;
    __block UIScreen *mockScreen;
    __block ASCScreenBrightnessDetector *sut;
    before(^{
        mockScreen = mock([UIScreen class]);
        mockController = mockObjectAndProtocol([UIViewController class],
                                               @protocol(ASCScreenBrightnessDetectorDelegate));
    });

    context(@"and old brightness is below threshold", ^{

        before(^{
            [given([mockScreen brightness]) willReturnFloat:0.4f];
            sut = [[ASCScreenBrightnessDetector alloc] initWithScreen:mockScreen];
            sut.delegate = mockController;
        });

        context(@"and new brightness is below threshold", ^{

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

        context(@"and new brightness is above threshold", ^{

            before(^{
                [given([mockScreen brightness]) willReturnFloat:0.7f];
                [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                                    object:mockScreen];
            });

            it(@"should call screen brightness did change on delegate", ^{
                [MKTVerify(mockController) screenBrightnessDidChange:0.7f];
            });

            it(@"should call screen brightness style did change to light on delegate", ^{
                [MKTVerify(mockController) screenBrightnessStyleDidChange:ASCScreenBrightnessStyleLight];
            });
        });
    });

    context(@"and old brightness is above threshold", ^{

        before(^{
            [given([mockScreen brightness]) willReturnFloat:0.7f];
            sut = [[ASCScreenBrightnessDetector alloc] initWithScreen:mockScreen];
            sut.delegate = mockController;
        });

        context(@"and new brightness is above threshold", ^{

            before(^{
                [given([mockScreen brightness]) willReturnFloat:0.6f];
                [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                                    object:mockScreen];
            });

            it(@"should call screen brightness did change on delegate", ^{
                [MKTVerify(mockController) screenBrightnessDidChange:0.6f];
            });

            it(@"should not call screen brightness style did change on delegate", ^{
                [[verifyCount(mockController, never()) withMatcher:anything()] screenBrightnessStyleDidChange:0];
            });
        });

        context(@"and new brightness is below threshold", ^{

            before(^{
                [given([mockScreen brightness]) willReturnFloat:0.4f];
                [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                                    object:mockScreen];
            });

            it(@"should call screen brightness did change on delegate", ^{
                [MKTVerify(mockController) screenBrightnessDidChange:0.4f];
            });

            it(@"should call screen brightness style did change to dark on delegate", ^{
                [MKTVerify(mockController) screenBrightnessStyleDidChange:ASCScreenBrightnessStyleDark];
            });
        });
    });

});

describe(@"when calling screenBrightness", ^{
    it(@"should return the correct brightness", ^{
        UIScreen *mockScreen = mock([UIScreen class]);
        [given([mockScreen brightness]) willReturnFloat:0.4f];
        ASCScreenBrightnessDetector *sut = [[ASCScreenBrightnessDetector alloc] initWithScreen:mockScreen];

        expect(sut.screenBrightness).to.equal(0.4f);
    });
});

describe(@"when calling screenBrightnessStyle", ^{

    __block UIScreen *mockScreen;
    __block ASCScreenBrightnessDetector *sut;
    before(^{
        mockScreen = mock([UIScreen class]);
        sut = [[ASCScreenBrightnessDetector alloc] initWithScreen:mockScreen];
    });

    after(^{
        mockScreen = nil;
        sut = nil;
    });

    it(@"should return a dark style for a brightness below the threshold", ^{
        [given([mockScreen brightness]) willReturnFloat:0.4f];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                            object:mockScreen];
        expect(sut.screenBrightnessStyle).to.equal(ASCScreenBrightnessStyleDark);
    });

    it(@"should return a light style for a brightness above the threshold", ^{
        [given([mockScreen brightness]) willReturnFloat:0.6f];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                            object:mockScreen];
        expect(sut.screenBrightnessStyle).to.equal(ASCScreenBrightnessStyleLight);
    });

    it(@"should return a dark style for a brightness equal the threshold", ^{
        [given([mockScreen brightness]) willReturnFloat:0.5f];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                            object:mockScreen];
        expect(sut.screenBrightnessStyle).to.equal(ASCScreenBrightnessStyleDark);
    });
});

describe(@"when changing the threshhold", ^{
    it(@"should return the correct threshold", ^{
        ASCScreenBrightnessDetector *sut = [ASCScreenBrightnessDetector new];
        sut.threshold = 0.2f;

        expect(sut.threshold).to.equal(0.2f);
    });
});

SpecEnd
