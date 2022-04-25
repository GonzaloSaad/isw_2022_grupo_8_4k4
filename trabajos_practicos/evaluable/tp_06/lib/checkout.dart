import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:time_range_picker/time_range_picker.dart';

import 'cartmodel.dart';

class CheckoutPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("Realizar Pedido"),
      ),
      body: _CheckoutForm(),
    );
  }
}

class _CheckoutForm extends StatefulWidget {
  @override
  State<_CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<_CheckoutForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildOrderDetail(),
            const Text("Domicilio"),
            Location(),
            //const Divider(color: Colors.black),
            AddressInformation(),
            //const Divider(color: Colors.black),
            PaymentMethod(),
            //const Divider(color: Colors.black),
            ShipmentMoment(),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetail() {
    CartModel cart = ScopedModel.of<CartModel>(context);
    return Container();
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            CartModel cart = ScopedModel.of<CartModel>(context);
            cart.clearCart();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pedido Enviado')),
            );
          }
        },
        child: const Text('Enviar Pedido'),
      ),
    );
  }
}

/*
Address
*/



class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _SelectLocation();
}

class _SelectLocation extends State<Location> {
  String dropdownValue = 'Córdoba';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 0,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Córdoba', 'Villa Allende', 'La Calera']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}


class AddressInformation extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          _buildStreetNameTextField(context),
          _buildStreetNumberTextField(),
        ],
      ),
    );
  }



  TextFormField _buildStreetNameTextField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Ingresá la calle',
      ),
      validator: (value) {
        if (value != null) {
          if (value.trim().isEmpty) {
            return "Ingrese un nombre no vacío.";
          }
        }
        return null;
      },
    );
  }

  TextFormField _buildStreetNumberTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Ingresá la altura',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value != null) {
          if (value.trim().isEmpty) {
            return "Ingrese una altura no vacía.";
          }

          int enteredValue = int.parse(value);

          if (enteredValue <= 0) {
            return "Ingrese una altura positiva.";
          }
        }
        return null;
      },
    );
  }
}

/*
Payment
*/
enum PaymentMethods { cash, visa }

class PaymentMethod extends StatefulWidget {
  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  PaymentMethods? _paymentMethod = PaymentMethods.cash;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          const Text("Forma De Pago"),
          _buildCashOption(),
          _buildVISAOption(),
          _buildPaymentInput(),
        ],
      ),
    );
  }

  ListTile _buildVISAOption() {
    return ListTile(
      title: const Text('Tarjeta VISA'),
      leading: Radio<PaymentMethods>(
        value: PaymentMethods.visa,
        groupValue: _paymentMethod,
        onChanged: (PaymentMethods? value) {
          setState(() {
            _paymentMethod = value;
          });
        },
      ),
    );
  }

  ListTile _buildCashOption() {
    return ListTile(
      title: const Text('Efectivo'),
      leading: Radio<PaymentMethods>(
        value: PaymentMethods.cash,
        groupValue: _paymentMethod,
        onChanged: (PaymentMethods? value) {
          setState(() {
            _paymentMethod = value;
          });
        },
      ),
    );
  }

  Widget _buildPaymentInput() {
    if (_paymentMethod == PaymentMethods.cash) {
      return _buildCashInput();
    }
    return _buildVISAInput();
  }

  Widget _buildVISAInput() {
    return const Text("VISA");
  }

  Widget _buildCashInput() {
    return TextFormField(
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Ingresá con cuanto pagas',
      ),
      inputFormatters: [CurrencyTextInputFormatter(symbol: "\$")],
      keyboardType: TextInputType.number,
      validator: (value) {
        CartModel cart = ScopedModel.of<CartModel>(context);
        if (value != null) {
          if (value.isEmpty) {
            return "Ingrese un monto no vacío.";
          }

          double enteredValue = double.parse(value.replaceAll("\$", ""));

          if (enteredValue <= 0) {
            return "Ingrese un monto positivo mayor a 0.";
          }
          if (enteredValue < cart.cartTotalWithShipping()) {
            return "El monto debe ser igual o mayor al total.";
          }
        }
        return null;
      },
    );
  }
}

/*
Shipment
*/

enum ShipmentMoments { asap, selected }

class ShipmentMoment extends StatefulWidget {
  @override
  State<ShipmentMoment> createState() => _ShipmentMomentState();
}

class _ShipmentMomentState extends State<ShipmentMoment> {
  ShipmentMoments? _shipmentMoments = ShipmentMoments.asap;
  final _dateFormat = DateFormat("dd/MM/yyyy");
  final DateTime _selectedDate = DateTime.now();
  final TimeRange _selectedRange = TimeRange(
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay.now().replacing(
        hour: TimeOfDay.now().hour + 1,
      ));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          const Text("Envío"),
          _buildASAPOption(),
          _buildSelectedOption(),
          _buildShipmentInput(),
        ],
      ),
    );
  }

  ListTile _buildASAPOption() {
    return ListTile(
      title: const Text('Lo Antes Posible'),
      leading: Radio<ShipmentMoments>(
        value: ShipmentMoments.asap,
        groupValue: _shipmentMoments,
        onChanged: (ShipmentMoments? value) {
          setState(() {
            _shipmentMoments = value;
          });
        },
      ),
    );
  }

  ListTile _buildSelectedOption() {
    return ListTile(
      title: const Text('Elegir Fecha'),
      leading: Radio<ShipmentMoments>(
        value: ShipmentMoments.selected,
        groupValue: _shipmentMoments,
        onChanged: (ShipmentMoments? value) {
          setState(() {
            _shipmentMoments = value;
          });
        },
      ),
    );
  }

  Widget _buildShipmentInput() {
    if (_shipmentMoments == ShipmentMoments.selected) {
      return _buildSelectedDate();
    }
    return Container();
  }

  Widget _buildSelectedDate() {
    return Column(
      children: <Widget>[
        // const Text('Ingresá la fecha'),
        _showSelectedDate(),
        _buildHourRangeInput()
      ],
    );
  }

  Widget _showSelectedDate() {
    String formattedDate = _dateFormat.format(_selectedDate);
    return Text(
      "Entregar el pedido el día $formattedDate "
      "entre ${_selectedRange.startTime.format(context)} "
      "y ${_selectedRange.endTime.format(context)}",
    );
  }

  Widget _buildDateInput() {
    String formattedDate = _dateFormat.format(_selectedDate);
    return Text("Entregar el pedido el día $formattedDate");
    return DateTimeField(
      format: _dateFormat,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 7)),
        );
        return date;
      },
    );
  }

  Widget _buildHourRangeInput() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          TimeRange result = await showTimeRangePicker(
            context: context,
          );
          print("result " + result.toString());
        },
        child: const Text("Elegir Rango"),
      ),
    );
  }
}
