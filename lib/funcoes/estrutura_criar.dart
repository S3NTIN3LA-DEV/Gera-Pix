class PixBrCode {
  final String payloadFormatIndicator;
  final String pixKey;
  final String merchantCategoryCode;
  final String transactionCurrency;
  final String? transactionAmount;
  final String countryCode;
  final String merchantName;
  final String merchantCity;

  PixBrCode({
    required this.payloadFormatIndicator,
    required this.pixKey,
    required this.merchantCategoryCode,
    required this.transactionCurrency,
    this.transactionAmount,
    required this.countryCode,
    required this.merchantName,
    required this.merchantCity,
  });

  String generate() {
    String brCode = '';
    brCode += _formatField('00', payloadFormatIndicator); // Formato do payload
    brCode +=
        _formatField('26', _buildMerchantAccountInfo()); // Conta do recebedor
    brCode +=
        _formatField('52', merchantCategoryCode); // Categoria do comerciante
    brCode += _formatField('53', transactionCurrency); // Moeda da transação

    // Adiciona o valor da transação se fornecido
    if (transactionAmount != null && transactionAmount!.isNotEmpty) {
      brCode += _formatField('54', transactionAmount!);
    }

    brCode += _formatField('58', countryCode); // Código do país
    brCode += _formatField('59', merchantName); // Nome do beneficiário
    brCode += _formatField('60', merchantCity); // Cidade do beneficiário

    // Adiciona campo 62 (opcional)
    brCode += _formatField('62', _buildAdditionalDataFieldTemplate());

    // Adiciona o CRC16
    final crc16 = _calculateCRC16('${brCode}6304');
    brCode += _formatField('63', crc16);

    return brCode;
  }

  String _buildMerchantAccountInfo() {
    const String gui = 'BR.GOV.BCB.PIX';
    return _formatField('00', gui) + _formatField('01', pixKey);
  }

  String _buildAdditionalDataFieldTemplate() {
    return _formatField('05', '***'); // Exemplo de campo adicional
  }

  String _formatField(String id, String value) {
    final length = value.length.toString().padLeft(2, '0');
    return '$id$length$value';
  }

  String _calculateCRC16(String data) {
    int crc = 0xFFFF;
    for (int i = 0; i < data.length; i++) {
      crc ^= data.codeUnitAt(i) << 8;
      for (int j = 0; j < 8; j++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ 0x1021;
        } else {
          crc <<= 1;
        }
      }
    }
    crc &= 0xFFFF;
    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }
}
