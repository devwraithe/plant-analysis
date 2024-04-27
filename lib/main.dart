import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/shared/utilities/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load and init environment variables
  const aiKey = String.fromEnvironment("AI_KEY");
  EnvConfig.initialize(aiKey: aiKey);

  runApp(const MyApp());
}
