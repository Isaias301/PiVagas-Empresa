import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pivagas_empresa/model/vaga.dart';
import 'package:pivagas_empresa/view/nova_vaga.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pivagas_empresa/view/login.dart';

final db = FirebaseDatabase.instance.reference().child('vaga');

class ListViewVaga extends StatefulWidget {
  @override
  _ListViewVagaState createState() => new _ListViewVagaState();
}

class _ListViewVagaState extends State<ListViewVaga> {
  _ListViewVagaState(){
    _getCurrentUser();
  }
  
  List<Vaga> items;
  StreamSubscription<Event> _creatVagaSubscription;
  StreamSubscription<Event> _updateVagaSubscription;  
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn _gSignIn = new GoogleSignIn();
  String userName = "";
  String userEmail = "";
  String userImage = "";
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PiVagas Empresa',
      home: Scaffold(
        appBar: AppBar(
          title: Text('PiVagas Empresa'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget> [
            UserAccountsDrawerHeader(
              accountName: Text("${userName}"),
              accountEmail: Text("${userEmail}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color(0xFF212121),
                child: Image.network(
                  "${userImage}"
                ),
                // FlutterLogo(size: 42.0),
                // backgroundColor: Colors.white,
              ),
            ),
            ListTile(
              title: Text('Inicio'),
              onTap: () {
                _HomeNavegate();
                // _getCurrentUser();
              },
            ),           
            new Divider(),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                _signOut();
              },
            ),
          ],
        )
      ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${items[position].title}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      subtitle: Text(
                        'Descrição: ${items[position].description}',
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      leading: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(10.0)),
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 15.0,
                            child: Text(
                              '${position + 1}',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () => _deleteVaga(context, items[position], position)),
                        ],
                      ),
                      onTap: () => _navigateToVaga(context, items[position]),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewVaga(context),
        ),
      ),
    );
  }

  Future <void> _signOut() async{
    await _gSignIn.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();

    items = new List();

    _creatVagaSubscription = db.onChildAdded.listen(_creatVaga);
    _updateVagaSubscription = db.onChildChanged.listen(_vagaUpdated);
  }

  @override
  void dispose() {
    _creatVagaSubscription.cancel();
    _updateVagaSubscription.cancel();
    super.dispose();
  }

  _getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userName = user.displayName;
    userEmail = user.email;
    userImage = user.photoUrl;
    print(userImage);
    if(userImage == ""){
      print("ok");
    }else{
      print("ok");
    }
  }

  void _creatVaga(Event event) {
    setState(() {
      items.add(new Vaga.fromSnapshot(event.snapshot));
    });
  }

  void _vagaUpdated(Event event) {
    var oldNoteValue = items.singleWhere((vaga) => vaga.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldNoteValue)] = new Vaga.fromSnapshot(event.snapshot);
    });
  }

  void _deleteVaga(BuildContext context, Vaga vaga, int position) async {
    await db.child(vaga.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToVaga(BuildContext context, Vaga vaga) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageVaga(vaga)),
    );
  }

  void _createNewVaga(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageVaga(Vaga(null, '', ''))),
    );
  }

  void _HomeNavegate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListViewVaga()),
    );
  }

}