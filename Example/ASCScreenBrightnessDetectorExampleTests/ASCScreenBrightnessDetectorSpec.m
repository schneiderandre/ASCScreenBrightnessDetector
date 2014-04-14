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

describe(@"initWithScreen", ^{

    __block ASCScreenBrightnessDetector *sut;
    __block UIScreen *mockScreen;
    before(^{
        mockScreen = mock([UIScreen class]);
        [given([mockScreen brightness]) willReturnFloat:0.7f];
        sut = [[ASCScreenBrightnessDetector alloc] initWithScreen:mockScreen];
    });

    it(@"returns an instance of ASCScreenBrightnessDetector", ^{
        expect(sut).to.beInstanceOf([ASCScreenBrightnessDetector class]);
    });

    it(@"sets the screen", ^{
        expect(sut.screen).to.equal(mockScreen);
    });

    it(@"sets the default threshold", ^{
        expect(sut.threshold).to.equal(0.5f);
    });

    it(@"sets no delegate", ^{
        expect(sut.delegate).to.beNil;
    });

    it(@"sets the screenBrightnessStyle", ^{
        expect(sut.screenBrightnessStyle).to.equal(ASCScreenBrightnessStyleLight);
    });
});

describe(@"init", ^{
    it(@"uses the mainscreen", ^{
        ASCScreenBrightnessDetector *sut = [ASCScreenBrightnessDetector new];
        expect(sut.screen).to.equal([UIScreen mainScreen]);
    });
});

describe(@"brightnessDidChange", ^{

    __block UIViewController <ASCScreenBrightnessDetectorDelegate> *mockController;
    __block UIScreen *mockScreen;
    __block ASCScreenBrightnessDetector *sut;
    before(^{
        mockScreen = mock([UIScreen class]);
        mockController = mockObjectAndProtocol([UIViewController class],
                                               @protocol(ASCScreenBrightnessDetectorDelegate));
    });

    context(@"when old brightness below threshold", ^{

        before(^{
            [given([mockScreen brightness]) willReturnFloat:0.4f];
            sut = [[ASCScreenBrightnessDetector alloc] initWithScreen:mockScreen];
            sut.delegate = mockController;
        });

        context(@"and new brightness below threshold", ^{

            before(^{
                [given([mockScreen brightness]) willReturnFloat:0.2f];
                [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                                    object:mockScreen];
            });

            it(@"calls screenBrightnessDidChange", ^{
                [MKTVerify(mockController) screenBrightnessDidChange:0.2f];
            });

            it(@"does not call screenBrightnessStyleDidChange", ^{
                [[verifyCount(mockController, never()) withMatcher:anything()] screenBrightnessStyleDidChange:0];
            });
        });

        context(@"and new brightness above threshold", ^{

            before(^{
                [given([mockScreen brightness]) willReturnFloat:0.7f];
                [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                                    object:mockScreen];
            });

            it(@"calls screenBrightnessDidChange", ^{
                [MKTVerify(mockController) screenBrightnessDidChange:0.7f];
            });

            it(@"calls screenBrightnessStyleDidChange", ^{
                [MKTVerify(mockController) screenBrightnessStyleDidChange:ASCScreenBrightnessStyleLight];
            });
        });
    });

    context(@"when old brightness above threshold", ^{

        before(^{
            [given([mockScreen brightness]) willReturnFloat:0.7f];
            sut = [[ASCScreenBrightnessDetector alloc] initWithScreen:mockScreen];
            sut.delegate = mockController;
        });

        context(@"and new brightness above threshold", ^{

            before(^{
                [given([mockScreen brightness]) willReturnFloat:0.6f];
                [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                                    object:mockScreen];
            });

            it(@"calls screenBrightnessDidChange", ^{
                [MKTVerify(mockController) screenBrightnessDidChange:0.6f];
            });

            it(@"does not call screenBrightnessStyleDidChange", ^{
                [[verifyCount(mockController, never()) withMatcher:anything()] screenBrightnessStyleDidChange:0];
            });
        });

        context(@"and new brightness below threshold", ^{

            before(^{
                [given([mockScreen brightness]) willReturnFloat:0.4f];
                [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                                    object:mockScreen];
            });

            it(@"calls screenBrightnessDidChange", ^{
                [MKTVerify(mockController) screenBrightnessDidChange:0.4f];
            });

            it(@"calls screenBrightnessStyleDidChange", ^{
                [MKTVerify(mockController) screenBrightnessStyleDidChange:ASCScreenBrightnessStyleDark];
            });
        });
    });

});

describe(@"screenBrightness", ^{
    it(@"returns the brightness", ^{
        UIScreen *mockScreen = mock([UIScreen class]);
        [given([mockScreen brightness]) willReturnFloat:0.4f];
        ASCScreenBrightnessDetector *sut = [[ASCScreenBrightnessDetector alloc] initWithScreen:mockScreen];

        expect(sut.screenBrightness).to.equal(0.4f);
    });
});

describe(@"screenBrightnessStyle", ^{

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

    it(@"returns a dark style for a brightness below the threshold", ^{
        [given([mockScreen brightness]) willReturnFloat:0.4f];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                            object:mockScreen];
        expect(sut.screenBrightnessStyle).to.equal(ASCScreenBrightnessStyleDark);
    });

    it(@"returns a light style for a brightness above the threshold", ^{
        [given([mockScreen brightness]) willReturnFloat:0.6f];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                            object:mockScreen];
        expect(sut.screenBrightnessStyle).to.equal(ASCScreenBrightnessStyleLight);
    });

    it(@"returns a dark style for a brightness equal the threshold", ^{
        [given([mockScreen brightness]) willReturnFloat:0.5f];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIScreenBrightnessDidChangeNotification
                                                            object:mockScreen];
        expect(sut.screenBrightnessStyle).to.equal(ASCScreenBrightnessStyleDark);
    });
});

describe(@"threshhold", ^{
    it(@"returns the threshold", ^{
        ASCScreenBrightnessDetector *sut = [ASCScreenBrightnessDetector new];
        sut.threshold = 0.2f;

        expect(sut.threshold).to.equal(0.2f);
    });
});

SpecEnd
