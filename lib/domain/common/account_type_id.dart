import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class AccountTypeId {
  final Map<int, String> _map = {
    0: "d228d40d-c023-4812-b32a-391a2399c53e",
    1: "74aa3553-55e0-4008-9bf5-52f945184c97",
  };
  String getAccountTypeId(int number) {
    return _map[number];
  }

 static String getNameOfAccountType(int id,BuildContext context){
    final _map = {
      0: AppLocalizations.of(context).individual,
      1: AppLocalizations.of(context).enterprise,
    };
    return _map[id];
  }
}
