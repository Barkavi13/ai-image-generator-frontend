import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:hive/hive.dart';
import 'history_screen.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/glass_container.dart';
import 'dart:ui';
import 'image_viewer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController promptController = TextEditingController();

  String responseText = "";
  Uint8List? generatedImage;

  bool isLoading = false;
  String selectedStyle = "Realistic";

  List<String> styles = ["Realistic", "Anime", "3D Art", "Sketch", "Cyberpunk"];

  void generateResponse() async {
    setState(() {
      isLoading = true;
    });

    final result = await ApiService.generatePrompt(
      "$selectedStyle style, ${promptController.text}",
    );

    if (result["image_base64"] != null) {
      Uint8List imageBytes = base64Decode(result["image_base64"]);

      var historyBox = Hive.box('history');

      historyBox.add({
        "prompt": result["generated_prompt"],

        "image": result["image_base64"],

        "time": DateTime.now().toString(),
      });

      setState(() {
        responseText = result["generated_prompt"];

        generatedImage = imageBytes;

        isLoading = false;
      });
    } else {
      setState(() {
        responseText = result["error"] ?? "Unknown Error";

        isLoading = false;
      });
    }
  }

  Future<void> saveImage() async {
    if (generatedImage == null) {
      return;
    }

    var status = await Permission.photos.request();

    if (status.isGranted) {
      final tempDir = await Directory.systemTemp.createTemp();

      final file = File('${tempDir.path}/ai_image.png');

      await file.writeAsBytes(generatedImage!);

      await GallerySaver.saveImage(file.path);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Image saved to gallery")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Permission denied")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Image Generator"),

        centerTitle: true,

        actions: [
          IconButton(
            icon: Icon(Icons.history),

            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (_) => HistoryScreen()),
              );
            },
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF312E81)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.08),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),

                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),

                        child: TextField(
                          controller: promptController,
                          maxLines: 3,

                          style: TextStyle(color: Colors.white),

                          decoration: InputDecoration(
                            hintText: "Enter prompt...",
                            hintStyle: TextStyle(color: Colors.white70),

                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedStyle,

                  dropdownColor: Color(0xFF1E293B),

                  decoration: InputDecoration(
                    labelText: "AI Style",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),

                  style: TextStyle(color: Colors.white),

                  items: styles.map((style) {
                    return DropdownMenuItem(value: style, child: Text(style));
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      selectedStyle = value!;
                    });
                  },
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),

                    gradient: LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.4),
                        blurRadius: 15,
                        spreadRadius: 1,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),

                  child: ElevatedButton(
                    onPressed: generateResponse,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    child: Text(
                      "Generate",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                if (isLoading) Center(child: CircularProgressIndicator()),

                if (!isLoading && responseText.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Generated Prompt:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(responseText, style: TextStyle(fontSize: 18)),

                      SizedBox(height: 30),

                      if (generatedImage != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Generated Image:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 15),

                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white.withOpacity(0.08),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),

                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 15,
                                    sigmaY: 15,
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,

                                    children: [
                                      // IMAGE SECTION
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ImageViewer(
                                                imageBytes: generatedImage!,
                                              ),
                                            ),
                                          );
                                        },

                                        child: Image.memory(
                                          generatedImage!,
                                          height: 320,
                                          fit: BoxFit.contain,
                                        ),
                                      ),

                                      // BUTTON SECTION
                                      Padding(
                                        padding: EdgeInsets.all(15),

                                        child: ElevatedButton.icon(
                                          onPressed: saveImage,

                                          icon: Icon(Icons.download),
                                          label: Text("Download Image"),

                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF8B5CF6),

                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),

                                            padding: EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            ElevatedButton.icon(
                              onPressed: saveImage,

                              icon: Icon(Icons.download),

                              label: Text("Download Image"),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
