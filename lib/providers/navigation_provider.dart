import 'package:riverpod/riverpod.dart';

// A global provider that holds the currently selected index of the
// main bottom navigation bar.
final selectedNavIndexProvider = StateProvider<int>((ref)
    {
        // The app starts with the 'Home' tab selected (index 0).
        return 0;
    }
);
