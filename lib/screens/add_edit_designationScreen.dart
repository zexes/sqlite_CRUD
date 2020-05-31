import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sqlite/model/Designation.dart';
import 'package:sqlite/provider/designation_provider.dart';

class EditDesignationScreen extends StatefulWidget {
  final int chosenDesignationId;
  static const String id = 'add_edit_Designation_Screen';

  const EditDesignationScreen({this.chosenDesignationId});

  @override
  _EditDesignationScreenState createState() => _EditDesignationScreenState();
}

class _EditDesignationScreenState extends State<EditDesignationScreen> {
  final _designationController = TextEditingController();

  final _form = GlobalKey<FormState>();
  Designation _editedDesignation = Designation('', '');
  int designationId = 0;

  var _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      if (widget.chosenDesignationId != null) {
        designationId = widget.chosenDesignationId;
        _editedDesignation =
            await Provider.of<DesignationProvider>(context, listen: false)
                .getSingleDesignation(designationId);
        _designationController.text = _editedDesignation.display;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _designationController.dispose(); // to prevent memory leakages
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    addRecord();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text((designationId > 0) ? 'Edit' : 'Add new Designation'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller:
                        _designationController, //either initial value or controller noth both
                    decoration: InputDecoration(labelText: 'Designation'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return (value.isEmpty) ? 'Please provide a value' : null;
                    },
                    onSaved: (value) {
                      setState(() {});
                      _editedDesignation = Designation(value, value);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      _saveForm();
                      print(' now i got u $designationId');
                      Navigator.of(context).pop(designationId);
                    }, //_saveForm
                    child: new Container(
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: getAppBorderButton(
                          (designationId > 0) ? "Edit" : "Add",
                          EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF28324E)),
        borderRadius: BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: Text(
        buttonLabel,
        style: TextStyle(
          color: const Color(0xFF28324E),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Future<void> addRecord() async {
//    var db = DesignationProvider();
    if (designationId > 0) {
      _editedDesignation.setDesignationId(designationId);
      await Provider.of<DesignationProvider>(context, listen: false)
          .update(_editedDesignation);
    } else {
      int index = Provider.of<DesignationProvider>(context, listen: false)
          .designations
          .indexWhere(
              (element) => element.value == _designationController.text);
      if (index < 0) {
        await Provider.of<DesignationProvider>(context, listen: false)
            .saveDesignation(_editedDesignation);
      } else {
        designationId = -9;
      }
    }
  }
}
