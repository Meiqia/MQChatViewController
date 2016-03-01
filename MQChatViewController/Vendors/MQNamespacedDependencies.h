// Namespaced Header

#ifndef __NS_SYMBOL
// We need to have multiple levels of macros here so that __NAMESPACE_PREFIX_ is
// properly replaced by the time we concatenate the namespace prefix.
#define __NS_REWRITE(ns, symbol) ns ## _ ## symbol
#define __NS_BRIDGE(ns, symbol) __NS_REWRITE(ns, symbol)
#define __NS_SYMBOL(symbol) __NS_BRIDGE(MEIQIA, symbol)
#endif


// Classes
#ifndef AmrRecordWriter
#define AmrRecordWriter __NS_SYMBOL(AmrRecordWriter)
#endif

#ifndef AutoPurgeCache
#define AutoPurgeCache __NS_SYMBOL(AutoPurgeCache)
#endif

#ifndef CafRecordWriter
#define CafRecordWriter __NS_SYMBOL(CafRecordWriter)
#endif

#ifndef CustomIOSAlertView
#define CustomIOSAlertView __NS_SYMBOL(CustomIOSAlertView)
#endif

#ifndef FBBitmapFont
#define FBBitmapFont __NS_SYMBOL(FBBitmapFont)
#endif

#ifndef FBBitmapFontView
#define FBBitmapFontView __NS_SYMBOL(FBBitmapFontView)
#endif

#ifndef FBFontSymbol
#define FBFontSymbol __NS_SYMBOL(FBFontSymbol)
#endif

#ifndef FBLCDFont
#define FBLCDFont __NS_SYMBOL(FBLCDFont)
#endif

#ifndef FBLCDFontView
#define FBLCDFontView __NS_SYMBOL(FBLCDFontView)
#endif

#ifndef FBSquareFont
#define FBSquareFont __NS_SYMBOL(FBSquareFont)
#endif

#ifndef FBSquareFontView
#define FBSquareFontView __NS_SYMBOL(FBSquareFontView)
#endif

#ifndef HPGrowingTextView
#define HPGrowingTextView __NS_SYMBOL(HPGrowingTextView)
#endif

#ifndef HPTextViewInternal
#define HPTextViewInternal __NS_SYMBOL(HPTextViewInternal)
#endif

#ifndef LevelMeterState
#define LevelMeterState __NS_SYMBOL(LevelMeterState)
#endif

#ifndef MHFacebookImageViewer
#define MHFacebookImageViewer __NS_SYMBOL(MHFacebookImageViewer)
#endif

#ifndef MHFacebookImageViewerCell
#define MHFacebookImageViewerCell __NS_SYMBOL(MHFacebookImageViewerCell)
#endif

#ifndef MHFacebookImageViewerTapGestureRecognizer
#define MHFacebookImageViewerTapGestureRecognizer __NS_SYMBOL(MHFacebookImageViewerTapGestureRecognizer)
#endif

#ifndef MKAnnotationView
#define MKAnnotationView __NS_SYMBOL(MKAnnotationView)
#endif

#ifndef MLAudioMeterObserver
#define MLAudioMeterObserver __NS_SYMBOL(MLAudioMeterObserver)
#endif

#ifndef MLAudioRecorder
#define MLAudioRecorder __NS_SYMBOL(MLAudioRecorder)
#endif

#ifndef TTTAccessibilityElement
#define TTTAccessibilityElement __NS_SYMBOL(TTTAccessibilityElement)
#endif

#ifndef TTTAttributedLabel
#define TTTAttributedLabel __NS_SYMBOL(TTTAttributedLabel)
#endif

#ifndef TTTAttributedLabelLink
#define TTTAttributedLabelLink __NS_SYMBOL(TTTAttributedLabelLink)
#endif

//functions
#ifndef inputBufferHandler
#define inputBufferHandler __NS_SYMBOL(inputBufferHandler)
#endif

//externs
#ifndef buttonHeight
#define buttonHeight __NS_SYMBOL(buttonHeight)
#endif

#ifndef buttonSpacerHeight
#define buttonSpacerHeight __NS_SYMBOL(buttonSpacerHeight)
#endif

#ifndef didKeyboardDisplay
#define didKeyboardDisplay __NS_SYMBOL(didKeyboardDisplay)
#endif

#ifndef currentKeyboardSize
#define currentKeyboardSize __NS_SYMBOL(currentKeyboardSize)
#endif

#ifndef kTTTStrikeOutAttributeName
#define kTTTStrikeOutAttributeName __NS_SYMBOL(kTTTStrikeOutAttributeName)
#endif

#ifndef kTTTBackgroundFillColorAttributeName
#define kTTTBackgroundFillColorAttributeName __NS_SYMBOL(kTTTBackgroundFillColorAttributeName)
#endif

#ifndef kTTTBackgroundFillPaddingAttributeName
#define kTTTBackgroundFillPaddingAttributeName __NS_SYMBOL(kTTTBackgroundFillPaddingAttributeName)
#endif

#ifndef kTTTBackgroundStrokeColorAttributeName
#define kTTTBackgroundStrokeColorAttributeName __NS_SYMBOL(kTTTBackgroundStrokeColorAttributeName)
#endif

#ifndef kTTTBackgroundLineWidthAttributeName
#define kTTTBackgroundLineWidthAttributeName __NS_SYMBOL(kTTTBackgroundLineWidthAttributeName)
#endif

#ifndef kTTTBackgroundCornerRadiusAttributeName
#define kTTTBackgroundCornerRadiusAttributeName __NS_SYMBOL(kTTTBackgroundCornerRadiusAttributeName)
#endif

#ifndef TTTTextAlignmentLeft
#define TTTTextAlignmentLeft __NS_SYMBOL(TTTTextAlignmentLeft)
#endif

#ifndef TTTTextAlignmentCenter
#define TTTTextAlignmentCenter __NS_SYMBOL(TTTTextAlignmentCenter)
#endif

#ifndef TTTTextAlignmentRight
#define TTTTextAlignmentRight __NS_SYMBOL(TTTTextAlignmentRight)
#endif

#ifndef TTTTextAlignmentJustified
#define TTTTextAlignmentJustified __NS_SYMBOL(TTTTextAlignmentJustified)
#endif

#ifndef TTTTextAlignmentNatural
#define TTTTextAlignmentNatural __NS_SYMBOL(TTTTextAlignmentNatural)
#endif

#ifndef TTTLineBreakByWordWrapping
#define TTTLineBreakByWordWrapping __NS_SYMBOL(TTTLineBreakByWordWrapping)
#endif

#ifndef TTTLineBreakByCharWrapping
#define TTTLineBreakByCharWrapping __NS_SYMBOL(TTTLineBreakByCharWrapping)
#endif

#ifndef TTTLineBreakByClipping
#define TTTLineBreakByClipping __NS_SYMBOL(TTTLineBreakByClipping)
#endif

#ifndef TTTLineBreakByTruncatingHead
#define TTTLineBreakByTruncatingHead __NS_SYMBOL(TTTLineBreakByTruncatingHead)
#endif

#ifndef TTTLineBreakByTruncatingMiddle
#define TTTLineBreakByTruncatingMiddle __NS_SYMBOL(TTTLineBreakByTruncatingMiddle)
#endif

#ifndef TTTLineBreakByTruncatingTail
#define TTTLineBreakByTruncatingTail __NS_SYMBOL(TTTLineBreakByTruncatingTail)
#endif
