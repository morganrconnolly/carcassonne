import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
	//FirebaseFirestore firestore = FirebaseFirestore.instance;
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    //if(_error) { }

    // Show a loader until FlutterFire is initialized
    //if (!_initialized) { }
    return MaterialApp(
		title: 'hello',
		home: Scaffold(
			appBar: AppBar(
				title: Text("hello"),
			),
			body: Center(
				child: GetTileImg("starttile"),
			),
		)
		);
  }
}
class GetTileImg extends StatelessWidget {
  final String documentId;

  GetTileImg(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference tiles = FirebaseFirestore.instance.collection('tiles');

    return FutureBuilder<DocumentSnapshot>(
      future: tiles.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("img: ${data['img']}");
        }

        return Text("loading");
      },
    );
  }
}
