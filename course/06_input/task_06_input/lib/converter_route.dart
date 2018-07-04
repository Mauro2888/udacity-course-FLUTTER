// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// This [Category]'s name.
  final String name;

  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the name, color, and units to not be null.
  const ConverterRoute({
    @required this.name,
    @required this.color,
    @required this.units,
  })  : assert(name != null),
        assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  // TODO: Set some variables, such as for keeping track of the user's input
  // value and units
  Unit _toUnit, _fromUnit;
  double _inputValue;
  String _convertedValue = '';

  bool _showValidationError = false;

  List<DropdownMenuItem> _dropdownMenuItems;

  // TODO: Determine whether you need to override anything, such as initState()
  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems();
    _setDefaults();
  }

  // TODO: Add other helper functions. We've given you one, _format()

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create the 'input' group of widgets. This is a Column that includes
    // includes the output value, and 'from' unit [Dropdown].
    final input = Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            // style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
              labelText: 'Input',
              errorText: _showValidationError ? "Invalid number" : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: _updateInputValue,
          ),
          _createDropDown(_fromUnit.name, _updateFromConversion)
        ],
      ),
    );

    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final output = Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            child: Text(
              _convertedValue,
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          _createDropDown(
            _toUnit.name,
            _updateToConversion,
          )
        ],
      ),
    );

    final converterPage = Column(
      children: <Widget>[
        input,
        arrows,
        output,
      ],
    );

    return Padding(
      padding: _padding,
      child: converterPage,
    );
  }

  void _updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        try {
          final inputDouble = double.parse(input);

          _showValidationError = false;
          _inputValue = inputDouble;
          //Complete: Update conversion
          _updateConversion();
        } on Exception catch (e) {
          print('Error $e');
          _showValidationError = true;
        }
      }
    });
  }

  void _updateConversion() {
    setState(() {
      _convertedValue =
          _format(_inputValue * (_toUnit.conversion / _fromUnit.conversion));
    });
  }

  //according to dropdown menu item value which is a unit name, we get the Unit
  Unit getUnit(unitName) {
    return widget.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toUnit = getUnit(unitName);
    });
    //Complete: Update conversion
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromUnit = getUnit(unitName);
    });
    //Complete: Update conversion
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  Widget _createDropDown(String currentValue, ValueChanged<dynamic> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(border: Border.all()),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: currentValue,
          items: _dropdownMenuItems,
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _createDropdownMenuItems() {
    var newMenuItems = new List<DropdownMenuItem>();

    for (var i = 0; i < widget.units.length; i++) {
      newMenuItems.add(DropdownMenuItem(
        value: widget.units[i].name,
        child: Text(widget.units[i].name),
      ));
    }

    setState(() {
      _dropdownMenuItems = newMenuItems;
    });
  }

  void _setDefaults() {
    setState(() {
      _toUnit = widget.units[0];
      _fromUnit = widget.units[1];
    });
  }

// DONE: Create a compare arrows icon.

// DONE: Create the 'output' group of widgets. This is a Column that

// DONE: Return the input, arrows, and output widgets, wrapped in

// DONE: Delete the below placeholder code

}
