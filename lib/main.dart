import 'package:flutter/material.dart';
import 'user_model.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const MyHomePage(title: 'User Directory'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: ApiService.fetchUser(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          String formatBirthDate(String rawDate) {
            try {
              DateTime date = DateTime.parse(rawDate).toLocal();
              return DateFormat('dd MMM yyyy').format(date);

            } catch (e) {
              return rawDate;
            }
          }


          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 10),
                  Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('ลองใหม่'),
                  )
                ],
              ),
            );
          }

          final users = snapshot.data!;


          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];


              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.indigo.shade100, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(user.avatar),
                          onBackgroundImageError: (_, __) {

                          },
                          backgroundColor: Colors.grey[200],
                          child: user.avatar.isEmpty
                              ? const Icon(Icons.person, size: 35)
                              : null,
                        ),
                      ),

                      const SizedBox(width: 16),


                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 6),


                            Row(
                              children: [
                                Icon(Icons.cake, size: 16, color: Colors.indigo[400]),
                                const SizedBox(width: 4),
                                Text(
                                  "${user.age} ปี",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.location_on, size: 16, color: Colors.red[400]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    user.city,
                                    style: TextStyle(color: Colors.grey[700]),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),


                            Row(
                              children: [
                                Icon(Icons.calendar_month, size: 16, color: Colors.orange[400]),
                                const SizedBox(width: 4),
                                Text(
                                  formatBirthDate(user.birthdate),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                  ),
                                ),



                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}