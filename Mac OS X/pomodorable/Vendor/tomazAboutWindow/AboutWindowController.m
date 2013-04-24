//
//  AboutWindowController.m
//  ScrollingAboutWindow
//
//  Created by Tomaž Kragelj on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AboutWindowController.h"

static CGFloat kAboutWindowCreditsAnimationDuration = 30.0;
static CGFloat kAboutWindowCreditsFadeHeight = 6.0;
static CGColorRef kAboutWindowCreditsFadeColor1 = NULL;
static CGColorRef kAboutWindowCreditsFadeColor2 = NULL;

#pragma mark -

@interface AboutWindowController ()
@property (weak, nonatomic, readonly) NSString *applicationNameString;
@property (weak, nonatomic, readonly) NSString *applicationVersionString;
@property (weak, nonatomic, readonly) NSString *applicationBuildNumberString;
@property (weak, nonatomic, readonly) NSString *applicationCopyrightString;
@property (nonatomic, assign) BOOL isCreditsAnimationActive;
@end

#pragma mark -

@interface AboutWindowController (ScrollingCredits)
- (void)startCreditsScrollAnimation;
- (void)stopCreditsScrollAnimation;
- (void)resetCreditsScrollPosition;
- (CGSize)sizeForAttributedString:(NSAttributedString *)string inWidth:(CGFloat)width;
@property (nonatomic, readonly) CGFloat creditsFadeHeightCompensation;
@property (nonatomic, readonly) CALayer *creditsRootLayer;
@property (nonatomic, readonly) CAGradientLayer *creditsTopFadeLayer;
@property (nonatomic, readonly) CAGradientLayer *creditsBottomFadeLayer;
@property (nonatomic, readonly) CATextLayer *creditsTextLayer;
@end

#pragma mark -

@implementation AboutWindowController {
	CALayer *_creditsRootLayer;
	CAGradientLayer *_creditsTopFadeLayer;
	CAGradientLayer *_creditsBottomFadeLayer;
	CATextLayer *_creditsTextLayer;
}

@synthesize isCreditsAnimationActive;
@synthesize applicationNameLabel;
@synthesize applicationVersionLabel;
@synthesize punchLineLabel;
@synthesize copyrightLabel;
@synthesize creditsView;

#pragma mark - Initialization & disposal

+ (void)initialize {
	kAboutWindowCreditsFadeColor1 = CGColorCreateGenericGray(1.0, 1.0);
	kAboutWindowCreditsFadeColor2 = CGColorCreateGenericGray(1.0, 0.0);
}

- (id)init {
    self = [super initWithWindowNibName:@"AboutWindow"];
    return self;
}

#pragma mark - Window lifecycle

- (void)awakeFromNib {
	NSString *versionFormat = NSLocalizedString(@"Version %@ (%@)", nil);
	NSString *versionString = [NSString stringWithFormat:versionFormat, self.applicationVersionString, self.applicationBuildNumberString];
	self.applicationNameLabel.stringValue = self.applicationNameString;
	self.punchLineLabel.stringValue = NSLocalizedString(@"Time based productivity application for OS X", nil);
	self.creditsView.layer = self.creditsRootLayer;
	self.creditsView.wantsLayer = YES;
	[self.applicationVersionLabel.cell setPlaceholderString:versionString];
	[self.copyrightLabel.cell setPlaceholderString:self.applicationCopyrightString];
}

- (void)showWindow:(id)sender 
{
	[super showWindow:sender];
	[self startCreditsScrollAnimation];
}

- (void)windowWillClose:(NSNotification *)note 
{
	[self stopCreditsScrollAnimation];
}

#pragma mark - User actions

