/// عملة المعاملة. رمزها ISO هو ما يُخزَّن بعمود currency.
enum Currency {
  usd('USD'),
  syp('SYP');

  const Currency(this.code);

  final String code;

  /// أي قيمة غير معروفة (أو معاملة قديمة بلا عملة) تُعتبر دولاراً.
  static Currency fromCode(String? code) =>
      values.firstWhere((c) => c.code == code, orElse: () => usd);
}
