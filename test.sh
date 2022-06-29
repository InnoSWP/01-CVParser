flutter test --coverage &&
lcov --remove coverage/lcov.info 'lib/parsed/*' -o coverage/new_lcov.info &&
genhtml coverage/new_lcov.info --output=coverage