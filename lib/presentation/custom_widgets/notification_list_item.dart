import 'package:arachnoit/application/notification_provider/notification_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/domain/notification/handle_notification_history.dart';
import 'package:arachnoit/infrastructure/notification/response/get_notification_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class NotificationListItem extends StatefulWidget {
  const NotificationListItem(
      {@required this.personNotification, @required this.updateStatusFunction})
      : super();
  final PersonNotification personNotification;
  final Function updateStatusFunction;

  @override
  _NotificationListItemState createState() => _NotificationListItemState();
}

class _NotificationListItemState extends State<NotificationListItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = Colors.grey[100].withOpacity(0.6);
    HandleNotificationHistory handleItem = HandleNotificationHistory(
        context: context, requestData: widget.personNotification);
    return Container(
      child: Card(
        elevation: 5.0,
        color: (widget.personNotification.isRead) ? Colors.white : mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: Container(
            child: ListTile(
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120),
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(
                  Icons.add_alert,
                  color: Colors.white,
                ),
              ),
              title: Text(
                handleItem.title,
                style: boldMontserrat(
                  fontSize: 16,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
//                style: TextStyle(
//                  color: Theme.of(context).primaryColor,
//                  fontWeight: FontWeight.bold,
//                  fontSize: 16,
//                ),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Html(
                data: handleItem.description.length < 90
                    ? handleItem.description
                    : handleItem.description.substring(0, 40) + "..",
                style: {
                  "body": Style(
                    fontSize: FontSize(12.0),
                    fontWeight: FontWeight.bold,
                  ),
                },
                shrinkWrap: true,
              ),
              isThreeLine: false,
              onTap: () {
                widget.updateStatusFunction();
                handleItem.function();
              },
            ),
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    );
  }
}
