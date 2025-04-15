enum DataStorageKey implements Comparable<DataStorageKey> {
  accessToken('access_token_key', securityLevel: SecurityLevel.keychain),
  refreshToken('refresh_token_key', securityLevel: SecurityLevel.keychain),
  bonusCardNumber('bonus_card_number'),
  firebaseToken('firebaseToken'),
  userName('userName'),
  userPhoneNumber('userPhoneNumber');

  const DataStorageKey(this.value, {this.securityLevel = SecurityLevel.none});

  final String value;
  final SecurityLevel securityLevel;

  bool get isSecure => securityLevel == SecurityLevel.keychain;

  @override
  String toString() {
    return value;
  }

  @override
  int compareTo(DataStorageKey other) {
    return value.compareTo(other.value);
  }
}

enum SecurityLevel {
  none,
  keychain, // Saved in secure storage
}
