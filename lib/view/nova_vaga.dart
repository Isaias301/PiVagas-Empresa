import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pivagas_empresa/model/vaga.dart';

final db = FirebaseDatabase.instance.reference().child('vaga');

class PageVaga extends StatefulWidget {
  final Vaga vaga;
  PageVaga(this.vaga);
  
  @override
  State<StatefulWidget> createState() => new _PageVagaState();
}

class _PageVagaState extends State<PageVaga> {
  TextEditingController _titleController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    
    _titleController = new TextEditingController(text: widget.vaga.title);
    _descriptionController = new TextEditingController(text: widget.vaga.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Vaga')),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título da Vaga'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição da Vaga'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: (widget.vaga.id != null) ? Text('Atualizar') : Text('Adicionar'),
              onPressed: () {
                if (widget.vaga.id != null) {
                  db.child(widget.vaga.id).set({
                    'title': _titleController.text,
                    'description': _descriptionController.text
                  }).then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  db.push().set({
                    'title': _titleController.text,
                    'description': _descriptionController.text
                  }).then((_) {
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
