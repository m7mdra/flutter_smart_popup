import 'package:flutter/material.dart';
import 'package:flutter_smart_popup/flutter_smart_popup.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final popupKey = GlobalKey<SmartPopupState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          title: const Text('example'),
          actions: [
            // example0 menu
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: SmartPopup(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) => Text('menu$index')),
                ),
                child: const Icon(Icons.add_circle_outline),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.blue[50],
              child: Column(
                children: [
                  Text('Result Propagation Example'),
                  SizedBox(height: 10),
                  SmartPopup<String>(
                    content: _MenuWithResult(),
                    onResult: (result) {
                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Selected: $result')),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Tap for menu with result',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // example6 - Blur effect
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.purple[50],
              child: Column(
                children: [
                  Text('Blur Effect Examples'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SmartPopup(
                        enableBlur: true,
                        blurSigma: 1.0,
                        content: Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Light Blur\n(sigma: 3.0)',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Very Light Blur',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                      SmartPopup(
                        enableBlur: true,
                        blurSigma: 3.0,
                        content: Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Light Blur\n(sigma: 3.0)',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Light Blur',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                      SmartPopup(
                        enableBlur: true,
                        blurSigma: 8.0,
                        barrierColor: Colors.black.withValues(alpha: 0.2),
                        content: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.blur_on,
                                  size: 40, color: Colors.purple),
                              SizedBox(height: 10),
                              Text(
                                'Heavy Blur\n(sigma: 8.0)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Heavy Blur',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tap the buttons above to see different blur effects.\nTap outside any popup to test barrier dismissal.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // ...existing code...
          ],
        ),
      ),
    );
  }
}

class _Slider extends StatefulWidget {
  const _Slider();

  @override
  State<_Slider> createState() => __SliderState();
}

class __SliderState extends State<_Slider> {
  double progress = 0.5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 100,
      child: Column(
        children: [
          Slider(
            value: progress,
            onChanged: (value) {
              setState(() => progress = value);
            },
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, progress);
            },
            child: Text('Done'),
          )
        ],
      ),
    );
  }
}

class _MenuWithResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text('Option A'),
          onTap: () => Navigator.pop<String>(context, 'Option A'),
        ),
        ListTile(
          title: Text('Option B'),
          onTap: () => Navigator.pop<String>(context, 'Option B'),
        ),
        ListTile(
          title: Text('Option C'),
          onTap: () => Navigator.pop<String>(context, 'Option C'),
        ),
        ListTile(
          title: Text('Cancel'),
          textColor: Colors.red,
          onTap: () => Navigator.pop<String>(context, null),
        ),
      ],
    );
  }
}

class _NumberPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Select a Number',
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => ListTile(
                title: Text('Number ${index + 1}'),
                onTap: () => Navigator.pop(context, index + 1),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
