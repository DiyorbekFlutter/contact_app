import 'package:contact_app/services/shared_prereferences_service.dart';

import 'en.dart';
import 'uz.dart';

extension Translate on String {
  String get translate {
    String language = SharedPreferencesService.getString(SharedPreferencesStorageKey.language) ?? 'uz';
    return language == 'uz' ? uz[toLowerCase()] : en[toLowerCase()];
  }
}
