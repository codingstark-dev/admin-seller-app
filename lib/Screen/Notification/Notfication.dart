import 'package:flutter/material.dart';
import 'package:sellerapp/model/noficationData.dart';

class NotificationO extends StatefulWidget {
  @override
  _NotificationOState createState() => _NotificationOState();
}

Color active = Colors.deepPurple[400];

class _NotificationOState extends State<NotificationO> {
  final List<Post> items = new List();
  @override
  void initState() {
    super.initState();
    // setState(() {
    //   items.add(
    //     Post(
    //         image: "assets/img/Logo.png",
    //         id: 1,
    //         title: "CityGrow Seller App",
    //         desc: "oder done"),
    //   );
    //   items.add(
    //     Post(
    //         image: "assets/img/Logo.png",
    //         id: 2,
    //         title: "CityGrow Seller App",
    //         desc: "Your Item Delivery"),
    //   );
    //   items.add(
    //     Post(
    //         image: "assets/img/Logo.png",
    //         id: 3,
    //         title: "CityGrow Seller App",
    //         desc: "Pending List Item Shoes"),
    //   );
    //   items.add(
    //     Post(
    //         image: "assets/img/Logo.png",
    //         id: 4,
    //         title: "CityGrow Seller App",
    //         desc: "oder done"),
    //   );
    // });
  }

  Widget build(BuildContext context) {
    // MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "notification",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                color: Colors.black54,
                fontFamily: "Gotik"),
          ),
          iconTheme: IconThemeData(
            color: active,
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: items.length > 0
            ? ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(5.0),
                itemBuilder: (context, position) {
                  return Dismissible(
                      key: Key(items[position].id.toString()),
                      onDismissed: (direction) {
                        setState(() {
                          items.removeAt(position);
                        });
                      },
                      background: Container(
                        color: active,
                      ),
                      child: Container(
                        height: 88.0,
                        child: Column(
                          children: <Widget>[
                            Divider(height: 5.0),
                            ListTile(
                              title: Text(
                                '${items[position].title}',
                                style: TextStyle(
                                    fontSize: 17.5,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Container(
                                  width: 440.0,
                                  child: Text(
                                    '${items[position].desc}',
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black38),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              leading: Column(
                                children: <Widget>[
                                  Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(60.0)),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                '${items[position].image}'),
                                            fit: BoxFit.cover)),
                                  )
                                ],
                              ),
                              onTap: () => _onTapItem(context, items[position]),
                            ),
                            Divider(height: 5.0),
                          ],
                        ),
                      ));
                })
            : NoItemnotifications());
  }
}

void _onTapItem(BuildContext context, Post post) {
  Scaffold.of(context).showSnackBar(
      new SnackBar(content: new Text(post.id.toString() + ' - ' + post.title)));
}

class NoItemnotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: 500.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Padding(
            //     padding:
            //         EdgeInsets.only(top: mediaQueryData.padding.top + 100.0)),
            // Image.asset(
            //   "assets/img/nonotification.png",
            //   height: 200.0,
            // ),
            Padding(padding: EdgeInsets.only(bottom: 30.0)),
            Text(
              "Not Have notification",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.5,
                  color: Colors.black54,
                  fontFamily: "Gotik"),
            ),
          ],
        ),
      ),
    );
  }
}
