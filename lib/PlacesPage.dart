import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlacesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sitios Turísticos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Llama a la función que obtiene los datos de Firestore
        future: fetchTouristSites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos disponibles.'));
          } else {
            // Muestra la lista de lugares turísticos
            List<Map<String, dynamic>> touristSites = snapshot.data!;
            return ListView.builder(
              itemCount: touristSites.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> site = touristSites[index];
                return ListTile(
                  title: Text(site['name']),
                  subtitle: Text(site['description']),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Función para obtener los datos de Firestore
  Future<List<Map<String, dynamic>>> fetchTouristSites() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('tourist_sites').get();

    // Convierte los documentos a una lista de mapas
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
