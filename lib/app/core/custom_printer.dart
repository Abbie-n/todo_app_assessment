import 'package:logger/logger.dart' as l;

var logger = l.Logger(
  printer: l.PrettyPrinter(colors: false, methodCount: 0, levelEmojis: {
    l.Level.debug: '\u{1F680}',
    l.Level.info: '\u{1F7E1}',
    l.Level.error: '\u{1F977}',
  }),
);

void debug(String message) => logger.d(message);

void info(String message) => logger.i(message);

void error(String message) => logger.e(message);
