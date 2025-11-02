import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/widgets/vs_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  List<FootballMatch> _matchList = [];
  bool _inProgress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFootballMatches();
  }

  Future<void> _getFootballMatches() async {
    _inProgress = true;
    setState(() {

    });
    _matchList.clear();
    final snapshot = await FirebaseFirestore.instance
        .collection("football")
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      _matchList.add(FootballMatch(
          id: doc.id,
          team1: doc.get("team1_name"),
          team1Score: doc.get("team1_score"),
          team2: doc.get("team2_name"),
          team2Score: doc.get("team2_score"),
          isRunning: doc.get("is_running"),
          winner: doc.get("winner_team")));
    }
    _inProgress = false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Live score")),
      body: Visibility(
        visible: _inProgress==false,
        replacement: Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.builder(
          itemCount: _matchList.length,
          itemBuilder: (context, index) {
            final footballMatch = _matchList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Container(
                alignment: Alignment.center,
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    CircleAvatar(backgroundColor: footballMatch.isRunning ? Colors.red : Colors.grey,
                      radius: 5,),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${footballMatch.team1}",style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),),
                                    Text("${footballMatch.team1Score}",style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),),
                                  ],
                                ),
                                Text("VS",style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${footballMatch.team2}",style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,

                                    ),),
                                    Text("${footballMatch.team2Score}",style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Winner : ",style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),),
                              Text("${footballMatch.winner}",style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),),
                            ],
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    )

                  ],
                ),

              ),
            );
          },
        ),
      ),
    );
  }
}

class FootballMatch {
  final String id;
  final String team1;
  final int team1Score;
  final String team2;
  final int team2Score;
  final bool isRunning;
  final String winner;

  FootballMatch({
    required this.id,
    required this.team1,
    required this.team1Score,
    required this.team2,
    required this.team2Score,
    required this.isRunning,
    required this.winner,
  });
}




