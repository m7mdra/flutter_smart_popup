# flutter_smart_popup
A smart and versatile popup library for Flutter with intelligent positioning, customizable styling, result propagation, and beautiful blur effects. Features automatic positioning, smooth animations, and contextual guidance.

## Getting Started



https://github.com/user-attachments/assets/dcc61892-3eb0-4cbc-a333-a00785fc74a2


## How to use
```
dependencies:
  flutter_smart_popup: ^1.0.0
```

```
import 'package:flutter_smart_popup/flutter_smart_popup.dart';
```
```dart
// easy to use
SmartPopup(
  content: Text('George says everything looks fine'),
  child: Icon(Icons.help),
),

SmartPopup(
  arrowColor: Colors.orange,
  barrierColor: Colors.green.withOpacity(0.1),
  backgroundColor: Colors.white,
  content: Text('George says everything looks fine'),
  child: Icon(Icons.help),
),

SmartPopup(
  content: _Slider(),
  position: PopupPosition.top,
  child:Text('slider'),
)

SmartPopup(
  content: Column(
  mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (index) => Text('menu$index')),
  ),
  child: const Icon(Icons.add_circle_outline),
)

Container(
  decoration: BoxDecoration(color: Colors.white),
  padding: EdgeInsets.symmetric(vertical: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      SmartPopup(
      showArrow: false,
      contentPadding:EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      barrierColor: Colors.transparent,
      contentDecoration: BoxDecoration(color: Colors.white),
      content: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(4,(index) => Text('item$index'),),),),
            child: Text('filter1'),
          ),
              Text('filter2'),
              Text('filter3'),
        ],
  ),
)

// Show the popup programmatically
final popupKey = GlobalKey<SmartPopupState>();
// ...
SmartPopup(
  key: popupKey,
  content: Text('George says everything looks fine'),
  child: Icon(Icons.help),
);
// ...
popupKey.currentState?.show();
```


## Result Propagation

The popup now supports result propagation similar to Navigator API:

```dart
// Using onResult callback
SmartPopup<String>(
  content: MenuWidget(),
  onResult: (result) {
    if (result != null) {
      print('User selected: $result');
    }
  },
  child: Icon(Icons.menu),
)

// Using Future returned by show() method  
final popupKey = GlobalKey<SmartPopupState<String>>();
// ...
final result = await popupKey.currentState?.show();
if (result != null) {
  print('Selected: $result');
}

// Close popup with result from inside popup content
Navigator.pop<String>(context, 'selected_value');
```


## Blur/Backdrop Effects

Enable beautiful blur effects behind your popups while maintaining full touch interaction:

```dart
SmartPopup(
  enableBlur: true,
  blurSigma: 5.0,  // Controls blur intensity (default: 5.0)
  content: Text('Content with blur backdrop'),
  child: Icon(Icons.blur_on),
)

// Light blur effect
SmartPopup(
  enableBlur: true,
  blurSigma: 3.0,
  content: YourContent(),
  child: YourTrigger(),
)

// Heavy blur effect  
SmartPopup(
  enableBlur: true,
  blurSigma: 10.0,
  barrierColor: Colors.black.withValues(alpha: 0.3),
  content: YourContent(),
  child: YourTrigger(),
)
```

**Note**: Barrier dismissal (tap outside to close) works perfectly with blur effects enabled.

