void Function(Object)? _logger;
bool _shouldLog = true;

void logger(Object object) {
  if (_shouldLog) {
    if (_logger != null) {
      _logger!(object);
    } else {
      print(object);
    }
  }
}

void setLogger(void Function(Object) logger) {
  _logger = logger;
}

void disableLogger() {
  _shouldLog = false;
}
