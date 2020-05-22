import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqlite/model/Designation.dart';
import '../provider/designation_provider.dart';
import '../screens/home_page.dart';
import '../provider/employee_provider.dart';
import '../model/employee.dart';

class EditEmployeeScreen extends StatefulWidget {
  final int chosenEmployeeId;
  static const String id = 'add_edit_Employee_Screen';

  const EditEmployeeScreen({this.chosenEmployeeId});

  @override
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  DateTime _selectedDate;
  final _nameFocusNode = FocusNode();
  final _dobFocusNode = FocusNode();

  final _nameController = TextEditingController();
  final _dobController = TextEditingController();

  String _myActivity;

  final _form = GlobalKey<FormState>();
  Employee _editedEmployee = Employee('', 0, '');
  int employeeId = 0;
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      if (widget.chosenEmployeeId != null) {
        employeeId = widget.chosenEmployeeId;
        _editedEmployee = await getEmployee(employeeId);
        _nameController.text = _editedEmployee.name;
        setState(() {
          _myActivity = _editedEmployee.designation;
        });
        _selectedDate =
            DateTime.fromMillisecondsSinceEpoch(_editedEmployee.dob);
        _dobController.text = DateFormat.yMd().format(_selectedDate);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose(); // to prevent memory leakages
    _dobFocusNode.dispose();
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState
        .save(); //updated _editedProduct above when save is called in the fields below
    addRecord();
    Navigator.of(context).pushReplacementNamed(HomePage.id);
  }

  // remember context used here is the State_FUL context
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = DateFormat.yMd().format(_selectedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Designation>>(
        initialData: [],
        create: (context) => DesignationProvider().getDesignations(),
        child: AlertDialog(
          title: Text((employeeId > 0) ? 'Edit' : 'Add new Employee'),
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
                            _nameController, //either initial value or controller noth both
                        decoration: InputDecoration(labelText: 'name'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_dobFocusNode);
                        },
                        validator: (value) {
                          return (value.isEmpty)
                              ? 'Please provide a value'
                              : null;
                        },
                        onSaved: (value) {
                          setState(() {});
                          _editedEmployee = Employee(
                            value,
                            _editedEmployee.dob,
                            _editedEmployee.designation,
                          );
                        },
                      ),
                      Consumer<List<Designation>>(
                          builder: (_, designations, __) {
                        final newData = [];
                        designations.forEach((element) {
                          newData.add(element.toMap());
                        });
                        return DropDownFormField(
                          titleText: 'Designation',
                          hintText: 'Please choose one',
                          value: _myActivity,
                          onSaved: (value) {
                            final onEdit = _myActivity;
                            if (employeeId > 0) {
                              _myActivity = onEdit;
                            } else {
                              _myActivity = value;
                            }
                            _editedEmployee = Employee(
                              _editedEmployee.name,
                              _editedEmployee.dob,
                              _myActivity,
                            );
                          },
                          validator: (value) {
                            return (_myActivity == null)
                                ? 'Please provide a value'
                                : null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _myActivity = value;
                            });
                          },
                          dataSource: newData,
                          textField: 'display',
                          valueField: 'value',
                        );
                      }),
                      InkWell(
                        onTap: _presentDatePicker,
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: _dobController,
                            decoration: InputDecoration(labelText: 'dob'),
                            textInputAction: TextInputAction.done,
                            focusNode: _dobFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid Date.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedEmployee = Employee(
                                _editedEmployee.name,
                                _selectedDate.millisecondsSinceEpoch,
                                _editedEmployee.designation,
                              );
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _saveForm(), //_saveForm
                        child: new Container(
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: getAppBorderButton(
                              (employeeId > 0) ? "Edit" : "Add",
                              EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
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
    var db = EmployeeProvider();
    if (employeeId > 0) {
      _editedEmployee.setUserId(employeeId);
      await db.update(_editedEmployee);
    } else {
      await db.saveEmployee(_editedEmployee);
    }
  }

  Future<Employee> getEmployee(int id) async {
    var db = EmployeeProvider();
    return await db.getSingleEmployee(id);
  }
}
