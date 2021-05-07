class BigNum {
  BigInt _numerator = BigInt.one; //분자
  BigInt _denominator =  BigInt.one; //분모

  BigNum.raw(this._numerator, this._denominator);

  BigNum.parse(String num) {
    if(num.length==0 || RegExp("[^0-9.-]").hasMatch(num))
      throw Exception("Illegal BigNum Format ($num)");

    var spl = num.split(".");
    if(spl.length==1) {
      _numerator = BigInt.parse(num);
      _denominator = BigInt.one;
    } else {
      _numerator = BigInt.parse(spl[0] + spl[1]);
      _denominator = BigInt.parse("1" + "0"*(num.length - num.indexOf(".") - 1));
    } normalize();
  }

  static BigNum? tryParse(String num) {
    try {
      var res = BigNum.parse(num);
      return res;
    } catch(ignore) {
      return null;
    }
  }

  BigNum(num num) : this.parse(num.toFormalString());

  void normalize() {
    if(_numerator==BigInt.zero) {
      _denominator = BigInt.one;
    } else {
      final aNumerator = _numerator.abs();
      final aDenominator = _denominator.abs();
      final gcd = aNumerator.gcd(aDenominator);
      if (gcd != BigInt.one) {
        _numerator ~/= gcd;
        _denominator ~/= gcd;
      }
    }
  }

  BigNum operator+(BigNum another) {
    return BigNum.raw((_numerator * another._denominator + another._numerator * _denominator), _denominator * another._denominator)..normalize();
  }

  BigNum operator-(BigNum another) {
    return BigNum.raw((_numerator * another._denominator - another._numerator * _denominator), _denominator * another._denominator)..normalize();
  }

  BigNum operator*(BigNum another) {
    return BigNum.raw(_numerator * another._numerator, _denominator * another._denominator)..normalize();
  }

  BigNum operator/(BigNum another) {
    return BigNum.raw(_numerator * another._denominator, _denominator * another._numerator)..normalize();
  }

  bool operator<(BigNum another) => _compareTo(another)<0;
  bool operator>(BigNum another) => _compareTo(another)>0;
  bool operator>=(BigNum another) => _compareTo(another)>=0;
  bool operator<=(BigNum another) => _compareTo(another)<=0;

  int _compareTo(BigNum another) {
    var sub = this - another;
    if(sub.isNegative) return -1;
    else if(sub.equals(BigNum.zero)) return 0;
    else return 1;
  }

  bool equals(BigNum another) {
    if(_numerator==BigInt.zero && another._numerator==BigInt.zero) return true;

    var t = this.copy()..normalize();
    var a = another.copy()..normalize();
    return t._numerator==a._numerator && t._denominator==a._denominator;
  }

  BigNum add(num num) => this + BigNum(num);
  BigNum sub(num num) => this - BigNum(num);

  BigNum round([int fixed = 0]) {
    var num = toString();
    var _exp = num.indexOf(".")<0?0:num.length - num.indexOf(".") - 1;
    if(_exp <= fixed) return this;
    if(num.codeUnitAt(num.length - (_exp-fixed)) - "0".codeUnitAt(0) >= 5)
      return ceil(fixed);
    else
      return floor(fixed);
  }

  // BigNum round() {
  //   var num = toString();
  //   if(num.length>=15){
  //       var _exp = num.indexOf(".")<0?0:num.length - num.indexOf(".") - 1;
  //       return
  //   }else return this;
  //
  // }

  BigNum floor([int fixed = 0]) {
    var groups = toString().split(".");
    if(groups.length==1 || groups[1].length<=fixed) return this;
    return BigNum.parse(groups[0] + "." + groups[1].substring(0, fixed));
  }

  BigNum ceil([int fixed = 0]) {
    var groups = toString().split(".");
    if(groups.length==1 || groups[1].length<=fixed) return this;
    var num = BigNum.parse(groups[0] + "." + groups[1].substring(0, fixed));
    return num + BigNum.raw(BigInt.one, BigInt.parse("1" + "0"*fixed));
  }

  double toDouble() {
    return double.parse(toString());
  }

  String toString() {
    var str = (_numerator/_denominator).toFormalString();
    var spl = str.split(".");
    if(spl.length==1) return spl[0];
    else if(spl[1] == "0") return spl[0];
    else return str;
  }

  String toFormatString() {
    String numStr = toString();
    var reg = RegExp(r"(^[+-]?[0-9]+)([0-9]{3})");
    while (reg.hasMatch(numStr)) {
      numStr = numStr.replaceFirstMapped(reg, (match) => "${match.group(1)},${match.group(2)}");
    } return numStr;
  }

  bool get isNegative => _numerator.isNegative^_denominator.isNegative;

  BigNum copy() => BigNum.raw(_numerator, _denominator);

  BigInt get numerator => _numerator;
  BigInt get denominator => _denominator;


  static min(BigNum a, BigNum b) => a<=b?a:b;
  static max(BigNum a, BigNum b) => a>=b?a:b;

  static BigNum _zero = BigNum(0);
  static BigNum _one = BigNum(1);
  static BigNum get zero => _zero;
  static BigNum get one => _one;
}

extension FormalStringfier on num {
  String toFormalString() {
    var str = toString();
    var regexp = RegExp("([0-9](?:.[0-9]+)?)e-([0-9]+)");
    var match = regexp.firstMatch(str);
    if(match == null) return str;

    var num = match.group(1);
    var exp = match.group(2);
    num = num!.replaceAll(".", "");
    return "0.${"0"*(int.parse(exp!)-1)}$num";
  }
}