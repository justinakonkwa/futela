import 'package:flutter/material.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/lign.dart';

class ReserveScreen extends StatefulWidget {
  final List<String> imagePath;
  final int index;

  const ReserveScreen({super.key,required this.imagePath,required this.index
});

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  DateTimeRange? _selectedDateRange;
  Color _intervalColor = Colors.grey;

  // Variables pour gérer les tranches d'âge
  int _adults = 1;
  int _children = 0;
  int _babies = 0;
  int _pets = 0;

  // Méthode pour ouvrir le sélecteur de plage de dates
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 7)),
          ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _intervalColor = Colors.blue;
      });
    }
  }

  // Méthode pour ouvrir le modal des tranches d'âge
  void _showTravelerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTravelerRow('Adultes', _adults, (value) {
                setState(() => _adults = value);
              }),
              _buildTravelerRow('Enfants', _children, (value) {
                setState(() => _children = value);
              }),
              _buildTravelerRow('Bébés', _babies, (value) {
                setState(() => _babies = value);
              }),
              _buildTravelerRow('Animaux de compagnie', _pets, (value) {
                setState(() => _pets = value);
              }),
            ],
          ),
        );
      },
    );
  }

  // Widget pour afficher chaque tranche d'âge avec les boutons
  Widget _buildTravelerRow(
      String label, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTextLarge(text: label, size: 14),
          Row(
            children: [
              IconButton(
                onPressed: () => onChanged(value > 0 ? value - 1 : 0),
                icon:
                    const Icon(Icons.remove_circle_outline, color: Colors.red),
              ),
              Text(value.toString(), style: const TextStyle(fontSize: 16)),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTextLarge(text: 'Confirmer et payer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    // child: Image.asset(
                    //   widget.imagePath[1],
                    //   fit: BoxFit.cover,
                    // ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _intervalColor,
                      image: DecorationImage(image: AssetImage(widget.imagePath[widget.index]))
                    ),
                  ),
                  sizedbox2,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextLarge(
                        text: 'Cave House, suite dans la nature',
                        size: 13,
                      ),
                      AppText(text: 'Grotte'),
                      SizedBox(
                        height: 50,
                      ),
                      AppText(text: '*** 4,89 Superhôte'),
                    ],
                  ),
                ],
              ),
              sizedbox,
              const Lign(indent: 20, endIndent: 20),
              sizedbox,
              Align(
                  alignment: Alignment.centerLeft,
                  child: AppTextLarge(
                    text: 'Votre voyage',
                    size: 14,
                  )),
              sizedbox,
              Align(
                alignment: Alignment.centerLeft,
                child: AppTextLarge(
                  text: 'Dates',
                  size: 14,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: _selectedDateRange != null
                        ? '${_selectedDateRange!.start.day}-${_selectedDateRange!.end.day} ${_selectedDateRange!.start.month}'
                        : '17-25 décembre',
                  ),
                  GestureDetector(
                    onTap: _selectDateRange,
                    child: AppText(
                      text: 'Modifier',
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              sizedbox,
              const Lign(indent: 20, endIndent: 20),
              sizedbox,
              Align(
                alignment: Alignment.centerLeft,
                child: AppTextLarge(
                  text: 'Voyageurs',
                  size: 14,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                      text:
                          '$_adults adultes, $_children enfants, $_babies bébés, $_pets animaux'),
                  GestureDetector(
                    onTap: _showTravelerModal,
                    child: AppText(
                      text: 'Modifier',
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              sizedbox,
              const Lign(indent: 20, endIndent: 20),
              sizedbox,
              Align(
                alignment: Alignment.centerLeft,
                child: AppTextLarge(
                  text: 'Details du prix',
                  size: 14,
                ),
              ),
              sizedbox,
              sizedbox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(text: '243,00 * 5 nuits'),
                  AppText(text: '1 170.00\$'),
                ],
              ),
              sizedbox,
              const Lign(
                indent: 40,
                endIndent: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextLarge(
                    text: 'Total(\$)',
                    size: 14,
                  ),
                  AppText(text: '1 170.00\$'),
                ],
              ),
              sizedbox,
              const Lign(
                indent: 20,
                endIndent: 20,
              ),
              sizedbox,
              Align(
                alignment: Alignment.centerLeft,
                child: AppTextLarge(
                  text: 'Payer avec',
                  size: 14,
                ),
              ),
              sizedbox,
              Container(
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).highlightColor,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    Icon(Icons.account_balance_wallet_outlined),
                    sizedbox2,
                    sizedbox2,
                    AppText(
                      text: 'Carte de crédit ou débit',
                    )
                  ],
                ),
              ),
              sizedbox,
              Container(
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).highlightColor,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    Icon(Icons.account_balance_wallet_outlined),
                    sizedbox2,
                    sizedbox2,
                    AppText(
                      text: 'Carte bancaire',
                    )
                  ],
                ),
              ),
              sizedbox,
              sizedbox,
              NextButton(
                color: Theme.of(context).colorScheme.primary,
                onTap: () {},
                child: AppText(
                  text: 'Confirmer et payer',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
