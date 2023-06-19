import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Create a Form widget.
class PhoneForm extends StatefulWidget {
  const PhoneForm({super.key});

  @override
  PhoneFormState createState() {
    return PhoneFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class PhoneFormState extends State<PhoneForm>
  with RestorationMixin {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
  GlobalKey<FormFieldState<String>>();
  final _UsNumberTextInputFormatter _phoneNumberFormatter =
  _UsNumberTextInputFormatter();

  FocusNode? _phoneNumber;

  @override
  void initState() {
    super.initState();
    _phoneNumber = FocusNode();
  }

  @override
  void dispose() {
    _phoneNumber?.dispose();
    super.dispose();
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value),
        ),
    );
  }

  @override
  String get restorationId => 'phone_form_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_autoValidateModeIndex, 'autovalidate_mode');
  }

  final RestorableInt _autoValidateModeIndex =
  RestorableInt(AutovalidateMode.disabled.index);

  void _handleSubmitted() {
    final form = _formKey.currentState!;
    if (!form.validate()) {
      _autoValidateModeIndex.value =
          AutovalidateMode.always.index;
      showInSnackBar("Please enter a valid phone number");
    } else {
      form.save();
      showInSnackBar("Entered valid phone number");
    }
  }

  String? _validatePhoneNumber(String? value) {
    final phoneExp = RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
    if (!phoneExp.hasMatch(value!)) {
      return "Enter a valid phone number";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    // TODO separate?
    const phoneNumberDecoration = InputDecoration(
      filled: true,
      icon: Icon(Icons.phone),
      hintText: "Enter your phone number",
      labelText: "Phone number",
      prefixText: '+1 ',
    );

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            restorationId: 'phone_number_field',
            textInputAction: TextInputAction.next,
            focusNode: _phoneNumber,
            decoration: phoneNumberDecoration,
            keyboardType: TextInputType.phone,
            onSaved: (value) {
              // TODO what will it do?
            },
            maxLength: 14,
            maxLengthEnforcement: MaxLengthEnforcement.none,
            // The validator receives the text that the user has entered.
            validator: _validatePhoneNumber,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              // Fit the validating format.
              _phoneNumberFormatter,
            ],
          ),
          sizedBoxSpace,
          Center(
            child: ElevatedButton(
              onPressed: _handleSubmitted,
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newTextLength = newValue.text.length;
    final newText = StringBuffer();
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write('${newValue.text.substring(0, usedSubstringIndex = 3)}) ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write('${newValue.text.substring(3, usedSubstringIndex = 6)}-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write('${newValue.text.substring(6, usedSubstringIndex = 10)} ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

