import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/auth_session.dart';
import '../models/auth_session_model.dart';

abstract interface class SessionStorage {
  Future<AuthSession?> read();
  Future<void> write(AuthSession session);
  Future<void> clear();
}

class SecureSessionStorage implements SessionStorage {
  const SecureSessionStorage(this._storage);

  static const _sessionKey = 'beango.auth.session.v1';
  final FlutterSecureStorage _storage;

  @override
  Future<AuthSession?> read() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, Object?>;
      return AuthSessionModel.fromJson(json).session;
    } on Object {
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(AuthSession session) => _storage.write(
    key: _sessionKey,
    value: jsonEncode(AuthSessionModel(session: session).toJson()),
  );

  @override
  Future<void> clear() => _storage.delete(key: _sessionKey);
}

class MemorySessionStorage implements SessionStorage {
  AuthSession? value;

  @override
  Future<AuthSession?> read() async => value;

  @override
  Future<void> write(AuthSession session) async => value = session;

  @override
  Future<void> clear() async => value = null;
}
