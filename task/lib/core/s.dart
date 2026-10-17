import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class S {
  const S();

  static S of(BuildContext context) => Localizations.of<S>(context, S)!;

  static const LocalizationsDelegate<S> delegate = SDelegate();

  String get appTitle => 'Job Matches';
  String get all => 'All';
  String get uae => 'UAE';
  String get saudi => 'Saudi Arabia';
  String get qatar => 'Qatar';
  String get perMonth => 'AED / month';
  String get applied => 'Applied';
  String get apply => 'Apply';
  String get noMatches => 'No matches yet';
  String get noMatchesSub => 'Check back soon or try another country.';
  String get errorTitle => 'Something went wrong';
  String get errorSub => 'We could not load jobs. Please try again.';
  String get retry => 'Retry';
  String get offlineBanner => "You're offline — showing saved jobs";
  String get offlineApply => "You're offline. Connect to the internet to apply.";
  String get description => 'Description';
  String get requirements => 'Requirements';
  String get benefits => 'Benefits';
  String get accommodation => 'Accommodation';
  String get food => 'Food';
  String get visa => 'Visa';
  String get whyMatch => 'Why this matches you';
  String get applyDoneTitle => 'Application sent!';
  String get applyDoneMsg => 'You have successfully applied for this job.';
  String get applyFailed => 'Could not apply. Please try again.';
  String get done => 'Done';
  String get jobDetails => 'Job Details';
  String get splashTagline => 'Find your next job abroad';
  String get loadMoreFailed => 'Could not load more. Tap to retry.';
  String get refreshFailed => 'Refresh failed. Please try again.';
}

class $hi extends S {
  const $hi();

  @override
  String get appTitle => 'जॉब मैच';
  @override
  String get all => 'सभी';
  @override
  String get uae => 'यूएई';
  @override
  String get saudi => 'सऊदी अरब';
  @override
  String get qatar => 'क़तर';
  @override
  String get perMonth => 'AED / माह';
  @override
  String get applied => 'आवेदन किया';
  @override
  String get apply => 'आवेदन करें';
  @override
  String get noMatches => 'अभी कोई मैच नहीं';
  @override
  String get noMatchesSub => 'थोड़ी देर बाद देखें या दूसरा देश चुनें।';
  @override
  String get errorTitle => 'कुछ गड़बड़ हो गई';
  @override
  String get errorSub => 'जॉब लोड नहीं हो सकीं। कृपया फिर कोशिश करें।';
  @override
  String get retry => 'दोबारा कोशिश करें';
  @override
  String get offlineBanner => 'आप ऑफ़लाइन हैं — सेव की गई जॉब दिख रही हैं';
  @override
  String get offlineApply => 'आप ऑफ़लाइन हैं। आवेदन के लिए इंटरनेट चालू करें।';
  @override
  String get description => 'विवरण';
  @override
  String get requirements => 'आवश्यकताएँ';
  @override
  String get benefits => 'सुविधाएँ';
  @override
  String get accommodation => 'रहने की व्यवस्था';
  @override
  String get food => 'खाना';
  @override
  String get visa => 'वीज़ा';
  @override
  String get whyMatch => 'यह जॉब आपके लिए क्यों सही है';
  @override
  String get applyDoneTitle => 'आवेदन भेज दिया गया!';
  @override
  String get applyDoneMsg => 'आपने इस जॉब के लिए सफलतापूर्वक आवेदन कर दिया है।';
  @override
  String get applyFailed => 'आवेदन नहीं हो सका। कृपया फिर कोशिश करें।';
  @override
  String get done => 'ठीक है';
  @override
  String get jobDetails => 'जॉब विवरण';
  @override
  String get splashTagline => 'विदेश में अपनी अगली नौकरी खोजें';
  @override
  String get loadMoreFailed => 'और जॉब लोड नहीं हुईं। दोबारा कोशिश करने के लिए दबाएँ।';
  @override
  String get refreshFailed => 'रिफ्रेश नहीं हो सका। कृपया फिर कोशिश करें।';
}

class SDelegate extends LocalizationsDelegate<S> {
  const SDelegate();

  static const supportedLocales = [Locale('en'), Locale('hi')];

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'en' || locale.languageCode == 'hi';

  @override
  Future<S> load(Locale locale) {
    final S strings = locale.languageCode == 'hi' ? const $hi() : const S();
    return SynchronousFuture<S>(strings);
  }

  @override
  bool shouldReload(SDelegate old) => false;
}

extension SX on BuildContext {
  S get s => S.of(this);
}
