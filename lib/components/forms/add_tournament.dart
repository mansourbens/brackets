import 'package:brackets/models/tournament.dart';
import 'package:brackets/utils/constants.dart';
import 'package:brackets/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTournamentDialog extends StatefulWidget {
  const NewTournamentDialog({
    Key? key,
  }) : super(key: key);

  @override
  _NewTournamentDialogState createState() => _NewTournamentDialogState();
}

class _NewTournamentDialogState extends State<NewTournamentDialog> {
  int _teamsNumber = 2;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isStartDateSelected = false;
  bool isEndDateSelected = false;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose(); // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Adding new tournament'),
      content: Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _nameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name';
              }
              return null;
            },
            decoration: buildInputDecoration('Name', null),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            textInputAction: TextInputAction.next,
            controller: _descriptionController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Description';
              }
              return null;
            },
            decoration: buildInputDecoration('Description', null),
          ),
          const SizedBox(height: 20.0),
          Row(children: [
            const Expanded(flex: 3, child: Text('Number of teams : ')),
            Expanded(
                flex: 1,
                child: DropdownButton<int>(
                    value: _teamsNumber,
                    onChanged: (int? newValue) {
                      setState(() {
                        _teamsNumber = newValue!;
                      });
                    },
                    items: [2, 4, 8, 16, 32]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem(
                          child: Text(value.toString()), value: value);
                    }).toList()))
          ]),
          Row(children: [
            const Expanded(flex: 4, child: Text('Start date : ')),
            Expanded(
                flex: 3,
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(6.0))),
                  onPressed: () => _selectStartDate(context),
                  child: (isStartDateSelected)
                      ? Text(DateFormat('dd/MM/yyyy').format(startDate))
                      : const Text('Choose a date'),
                )),
          ]),
          Row(children: [
            const Expanded(flex: 4, child: Text('End date : ')),
            Expanded(
                flex: 3,
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(6.0))),
                  onPressed: () => _selectEndDate(context),
                  child: (isEndDateSelected)
                      ? Text(DateFormat('dd/MM/yyyy').format(endDate))
                      : const Text('Choose a date'),
                )),
          ]),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child:
              const Text('Cancel', style: TextStyle(color: Colors.tealAccent)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(
              context,
              Tournament(
                  name: _nameController.text,
                  description: _descriptionController.text,
                  teamsNumber: _teamsNumber,
                  startDate: startDate.toString(),
                  endDate: endDate.toString(),
                  userId: supabase.auth.user()!.id)),
          child: const Text('Add', style: TextStyle(color: Colors.tealAccent)),
        ),
      ],
    );
  }

  _selectStartDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      builder: (context, child) {
        return Theme(
            data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                    primary: Colors.tealAccent,
                    onPrimary: Colors.teal.shade800),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(primary: Colors.tealAccent))),
            child: child!);
      },
      helpText: '',
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2023),
    );
    if (selected != null && selected != startDate) {
      setState(() {
        isStartDateSelected = true;
        isEndDateSelected = false;
        endDate = DateTime.now();
        startDate = selected;
      });
    }
  }

  _selectEndDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      builder: (context, child) {
        return Theme(
            data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                    primary: Colors.tealAccent,
                    onPrimary: Colors.teal.shade800),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(primary: Colors.tealAccent))),
            child: child!);
      },
      helpText: '',
      context: context,
      initialDate: endDate.isAfter(startDate)
          ? endDate
          : startDate.add(const Duration(days: 1)),
      firstDate: startDate.add(const Duration(days: 1)),
      lastDate: DateTime(2023),
    );
    if (selected != null && selected != endDate) {
      setState(() {
        isEndDateSelected = true;
        endDate = selected;
      });
    }
  }
}

Future<dynamic> addTournament(Tournament tournament) async {
  final response =
      await supabase.from('tournament').insert(tournament.toJson()).execute();

  return Future.value(response);
}
