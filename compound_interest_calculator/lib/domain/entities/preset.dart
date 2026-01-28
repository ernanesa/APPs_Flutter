import 'package:equatable/equatable.dart';

/// Preset for common investment types
class InvestmentPreset extends Equatable {
  final String id;
  final String nameKey; // i18n key
  final double annualRate;
  final String icon;
  final String descriptionKey; // i18n key

  const InvestmentPreset({
    required this.id,
    required this.nameKey,
    required this.annualRate,
    required this.icon,
    required this.descriptionKey,
  });

  @override
  List<Object?> get props => [id, nameKey, annualRate, icon, descriptionKey];
}

/// Common Brazilian investment presets
class BrazilianPresets {
  static const List<InvestmentPreset> all = [
    InvestmentPreset(
      id: 'poupanca',
      nameKey: 'presetPoupanca',
      annualRate: 6.17,
      icon: '🏦',
      descriptionKey: 'presetPoupancaDesc',
    ),
    InvestmentPreset(
      id: 'cdi',
      nameKey: 'presetCDI',
      annualRate: 10.65,
      icon: '📊',
      descriptionKey: 'presetCDIDesc',
    ),
    InvestmentPreset(
      id: 'tesouro_selic',
      nameKey: 'presetTesouroSelic',
      annualRate: 10.75,
      icon: '🏛️',
      descriptionKey: 'presetTesouroSelicDesc',
    ),
    InvestmentPreset(
      id: 'tesouro_ipca',
      nameKey: 'presetTesouroIPCA',
      annualRate: 6.50,
      icon: '📈',
      descriptionKey: 'presetTesouroIPCADesc',
    ),
    InvestmentPreset(
      id: 'cdb',
      nameKey: 'presetCDB',
      annualRate: 11.50,
      icon: '💰',
      descriptionKey: 'presetCDBDesc',
    ),
    InvestmentPreset(
      id: 'lci_lca',
      nameKey: 'presetLCILCA',
      annualRate: 9.00,
      icon: '🏠',
      descriptionKey: 'presetLCILCADesc',
    ),
  ];
}
