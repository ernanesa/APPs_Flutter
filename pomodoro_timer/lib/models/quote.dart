/// Represents a motivational quote.
class Quote {
  final String textKey; // i18n key for the quote text
  final String authorKey; // i18n key for the author name

  const Quote({
    required this.textKey,
    required this.authorKey,
  });
}

/// Predefined motivational quotes.
class Quotes {
  static const List<Quote> all = [
    Quote(
      textKey: 'quote1Text',
      authorKey: 'quote1Author',
    ),
    Quote(
      textKey: 'quote2Text',
      authorKey: 'quote2Author',
    ),
    Quote(
      textKey: 'quote3Text',
      authorKey: 'quote3Author',
    ),
    Quote(
      textKey: 'quote4Text',
      authorKey: 'quote4Author',
    ),
    Quote(
      textKey: 'quote5Text',
      authorKey: 'quote5Author',
    ),
    Quote(
      textKey: 'quote6Text',
      authorKey: 'quote6Author',
    ),
    Quote(
      textKey: 'quote7Text',
      authorKey: 'quote7Author',
    ),
    Quote(
      textKey: 'quote8Text',
      authorKey: 'quote8Author',
    ),
    Quote(
      textKey: 'quote9Text',
      authorKey: 'quote9Author',
    ),
    Quote(
      textKey: 'quote10Text',
      authorKey: 'quote10Author',
    ),
    Quote(
      textKey: 'quote11Text',
      authorKey: 'quote11Author',
    ),
    Quote(
      textKey: 'quote12Text',
      authorKey: 'quote12Author',
    ),
    Quote(
      textKey: 'quote13Text',
      authorKey: 'quote13Author',
    ),
    Quote(
      textKey: 'quote14Text',
      authorKey: 'quote14Author',
    ),
    Quote(
      textKey: 'quote15Text',
      authorKey: 'quote15Author',
    ),
  ];
}
