import 'package:flutter/material.dart';

final _kanit = 'Kanit';

class HistoryScreen extends StatefulWidget {
  Map<String, dynamic> message;
  HistoryScreen({Key key, this.message}) : super(key: key);
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var employee = 'พนักงาน';
  _getEmployeeStr() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(context, 'พนักงาน', _action1),
              _createTile(context, 'หัวหน้า', _action2),
            ],
          );
        });
  }

  ListTile _createTile(BuildContext context, String name, Function action) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  _action1() {
    setState(() {
      employee = 'พนักงาน';
    });
  }

  _action2() {
    setState(() {
      employee = 'หัวหน้า';
    });
  }

  _showList() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'รายงาน',
            style: TextStyle(
              fontFamily: _kanit,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            getEmpolyee(
              title: 'ระดับพนักงาน',
              employee: employee,
              action: _getEmployeeStr,
            ),
            cardHistory(
              name: 'admin',
              leaveDetail: 'ป่วย',
              dateLeave: '20/20/2020',
            ),
          ],
        ),
      ),
    );
  }

  Widget getEmpolyee({
    title,
    employee,
    action,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: _kanit,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  employee,
                  style: TextStyle(
                      fontSize: 18, fontFamily: _kanit, color: Colors.black54),
                ),
                IconButton(
                  onPressed: action,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardHistory({
    name,
    leaveDetail,
    dateLeave,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: _kanit,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(leaveDetail, style: TextStyle(
                        fontFamily: _kanit,
                        fontSize: 18.0,
                      ),),
                    Text(dateLeave, style: TextStyle(
                        fontFamily: _kanit,
                        fontSize: 18.0,
                      ),),
                  ],
                ),
              ),
              employee == 'พนักงาน'
                  ? Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: RawMaterialButton(
                        onPressed: (){

                        },
                        child: Icon(Icons.cancel,color: Colors.red, size: 50,),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: <Widget>[
                          RawMaterialButton(
                            onPressed: (){

                            },
                            child: Icon(Icons.check_circle, color: Colors.green, size: 50,),
                          ),
                          RawMaterialButton(
                            onPressed: (){

                            },
                            child: Icon(Icons.cancel, color: Colors.red, size: 50,),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
