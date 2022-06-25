pub global activate coverage &&
pub run test --coverage="coverage" &&
pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages --report-on=lib