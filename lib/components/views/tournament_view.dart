import 'package:brackets/components/icons.dart';
import 'package:brackets/models/tournament.dart';
import 'package:brackets/utils/constants.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';

class TournamentView extends StatefulWidget {
  const TournamentView({
    Key? key,
  }) : super(key: key);

  @override
  _TournamentViewState createState() => _TournamentViewState();
}

List<Tournament> parseTournaments(List<dynamic> responseData) {
  return responseData
      .map<Tournament>((json) => Tournament.fromJson(json))
      .toList();
}

Future<List<Tournament>> fetchTournaments() async {
  final response = await supabase.from('tournament').select().execute();
  if (response.hasError) {
    return Future.error(response.error!);
  }
  return Future.value(parseTournaments(response.data));
}

class _TournamentViewState extends State<TournamentView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tournament>>(
        future: fetchTournaments(),
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = snapshot.data!.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) =>
                        buildTournamentCard(snapshot.data![index]))
                : FDottedLine(
                    color: Colors.tealAccent,
                    strokeWidth: 2.0,
                    dottedLength: 10.0,
                    space: 2.0,
                    child: const SizedBox(
                        height: 300.0,
                        width: 300.0,
                        child: Center(
                          child: Text(
                            'No records found.\n Feel free to add a new tournament.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28.0, fontWeight: FontWeight.w100),
                          ),
                        )),
                  );
          } else if (snapshot.hasError) {
            child = Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error : ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            );
          } else {
            child = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Loading...'),
                  )
                ]);
          }
          return Center(child: child);
        });
  }
}

buildTournamentCard(Tournament tournament) {
  return SizedBox(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shadowColor: Colors.white,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.white,
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                    height: 72.0,
                    width: 72.0,
                    decoration: const BoxDecoration(
                      color: Color(0xCBEFF3FA),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    height: 58.0,
                    width: 58.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDEEF7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CustomIcons.trophy,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tournament.name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'About : ${tournament.description}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Number of teams : ${tournament.teamsNumber}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Start date : ${tournament.startDate}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'End date : ${tournament.endDate}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shadowColor: const Color(0xFF35ECDC),
                                padding: EdgeInsets.zero,
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0))),
                            onPressed: () {},
                            child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.teal.shade200, Colors.teal],
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Container(
                                  width: 84.0,
                                  height: 36.0,
                                  alignment: Alignment.center,
                                  child: const Text('Go to brackets',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 10.0,
                                          color: Colors.white)),
                                )),
                          ),
                          const SizedBox(width: 8.0),
                          OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.white,
                                padding: EdgeInsets.zero,
                                elevation: 0.0,
                                side: const BorderSide(
                                  color: Colors.teal,
                                  width: 1.0,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0))),
                            onPressed: () {},
                            child: Container(
                              width: 84.0,
                              height: 36.0,
                              alignment: Alignment.center,
                              child: Text('Edit',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.teal.shade700)),
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
