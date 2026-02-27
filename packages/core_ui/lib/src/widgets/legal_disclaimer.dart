import 'package:flutter/material.dart';

class LegalDisclaimerScreen extends StatefulWidget {
  final Widget nextScreen;
  final String appType; // "HEALTH" or "FINANCE"

  const LegalDisclaimerScreen({
    super.key,
    required this.nextScreen,
    this.appType = "HEALTH",
  });

  @override
  State<LegalDisclaimerScreen> createState() => _LegalDisclaimerScreenState();
}

class _LegalDisclaimerScreenState extends State<LegalDisclaimerScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.security, size: 64, color: Colors.blueAccent),
              const SizedBox(height: 24),
              const Text(
                "Important Disclaimer",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                widget.appType == "HEALTH"
                    ? "This application is for informational and educational purposes only. It does not provide medical advice and is not intended to diagnose, treat, cure, or prevent any disease. Always consult a qualified healthcare professional before making any decisions regarding your health, diet, or fasting schedule."
                    : "This application is for informational and educational purposes only. It does not constitute financial, investment, or legal advice. The calculations provided are estimates and should not be solely relied upon for financial decisions. Always consult a certified financial advisor before making any financial commitments.",
                style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _agreed,
                    onChanged: (val) {
                      setState(() {
                        _agreed = val ?? false;
                      });
                    },
                    fillColor: WidgetStateProperty.resolveWith(
                        (states) => states.contains(WidgetState.selected) ? Colors.blueAccent : Colors.transparent),
                    side: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  const Expanded(
                    child: Text(
                      "I understand and accept these terms.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _agreed
                      ? () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => widget.nextScreen),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    disabledBackgroundColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Accept & Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
