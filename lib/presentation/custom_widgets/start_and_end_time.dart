import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/presentation/custom_widgets/text_field_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class StartAndEndTimeWithExpire extends StatelessWidget {
  TextEditingController startTime;
  TextEditingController endTime;
  ValueNotifier<bool> _isExpire = ValueNotifier(false);
  bool isExpired;
  StartAndEndTimeWithExpire(
      {this.endTime, this.startTime, this.isExpired = false}) {
    if (isExpired) {
      _isExpire.value = isExpired;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
            valueListenable: _isExpire,
            builder: (context, value, _) {
              return _StartAndEndTime(
                endTimeController: endTime,
                startTimeController: startTime,
                isExpiredTime: value,
              );
            }),
        SizedBox(height: 6),
        ValueListenableBuilder(
            valueListenable: _isExpire,
            builder: (context, value, _) {
              return Row(
                children: [
                  Checkbox(
                      value: value,
                      onChanged: (v) {
                        _isExpire.value = !_isExpire.value;
                      }),
                  Text(AppLocalizations.of(context).no_expire_date,
                      style: TextStyle(fontSize: 16)),
                ],
              );
              // return CheckboxListTile(
              //     value: !value,
              //     title: Text('no expire date for certificate'),
              //     onChanged: (value) {
              //       _isExpire.value = !_isExpire.value;
              //     });
            }),
      ],
    );
  }

  bool getExpireValue() {
    return !_isExpire.value;
  }
}

// ignore: must_be_immutable
class _StartAndEndTime extends StatelessWidget {
  final TextEditingController endTimeController;
  final TextEditingController startTimeController;
  bool isExpiredTime;
  ValueNotifier<DateTime> _selecteTime = ValueNotifier(DateTime.now());
  _StartAndEndTime({
    @required this.endTimeController,
    @required this.startTimeController,
    @required this.isExpiredTime,
  });
  bool _selectedDate = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: Text(AppLocalizations.of(context).start_date+" * ")),
            SizedBox(width: 15),
            Expanded(
                child:
                    Text((isExpiredTime) ? AppLocalizations.of(context).no_expire_date : 
                    AppLocalizations.of(context).expire_date+" * "
                    )),
          ],
        ),
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                color: Color(0XFFEFEFEF),
                child: MyTextFieldDatePicker(
                  labelText: AppLocalizations.of(context).start_date,
                  prefixIcon: Icon(Icons.date_range),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2050),
                  initialDate: DateTime.now(),
                  isSelectedFirstDate: true,
                  controller: startTimeController,
                  onDateChanged: (selectedDate) {
                    startTimeController.text =
                        DateFormat('yyyy-MM-dd').format(selectedDate);
                    _selecteTime.value = selectedDate;
                    _selectedDate = true;
                    endTimeController.text = "";
                  },
                ),
              ),
            ),
            SizedBox(width: 15),
            (isExpiredTime)
                ? Expanded(
                    child: Container(
                      height: 60,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).no_expire_date,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                : ValueListenableBuilder(
                    valueListenable: _selecteTime,
                    builder: (context, value, _) {
                      return Expanded(
                        child: Container(
                          color: Color(0XFFEFEFEF),
                          child: MyTextFieldDatePicker(
                            labelText: AppLocalizations.of(context).expire_date+" * ",
                            controller: endTimeController,
                            prefixIcon: Icon(Icons.date_range),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            firstDate: value,
                            lastDate: DateTime(2050),
                            isSelectedFirstDate: _selectedDate,
                            initialDate: value,
                            onDateChanged: (selectedDate) {
                              endTimeController.text =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                            },
                          ),
                        ),
                      );
                    })
          ],
        )
      ],
    );
  }
}
