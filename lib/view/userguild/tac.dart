import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/loading.dart';

// ignore: camel_case_types
class tac extends StatelessWidget {
  tac({Key? key}) : super(key: key);
  static const routeName = '/TermsAndConditions';

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('extras');
    return Scaffold(
        appBar: AppBar(
          title: Text("Terms and Conditions"),
        ),
        body: Center(
          child: Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: FutureBuilder<DocumentSnapshot>(
                future: users.doc('tac').get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
          
                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("Document does not exist");
                  }
          
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "${data['one']}",
                          ),
                        ),
                      ),
                    );
                  }
                  return Loading();
                },
              )),
        ));
  }
}
