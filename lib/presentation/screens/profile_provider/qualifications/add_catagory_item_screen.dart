import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:flutter/material.dart';

class AddCategoryItem extends StatefulWidget {
  static const routeName = '/Add_New_Item_Category';

  const AddCategoryItem();

  @override
  _CollapsingTabState createState() => new _CollapsingTabState();
}

class _CollapsingTabState extends State<AddCategoryItem> {
  Map<String, dynamic> needUpdateValue = Map<String, dynamic>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(needUpdateValue);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0XFFEFEFEF),
          elevation: 0,
          title: Text(
            'Add Category/Item',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        body: GridView.count(
            crossAxisCount: 3,
            padding: EdgeInsets.all(15),
            children: ProfileProviderAddItemIcons.screens.keys.map((String categoryItem) {
              return Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) =>
                                  ProfileProviderAddItemIcons.screens[categoryItem]))
                          .then((value) {
                        needUpdateValue[categoryItem] = true;
                      });
                    },
                    child: Hero(
                      tag: categoryItem,
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Color(0XFFC4C4C4),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              ProfileProviderAddItemIcons.getIconByKeyValue(key: categoryItem),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    categoryItem,
                  )
                ],
              ));
            }).toList()),
      ),
    );
  }
}