- (IBAction)getInTouch:(id)sender 
{
	NSURL *url = [NSURL URLWithString:@"http://www.monoclesociety.com/r/eggscellent/support"];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

#pragma mark - Properties

- (NSString *)applicationNameString {
	return [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
}

- (NSString *)applicationVersionString {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)applicationBuildNumberString {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSString *)applicationCopyrightString {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSHumanReadableCopyright"];
}

@end

#pragma mark -

@implementation AboutWindowController (ScrollingCredits)

#pragma mark - Higher level 

- (void)startCreditsScrollAnimation {
	CATextLayer *creditsLayer = self.creditsTextLayer;
	CGFloat viewHeight = self.creditsView.bounds.size.height;
	CGFloat fadeCompensation = self.creditsFadeHeightCompensation;
	
	// Enable animation and reset.
	self.isCreditsAnimationActive = YES;
	[self resetCreditsScrollPosition];
	
	// Animate to top and execute animation again - resulting in endless loop.
	[CATransaction begin];
	[CATransaction setAnimationDuration:kAboutWindowCreditsAnimationDuration];
	[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	[CATransaction setCompletionBlock:^{ 
		if (!self.isCreditsAnimationActive) return;
		[self startCreditsScrollAnimation];
	}];
	creditsLayer.position = CGPointMake(0.0, viewHeight - fadeCompensation);
	[CATransaction commit];
}

- (void)stopCreditsScrollAnimation {
	self.isCreditsAnimationActive = NO;
	[self resetCreditsScrollPosition];
}

- (void)resetCreditsScrollPosition {
	CATextLayer *creditsLayer = self.creditsTextLayer;
	CGFloat textHeight = creditsLayer.frame.size.height;
	CGFloat fadeCompensation = self.creditsFadeHeightCompensation;
	
	[CATransaction begin];
	[CATransaction setAnimationDuration:0.0];
	creditsLayer.position = CGPointMake(0.0, -textHeight + fadeCompensation);
	[CATransaction commit];
}

- (CGFloat)creditsFadeHeightCompensation {
	return self.creditsTopFadeLayer.frame.size.height - 2.0;
}

#pragma mark - Core Animation layers

- (CATextLayer *)creditsTextLayer {
	if (_creditsTextLayer) return _creditsTextLayer;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Credits" ofType:@"rtf"];
	NSAttributedString *credits = [[NSAttributedString alloc] initWithPath:path documentAttributes:nil];
	CGSize size = [self sizeForAttributedString:credits inWidth:self.creditsView.bounds.size.width];
	_creditsTextLayer = [CATextLayer layer];
	_creditsTextLayer.wrapped = YES;
	_creditsTextLayer.string = credits;
	_creditsTextLayer.anchorPoint = CGPointMake(0.0, 0.0);
	_creditsTextLayer.frame = CGRectMake(0.0, 0.0, size.width, size.height);
	return _creditsTextLayer;
}

- (CAGradientLayer *)creditsTopFadeLayer {
	if (_creditsTopFadeLayer) return _creditsTopFadeLayer;
	CGColorRef color1 = kAboutWindowCreditsFadeColor1;
	CGColorRef color2 = kAboutWindowCreditsFadeColor2;
	CGFloat height = kAboutWindowCreditsFadeHeight;
	_creditsTopFadeLayer = [CAGradientLayer layer];
	_creditsTopFadeLayer.colors = [NSArray arrayWithObjects:(__bridge id)color1, (__bridge id)color2, nil];
	_creditsTopFadeLayer.frame = CGRectMake(0.0, 0.0, self.creditsView.bounds.size.width, height);
	return _creditsTopFadeLayer;
}

- (CAGradientLayer *)creditsBottomFadeLayer {
	if (_creditsBottomFadeLayer) return _creditsBottomFadeLayer;
	CGColorRef color1 = kAboutWindowCreditsFadeColor1;
	CGColorRef color2 = kAboutWindowCreditsFadeColor2;
	CGFloat height = kAboutWindowCreditsFadeHeight;
	_creditsBottomFadeLayer = [CAGradientLayer layer];
	_creditsBottomFadeLayer.colors = [NSArray arrayWithObjects:(__bridge id)color2, (__bridge id)color1, nil];
	_creditsBottomFadeLayer.frame = CGRectMake(0.0, self.creditsView.bounds.size.height - height, self.creditsView.bounds.size.width, height);
	return _creditsBottomFadeLayer;
}

- (CALayer *)creditsRootLayer {
	if (_creditsRootLayer) return _creditsRootLayer;
	_creditsRootLayer = [CALayer layer];
	[_creditsRootLayer addSublayer:self.creditsTextLayer];
	[_creditsRootLayer addSublayer:self.creditsTopFadeLayer];
	[_creditsRootLayer addSublayer:self.creditsBottomFadeLayer];
	return _creditsRootLayer;
}

- (CGSize)sizeForAttributedString:(NSAttributedString *)string inWidth:(CGFloat)width {
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);
    CFIndex offset = 0, length;
    CGFloat height = 0;
    do {
        length = CTTypesetterSuggestLineBreak(typesetter, offset, width);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(offset, length));        
        CGFloat ascent, descent, leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);        
        CFRelease(line);
        offset += length;
        height += ascent + descent + leading;
    } while (offset < [string length]);
    CFRelease(typesetter);
    return CGSizeMake(width, ceil(height));
}

@end

#pragma mark -

@implementation BackgroundColorView

@synthesize gb_backgroundColor = _gb_backgroundColor;

- (void)drawRect:(NSRect)dirtyRect {
	[self.gb_backgroundColor set];
	NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
}

- (NSColor *)gb_backgroundColor {
	if (_gb_backgroundColor) return _gb_backgroundColor;
	_gb_backgroundColor = [NSColor whiteColor];
	return _gb_backgroundColor;
}

@end