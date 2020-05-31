import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/designation_provider.dart';
import '../screens/add_edit_designationScreen.dart';
import '../widget/designation_item.dart';
import '../widget/app_drawer.dart';

class DesignationScreen extends StatefulWidget {
  static const String id = 'designation_screen';

  @override
  _DesignationScreenState createState() => _DesignationScreenState();
}

class _DesignationScreenState extends State<DesignationScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
//      method called to ensure designation list used below is populated
      Provider.of<DesignationProvider>(context).getDesignations().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //  method called to ensure designation list used below is populated, set listen to false else there is constant rebuild,
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Designations'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _showDialog(context),
            )
          ],
        ),
        body: _isLoading
            ? CircularProgressIndicator()
            : Consumer<DesignationProvider>(
                builder: (_, designationData, __) {
                  final designationList = designationData.designations;
                  return ListView.builder(
                    itemBuilder: (context, index) =>
                        ChangeNotifierProvider.value(
                            value: designationList[index],
                            child: DesignationItem(
                                id: designationList[index].id,
                                display: designationList[index].display,
                                value: designationList[index].value)),
                    itemCount: designationList.length,
                  );
                },
              ),
        drawer: AppDrawer(),
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          onPressed: () => _showDialog(context),
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).accentColor,
        ),
      ),
      onWillPop: () {
        return;
      },
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    dynamic result = await showDialog(
        context: context,
        builder: (BuildContext ctx) => EditDesignationScreen());
    if (result == null) return;
    if (result == -9) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Designation Already Exist',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } else {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Added new Designation',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ));
    }
    await Provider.of<DesignationProvider>(context, listen: false)
        .getDesignations();
  }
}
