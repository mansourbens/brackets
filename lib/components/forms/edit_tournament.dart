import 'package:brackets/models/tournament.dart';
import 'package:brackets/utils/constants.dart';
import 'package:brackets/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditTournamentDialog extends StatefulWidget {
  final Tournament tournament;
  const EditTournamentDialog({Key? key, required this.tournament})
      : super(key: key);

  @override
  _EditTournamentDialogState createState() => _EditTournamentDialogState();
}

class _EditTournamentDialogState extends State<EditTournamentDialog> {
  late int _teamsNumber;
  late String _name;
  late String _description;
  late DateTime _startDate;
  late DateTime _endDate;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _teamsNumber = widget.tournament.teamsNumber;
    _name = widget.tournament.name;
    _description = widget.tournament.description;
    _startDate = DateTime.parse(widget.tournament.startDate);
    _endDate = DateTime.parse(widget.tournament.endDate);
    _nameController = TextEditingController();
    _nameController.text = _name;
    _descriptionController = TextEditingController();
    _descriptionController.text = _description;
    print(widget.tournament.id);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Editing new tournament'),
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
          const SizedBox(height: 8.0),
          Row(children: [
            const Expanded(flex: 4, child: Text('Start date : ')),
            Expanded(
                flex: 3,
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(6.0))),
                  onPressed: () => _selectStartDate(context),
                  child: Text(DateFormat('dd/MM/yyyy').format(_startDate)),
                )),
          ]),
          const SizedBox(height: 8.0),
          Row(children: [
            const Expanded(flex: 4, child: Text('End date : ')),
            Expanded(
                flex: 3,
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(6.0))),
                  onPressed: () => _selectEndDate(context),
                  child: Text(DateFormat('dd/MM/yyyy').format(_endDate)),
                )),
          ]),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child:
              const Text('Cancel', style: TextStyle(color: Colors.tealAccent)),
        ),
        const SizedBox(width: 64.0),
        TextButton(
          onPressed: () => showDialog<bool>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Deleting'),
              content: const Text(
                  'Are you sure you want to delete this match and all its matches ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.tealAccent)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes',
                      style: TextStyle(color: Colors.tealAccent)),
                ),
              ],
            ),
          ).then((value) async {
            if (value!) {
              PostgrestResponse response =
                  await _deleteTournament(widget.tournament);
              if (response.hasError) {
                context.showErrorSnackBar(message: response.error!.message);
              } else {
                context.showSnackBar(
                    message: 'Tournament deleted successfully');
              }
              Navigator.pop(context, null);
            }
          }),
          child: Text('Delete',
              style: TextStyle(color: Colors.redAccent.shade100)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(
              context,
              Tournament(
                  id: widget.tournament.id,
                  name: _nameController.text,
                  description: _descriptionController.text,
                  teamsNumber: _teamsNumber,
                  startDate: _startDate.toString(),
                  endDate: _endDate.toString(),
                  userId: widget.tournament.userId)),
          child: const Text('Edit', style: TextStyle(color: Colors.tealAccent)),
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
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2023),
    );
    if (selected != null && selected != _startDate) {
      setState(() {
        _endDate = DateTime.now();
        _startDate = selected;
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
      initialDate: _endDate.isAfter(_startDate)
          ? _endDate
          : _startDate.add(const Duration(days: 1)),
      firstDate: _startDate.add(const Duration(days: 1)),
      lastDate: DateTime(2023),
    );
    if (selected != null && selected != _endDate) {
      setState(() {
        _endDate = selected;
      });
    }
  }
}

Future<dynamic> editTournament(Tournament tournament) async {
  final response = await supabase
      .from('tournament')
      .update(tournament.toJson())
      .eq('id', tournament.id)
      .execute();

  return Future.value(response);
}

Future<dynamic> _deleteTournament(Tournament tournament) async {
  final response = await supabase
      .from('tournament')
      .delete()
      .eq('id', tournament.id)
      .execute();
  return Future.value(response);
}
