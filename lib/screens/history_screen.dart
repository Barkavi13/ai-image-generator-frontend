import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var historyBox = Hive.box('history');

    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF312E81)],
          ),
        ),

        child: ListView.builder(
          padding: EdgeInsets.all(15),

          itemCount: historyBox.length,

          itemBuilder: (context, index) {
            var item = historyBox.getAt(index);

            Uint8List imageBytes = base64Decode(item["image"]);

            return Container(
              margin: EdgeInsets.only(bottom: 15),

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),

                borderRadius: BorderRadius.circular(25),

                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),

                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),

                  child: Padding(
                    padding: EdgeInsets.all(15),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),

                          child: Image.memory(
                            imageBytes,

                            height: 200,

                            width: double.infinity,

                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(height: 15),

                        Text(
                          item["prompt"],

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          item["time"],

                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),

                        SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,

                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),

                            onPressed: () {
                              historyBox.deleteAt(index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
