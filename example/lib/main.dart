import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blinking_border/blinking_border.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blinking Border Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BlinkStyle _selectedStyle = BlinkStyle.normal;
  StrokeStyle _strokeStyle = StrokeStyle.solid;
  Color _selectedColor = Colors.blue;
  double _strokeWidth = 3.0;
  double _animationSpeed = 2.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 8),
            Text('Code copied to clipboard!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _generateCode() {
    return '''BlinkingBorder(
  blinkStyle: BlinkStyle.${_selectedStyle.name},
  strokeStyle: StrokeStyle.${_strokeStyle.name},
  color: Color(0x${_selectedColor.value.toRadixString(16).toUpperCase()}),
  strokeWidth: $_strokeWidth,
  duration: Duration(seconds: ${_animationSpeed.toInt()}),
  borderRadius: BorderRadius.circular(16),
  child: YourWidget(),
)''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blinking Border Demo'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Playground', icon: Icon(Icons.brush)),
            Tab(text: 'Examples', icon: Icon(Icons.widgets)),
            Tab(text: 'Code', icon: Icon(Icons.code)),
            Tab(text: 'About', icon: Icon(Icons.info)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlayground(),
          _buildExamples(),
          _buildCodeView(),
          _buildAbout(),
        ],
      ),
    );
  }

  Widget _buildPlayground() {
    return Row(
      children: [
        // Controls Panel
        Container(
          width: 350,
          color: Theme.of(context).colorScheme.surface,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Animation Style'),
                ...BlinkStyle.values.map(
                  (style) => RadioListTile<BlinkStyle>(
                    title: Text(_getStyleName(style)),
                    subtitle: Text(_getStyleDescription(style)),
                    value: style,
                    groupValue: _selectedStyle,
                    onChanged: (value) {
                      setState(() {
                        _selectedStyle = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Stroke Style'),
                ...StrokeStyle.values.map(
                  (style) => RadioListTile<StrokeStyle>(
                    title: Text(style.name.toUpperCase()),
                    value: style,
                    groupValue: _strokeStyle,
                    onChanged: (value) {
                      setState(() {
                        _strokeStyle = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Color'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                            Colors.blue,
                            Colors.red,
                            Colors.green,
                            Colors.purple,
                            Colors.orange,
                            Colors.pink,
                            Colors.cyan,
                            Colors.amber,
                            Colors.teal,
                            Colors.indigo,
                            Colors.white,
                          ]
                          .map(
                            (color) => InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedColor = color;
                                });
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: color,
                                  border: _selectedColor == color
                                      ? Border.all(
                                          width: 3,
                                          color: Colors.black,
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _selectedColor == color
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          )
                          .toList(),
                ),

                const SizedBox(height: 24),
                _buildSectionTitle(
                  'Stroke Width: ${_strokeWidth.toStringAsFixed(1)}',
                ),
                Slider(
                  value: _strokeWidth,
                  min: 1,
                  max: 10,
                  divisions: 18,
                  label: _strokeWidth.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _strokeWidth = value;
                    });
                  },
                ),

                const SizedBox(height: 24),
                _buildSectionTitle(
                  'Animation Speed: ${_animationSpeed.toStringAsFixed(1)}s',
                ),
                Slider(
                  value: _animationSpeed,
                  min: 0.5,
                  max: 5,
                  divisions: 9,
                  label: '${_animationSpeed.toStringAsFixed(1)}s',
                  onChanged: (value) {
                    setState(() {
                      _animationSpeed = value;
                    });
                  },
                ),

                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _copyToClipboard(_generateCode()),
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Code'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Preview Area
        Expanded(
          child: Container(
            color: Colors.grey[900],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main Preview
                  BlinkingBorder(
                    key: ValueKey(
                      '$_selectedStyle-$_strokeStyle-$_selectedColor-$_strokeWidth-$_animationSpeed',
                    ),
                    blinkStyle: _selectedStyle,
                    strokeStyle: _strokeStyle,
                    color: _selectedColor,
                    strokeWidth: _strokeWidth,
                    duration: Duration(
                      milliseconds: (_animationSpeed * 1000).toInt(),
                    ),
                    borderRadius: BorderRadius.circular(16),
                    dashWidth: 10,
                    dashSpace: 5,
                    dotRadius: 4,
                    dotSpace: 8,
                    pulseScale: 0.08,
                    child: Container(
                      width: 400,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 64,
                            color: _selectedColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Live Preview',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_getStyleName(_selectedStyle)} + ${_strokeStyle.name}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Multiple previews
                  Text(
                    'Different Shapes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Circle
                      BlinkingBorder(
                        blinkStyle: _selectedStyle,
                        strokeStyle: _strokeStyle,
                        color: _selectedColor,
                        strokeWidth: _strokeWidth,
                        duration: Duration(
                          milliseconds: (_animationSpeed * 1000).toInt(),
                        ),
                        borderRadius: BorderRadius.circular(60),
                        pulseScale: 0.08,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.circle, size: 48),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Rectangle
                      BlinkingBorder(
                        blinkStyle: _selectedStyle,
                        strokeStyle: _strokeStyle,
                        color: _selectedColor,
                        strokeWidth: _strokeWidth,
                        duration: Duration(
                          milliseconds: (_animationSpeed * 1000).toInt(),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        pulseScale: 0.08,
                        child: Container(
                          width: 150,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.rectangle, size: 48),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Rounded
                      BlinkingBorder(
                        blinkStyle: _selectedStyle,
                        strokeStyle: _strokeStyle,
                        color: _selectedColor,
                        strokeWidth: _strokeWidth,
                        duration: Duration(
                          milliseconds: (_animationSpeed * 1000).toInt(),
                        ),
                        borderRadius: BorderRadius.circular(24),
                        pulseScale: 0.08,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(Icons.rounded_corner, size: 48),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExamples() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Wrap(
          spacing: 25,
          runSpacing: 25,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            BlinkingBorder(
              blinkStyle: BlinkStyle.cornerSweep,
              strokeStyle: StrokeStyle.solid,
              strokeWidth: 4,
              color: Colors.purple,
              borderRadius: BorderRadius.circular(16),
              duration: const Duration(seconds: 3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 175,
                  width: 265,
                  color: Colors.purple.withValues(alpha: 0.1),
                  child: Center(
                    child: Image.network(
                      'https://media.istockphoto.com/id/465979052/fi/valokuva/kaunis-maisema-skotlannin-luonnosta.jpg?s=2048x2048&w=is&k=20&c=Za0tY4ntLUyxuwGeYj4IMNKluPRpihNUjm4l2Nqpjow=',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),

            // Example 2: Card with Dotted Border
            BlinkingBorder(
              blinkStyle: BlinkStyle.normal,
              strokeStyle: StrokeStyle.dotted,
              strokeWidth: 2,
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
              dotRadius: 3,
              dotSpace: 6,
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 20,
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.check_circle, size: 50, color: Colors.green),
                      SizedBox(height: 10),
                      Text(
                        'Success!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Task completed successfully'),
                    ],
                  ),
                ),
              ),
            ),

            // Example 3: Button with Dashed Border
            BlinkingBorder(
              blinkStyle: BlinkStyle.normal,
              strokeStyle: StrokeStyle.dashed,
              strokeWidth: 2,
              color: Colors.orange,
              borderRadius: BorderRadius.circular(30),
              dashWidth: 8,
              dashSpace: 4,
              duration: const Duration(seconds: 1),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Click Me!', style: TextStyle(fontSize: 18)),
              ),
            ),

            BlinkingBorder(
              blinkStyle: BlinkStyle.rainbow,
              strokeStyle: StrokeStyle.solid,
              strokeWidth: 4,
              borderRadius: BorderRadius.circular(20),
              duration: const Duration(seconds: 3),
              child: Container(
                width: 275,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.palette, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Rainbow Border',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Cycles through all colors'),
                  ],
                ),
              ),
            ),

            // Example 5: Pulsing Border with Scale
            Center(
              child: BlinkingBorder(
                blinkStyle: BlinkStyle.pulsing,
                strokeStyle: StrokeStyle.solid,
                strokeWidth: 3,
                color: Colors.red,
                borderRadius: BorderRadius.circular(100),
                duration: const Duration(milliseconds: 1500),
                pulseScale: 0.08,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withValues(alpha: 0.1),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 60,
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            // Example 6: Glowing Border
            BlinkingBorder(
              blinkStyle: BlinkStyle.glowing,
              strokeStyle: StrokeStyle.solid,
              strokeWidth: 2,
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(16),
              duration: const Duration(seconds: 2),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 50, color: Colors.cyan),
                    SizedBox(height: 10),
                    Text(
                      'Glowing Effect',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    ),
                    Text(
                      'Soft light emanation',
                      style: TextStyle(color: Colors.cyan.shade200),
                    ),
                  ],
                ),
              ),
            ),

            // Example 7: Normal
            BlinkingBorder(
              blinkStyle: BlinkStyle.normal,
              strokeStyle: StrokeStyle.solid,
              strokeWidth: 3,
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
              duration: const Duration(seconds: 3),
              child: Container(
                width: 225,
                height: 140,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Normal Blinking',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            // Example 7: Game Achievement
            Center(
              child: BlinkingBorder(
                blinkStyle: BlinkStyle.rainbow,
                strokeWidth: 5.0,
                strokeStyle: StrokeStyle.solid,
                borderRadius: BorderRadius.circular(16),
                duration: Duration(seconds: 3),
                child: Container(
                  width: 280,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Colors.amber[300]!, Colors.orange[600]!],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.emoji_events, color: Colors.white, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'LEGENDARY!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        'Achievement Unlocked',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Example 8: Multiple Borders in a Row
            for (final color in [Colors.red, Colors.blue, Colors.green])
              BlinkingBorder(
                blinkStyle: BlinkStyle.cornerSweep,
                strokeStyle: StrokeStyle.solid,
                strokeWidth: 3,
                color: color,
                borderRadius: BorderRadius.circular(10),
                duration: const Duration(seconds: 2),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.star, color: color, size: 40),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeView() {
    final code = _generateCode();
    return Center(
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Generated Code',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: SelectableText(
                code,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _copyToClipboard(code),
              icon: const Icon(Icons.copy),
              label: const Text('Copy to Clipboard'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbout() {
    return Center(
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              'Blinking Border',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.2.0',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'A beautiful Flutter package for animated borders',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _launchUrl('https://pub.dev/packages/blinking_border');
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('View on pub.dev'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    _launchUrl(
                      'https://github.com/Jamalianpour/blinking_border',
                    );
                  },
                  icon: const Icon(Icons.code),
                  label: const Text('GitHub Repository'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    _launchUrl(
                      'https://github.com/Jamalianpour/blinking_border/issues',
                    );
                  },
                  icon: const Icon(Icons.bug_report),
                  label: const Text('Report Issue'),
                ),
              ],
            ),
            const SizedBox(height: 48),
            const Text('Made with ❤️ by the Flutter Community'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  String _getStyleName(BlinkStyle style) {
    switch (style) {
      case BlinkStyle.normal:
        return 'Normal';
      case BlinkStyle.cornerSweep:
        return 'Corner Sweep';
      case BlinkStyle.rainbow:
        return 'Rainbow';
      case BlinkStyle.pulsing:
        return 'Pulsing';
      case BlinkStyle.glowing:
        return 'Glowing';
    }
  }

  String _getStyleDescription(BlinkStyle style) {
    switch (style) {
      case BlinkStyle.normal:
        return 'Smooth fade in/out';
      case BlinkStyle.cornerSweep:
        return 'Traveling light effect';
      case BlinkStyle.rainbow:
        return 'Color spectrum animation';
      case BlinkStyle.pulsing:
        return 'Scale with heartbeat';
      case BlinkStyle.glowing:
        return 'Neon light emanation';
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank')) {
      throw Exception('Could not launch $url');
    }
  }
}
