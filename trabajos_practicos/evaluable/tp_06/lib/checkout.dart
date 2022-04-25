import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
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

class AddressInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          const Text("Domicilio"),
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
          Row(
            children: [
              Expanded(child: _buildCashOption()),
              Expanded(child: _buildVISAOption())
            ],
          ),
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
  late DateTime _selectedDate;
  late TimeRange _selectedRange;

  @override
  void initState() {
    _selectedDate = DateTime.now();
    _selectedRange = TimeRange(
        startTime: TimeOfDay.now(),
        endTime: TimeOfDay.now().replacing(
          hour: TimeOfDay.now().hour + 1,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          const Text("Envío"),
          Row(
            children: [
              Expanded(child: _buildASAPOption()),
              Expanded(child: _buildSelectedOption())
            ],
          ),
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
        _buildDateInput(),
        _buildHourRangeInput(),
      ],
    );
  }

  Widget _buildDateInput() {
    String formattedDate = _dateFormat.format(_selectedDate);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Text("Fecha de Entrega"),
        ),
        Expanded(
          child: Text(formattedDate),
        ),
        Expanded(
          child: TextButton(
              child: const Text("Cambiar Fecha"),
              onPressed: () async {
                var date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  initialDate: _selectedDate,
                  lastDate: DateTime.now().add(const Duration(days: 7)),
                );
                setState(() {
                  _selectedDate = date ?? DateTime.now();
                });
              }),
        )
      ],
    );
  }

  Widget _buildHourRangeInput() {
    var formattedRange = "${_selectedRange.startTime.format(context)} "
        "y ${_selectedRange.endTime.format(context)}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Text("Hora de Entrega"),
        ),
        Expanded(
          child: Text(formattedRange),
        ),
        Expanded(
          child: TextButton(
              child: const Text("Cambiar Rango"),
              onPressed: () async {
                TimeRange range = await showTimeRangePicker(
                  context: context,
                );
                setState(() {
                  _selectedRange = range;
                });
              }),
        )
      ],
    );
  }
}
