import 'package:map_test_app/core/cache_manager/shared_value_function_helper.dart';

final SharedValue<List<dynamic>> saved_markers = SharedValue<List<dynamic>>(
  value: <dynamic>[], // initial value
  key: "saved_markers", // disk storage key for shared_preferences
);
