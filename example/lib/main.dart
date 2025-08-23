import 'package:flutter/material.dart';
import 'package:blinking_border/blinking_border.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blinking Border Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  BlinkStyle _blinkStyle = BlinkStyle.normal;
  StrokeStyle _strokeStyle = StrokeStyle.solid;
  double _strokeWidth = 3.0;
  Color _borderColor = Colors.blue;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Blinking Border Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Controls Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configuration',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Blink Style Selector
                    const Text('Blink Style:'),
                    Wrap(
                      children: [
                        for (final style in BlinkStyle.values)
                          Padding(
                            padding: const EdgeInsets.only(right: 8, bottom: 8),
                            child: ChoiceChip(
                              label: Text(_getStyleName(style)),
                              selected: _blinkStyle == style,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _blinkStyle = style;
                                  });
                                }
                              },
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Stroke Style Selector
                    const Text('Stroke Style:'),
                    Wrap(
                      children: [
                        for (final style in StrokeStyle.values)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(style.name),
                              selected: _strokeStyle == style,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _strokeStyle = style;
                                  });
                                }
                              },
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Stroke Width Slider
                    Text('Stroke Width: ${_strokeWidth.toStringAsFixed(1)}'),
                    Slider(
                      value: _strokeWidth,
                      min: 1,
                      max: 10,
                      onChanged: (value) {
                        setState(() {
                          _strokeWidth = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Color Selector
                    const Text('Border Color:'),
                    Wrap(
                      children: [
                        for (final color in [
                          Colors.blue,
                          Colors.red,
                          Colors.green,
                          Colors.purple,
                          Colors.orange,
                          Colors.pink,
                        ])
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _borderColor = color;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  border: _borderColor == color
                                      ? Border.all(
                                          width: 3,
                                          color: Colors.black,
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Live Preview
            Center(
              child: BlinkingBorder(
                blinkStyle: _blinkStyle,
                strokeStyle: _strokeStyle,
                strokeWidth: _strokeWidth,
                color: _borderColor,
                borderRadius: BorderRadius.circular(20),
                duration: const Duration(seconds: 2),
                child: Container(
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Live Preview',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              'More Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Example 1: Image with Corner Sweep
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
                      // width: 275,
                      color: Colors.purple.withOpacity(0.1),
                      child: Center(
                        child: Image.network(
                          'https://media.istockphoto.com/id/465979052/fi/valokuva/kaunis-maisema-skotlannin-luonnosta.jpg?s=2048x2048&w=is&k=20&c=Za0tY4ntLUyxuwGeYj4IMNKluPRpihNUjm4l2Nqpjow=',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 30),

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
                          Icon(
                            Icons.check_circle,
                            size: 50,
                            color: Colors.green,
                          ),
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

                const SizedBox(width: 30),

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
                    child: const Text(
                      'Click Me!',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Example 4: Rainbow Border
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
                          color: Colors.black.withOpacity(0.1),
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

                const SizedBox(width: 30),

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
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 30),

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

                const SizedBox(width: 30),

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
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

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
                        color: Colors.orange.withOpacity(0.3),
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

            const SizedBox(height: 50),

            // Example 8: Multiple Borders in a Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.star, color: color, size: 40),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
