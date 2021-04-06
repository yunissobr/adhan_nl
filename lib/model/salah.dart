
class Salah {
  String _name;
  String _englishName;
  String _time;
  bool _isNotificationEnabled;
  DateTime _date;

  Salah(
        this._name,
        this._englishName,
        this._time,
        this._isNotificationEnabled,
        this._date);

  factory Salah.fromJson(Map<String, dynamic> json) => Salah(
      json["name"],
      json["englishName"],
      json["time"],
      json["isNotificationEnabled"] == 1 ? true : false,
      DateTime.fromMicrosecondsSinceEpoch(json["dateTime"],isUtc: true)
  );
  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  bool get isNotificationEnabled => _isNotificationEnabled;

  set isNotificationEnabled(bool value) {
    _isNotificationEnabled = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  String get englishName => _englishName;

  set englishName(String value) {
    _englishName = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

}
