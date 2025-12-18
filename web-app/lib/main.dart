import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

// ==========================================
// CHANGE YOUR DOMAIN HERE
// ==========================================
const String YOUR_WEBSITE_URL = 'https://l1.webnifybd.com/';
// ==========================================

void main() {
  runApp(const MaterialApp(
    home: WebnifyApp(),
    debugShowCheckedModeBanner: false,
    title: 'Webnify',
  ));
}

class WebnifyApp extends StatefulWidget {
  const WebnifyApp({super.key});

  @override
  State<WebnifyApp> createState() => _WebnifyAppState();
}

class _WebnifyAppState extends State<WebnifyApp> {
  late final WebViewController controller;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            // Check for connection errors
            if (error.errorCode == -2 || error.description.contains('net::ERR_INTERNET_DISCONNECTED')) {
              setState(() => hasError = true);
            }
          },
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;
            // Handle WhatsApp, Phone, and Email links
            if (url.startsWith('https://wa.me/') || 
                url.startsWith('whatsapp:') || 
                url.startsWith('tel:') || 
                url.startsWith('mailto:')) {
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(YOUR_WEBSITE_URL)); // Using the variable from the top
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              if (!hasError) WebViewWidget(controller: controller),
              
              // Loading Animation
              if (isLoading && !hasError)
                Container(
                  color: Colors.black,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitFadingCube(
                          color: Color(0xFFC8FF00),
                          size: 50.0,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Loading Webnify...",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),

              // Error Page (Offline)
              if (hasError)
                Container(
                  color: Colors.black,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.white, size: 80),
                      const SizedBox(height: 20),
                      const Text(
                        "No Internet Connection",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Please check your connection and try again.",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC8FF00),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        onPressed: () => _initializeController(),
                        child: const Text("RETRY"),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
