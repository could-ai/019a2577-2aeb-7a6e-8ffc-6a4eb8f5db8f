import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KX-BOT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00E1FF),
        scaffoldBackgroundColor: const Color(0xFF010409),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFC9D1D9)),
          bodyMedium: TextStyle(color: Color(0xFFC9D1D9)),
        ),
        fontFamily: 'RobotoMono',
      ),
      home: const KxBotHomeScreen(),
    );
  }
}

class KxBotHomeScreen extends StatefulWidget {
  const KxBotHomeScreen({super.key});

  @override
  State<KxBotHomeScreen> createState() => _KxBotHomeScreenState();
}

class _KxBotHomeScreenState extends State<KxBotHomeScreen> {
  String _mode = ''; // 'desktop' or 'mobile'

  void _setInterfaceMode(String mode) {
    setState(() {
      _mode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (_mode.isEmpty) {
      return ModeSelectionScreen(onModeSelected: _setInterfaceMode);
    }
    return HudScreen(mode: _mode);
  }
}

class ModeSelectionScreen extends StatelessWidget {
  final Function(String) onModeSelected;

  const ModeSelectionScreen({super.key, required this.onModeSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: const Color(0x990A192F),
            border: Border.all(color: const Color(0x660096C8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SELECT INTERFACE MODE',
                style: TextStyle(
                  color: Color(0xFF00E1FF),
                  fontFamily: 'Orbitron',
                  fontSize: 24,
                  shadows: [
                    Shadow(blurRadius: 8, color: Color(0xB300E1FF)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => onModeSelected('desktop'),
                    style: _buttonStyle(),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: Text('Desktop Interface'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => onModeSelected('mobile'),
                    style: _buttonStyle(),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: Text('Mobile Interface'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: const Color(0xFF00E1FF),
      side: const BorderSide(color: Color(0xFF00E1FF)),
      shape: const BeveledRectangleBorder(),
    );
  }
}

class HudScreen extends StatefulWidget {
  final String mode;
  const HudScreen({super.key, required this.mode});

  @override
  State<HudScreen> createState() => _HudScreenState();
}

class _HudScreenState extends State<HudScreen> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = widget.mode == 'desktop';
    final containerSize = isDesktop
        ? const Size(1200, 800)
        : Size(MediaQuery.of(context).size.width * 0.9,
            MediaQuery.of(context).size.height * 0.9);

    return Scaffold(
      body: Center(
        child: Container(
          width: containerSize.width,
          height: containerSize.height,
          decoration: BoxDecoration(
            border: Border.all(
                color: const Color(0xFF222222), width: isDesktop ? 10 : 15),
            borderRadius: BorderRadius.circular(isDesktop ? 5 : 40),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 50,
                spreadRadius: 0,
              )
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.transparent,
      child: Column(
        children: [
          const Expanded(flex: 1, child: HeaderPanel()),
          const SizedBox(height: 10),
          Expanded(
            flex: 8,
            child: Row(
              children: [
                const Expanded(flex: 2, child: LeftPanel()),
                const SizedBox(width: 10),
                const Expanded(flex: 6, child: MainPanel()),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: RightPanel()),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Expanded(flex: 1, child: FooterPanel()),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.transparent,
      child: Column(
        children: [
          const Expanded(flex: 1, child: HeaderPanel()),
          const SizedBox(height: 10),
          const Expanded(flex: 8, child: MainPanel()),
          const SizedBox(height: 10),
          const Expanded(flex: 1, child: FooterPanel()),
        ],
      ),
    );
  }
}

class HudPanel extends StatelessWidget {
  final Widget child;
  const HudPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xE60A192F),
        border: Border.all(color: const Color(0x660096C8)),
      ),
      child: child,
    );
  }
}

class HeaderPanel extends StatefulWidget {
  const HeaderPanel({super.key});

  @override
  State<HeaderPanel> createState() => _HeaderPanelState();
}

class _HeaderPanelState extends State<HeaderPanel> {
  String _time = '';
  String _date = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _time =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      _date =
          '${now.weekday}, ${now.day} ${now.month} ${now.year}'; // Simplified date
    });
  }

  @override
  Widget build(BuildContext context) {
    return HudPanel(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'KX-BOT',
            style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 24,
                color: Color(0xFF00E1FF)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_date,
                  style: const TextStyle(fontSize: 12, color: Colors.white70)),
              Text(_time,
                  style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 22,
                      color: Color(0xFF00E1FF))),
            ],
          ),
        ],
      ),
    );
  }
}

class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return HudPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WidgetTitle(title: '// APPS'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.settings, size: 30, color: Color(0xFFC9D1D9)),
              Icon(Icons.network_wifi, size: 30, color: Color(0xFFC9D1D9)),
              Icon(Icons.memory, size: 30, color: Color(0xFFC9D1D9)),
            ],
          ),
          const SizedBox(height: 20),
          const WidgetTitle(title: '// ACTIVE SCAN'),
          // Placeholder for Radar Scanner
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00E1FF), width: 1),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const WidgetTitle(title: '// STATUS'),
          const Center(
              child: Text('AWAITING COMMAND',
                  style: TextStyle(color: Color(0xFF00E1FF)))),
        ],
      ),
    );
  }
}

class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return HudPanel(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: WidgetTitle(title: '// COMMUNICATION LOG'),
          ),
          const Divider(color: Color(0x660096C8)),
          // Chat history placeholder
          Expanded(
            child: ListView(
              children: const [
                MessageBubble(
                    text: 'ನಮಸ್ಕಾರ! ನಾನು KX-BOT. ನಿಮಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡಲಿ?',
                    isUser: false),
              ],
            ),
          ),
          const Divider(color: Color(0x660096C8)),
          // Input area
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Awaiting command...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Color(0x660096C8)),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Color(0x660096C8)),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Color(0xFF00E1FF)),
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF00E1FF)),
                  onPressed: () {
                    // Handle send
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Color(0xFF00E1FF)),
                  onPressed: () {
                    // Handle voice input
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RightPanel extends StatelessWidget {
  const RightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const HudPanel(
      child: Center(
        child: TalkingAvatar(),
      ),
    );
  }
}

class FooterPanel extends StatelessWidget {
  const FooterPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const HudPanel(
      child: Center(
        child: Text(
          'KX CODER SOFTWARE COMPANY // ALL SYSTEMS OPERATIONAL',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

class WidgetTitle extends StatelessWidget {
  final String title;
  const WidgetTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Orbitron',
          color: Color(0xFF00E1FF),
          fontSize: 14,
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser
              ? const Color(0xFF00E1FF).withOpacity(0.2)
              : Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text),
      ),
    );
  }
}

class TalkingAvatar extends StatelessWidget {
  const TalkingAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for the SVG talking avatar.
    // A full implementation would require an SVG library and animations.
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFF00FF), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFFF00FF),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.android,
          size: 80,
          color: Color(0xFFFF00FF),
        ),
      ),
    );
  }
}
