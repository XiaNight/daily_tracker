/*
 * Copyright 2021 R-Dap
 * 
 * @Author: XiaNight 賴資敏
*/

class Debug {
  static void Log(String message, {String color}) {
    print('\u001b[0m$color$message\u001b[0m');
  }
}

void printcolor(String message, {String color}) {
  print('\u001b[0m$color$message\u001b[0m');
}

class DColor {
  /// Error or important messages.]
  static final String red = '\u001b[31m';

  /// Starting or Success messages.
  static final String green = '\u001b[32m';

  /// Highlighted logs.
  static final String yellow = '\u001b[33m';

  /// Highlighted messages.
  static final String blue = '\u001b[34m';

  /// Important messages 2.
  static final String magenta = '\u001b[35m';

  /// Important messages.
  static final String cyan = '\u001b[36m';

  /// normal messages.
  static final String white = '\u001b[37m';

  /// Warning messages.
  static final String orange = '\u001b[38;5;202m';
}
