# flutter_smart_popup
A smart and versatile popup library for Flutter with intelligent positioning, customizable styling, result propagation, and beautiful blur effects. Features automatic positioning, smooth animations, and contextual guidance.

## Getting Started

<img width="342" alt="image" src="https://github.com/herowws/flutter_popup/assets/41428542/98c3d15e-323a-491e-a4e2-e7778c6330c7">
<img width="342" alt="image" src="https://github.com/herowws/flutter_popup/assets/41428542/c49daa76-de18-41df-806f-a734cd75b7a4">
<img width="342" alt="image" src="https://github.com/herowws/flutter_popup/assets/41428542/465dbd7c-7088-4b76-a2cc-83436c12dec6">
<img width="342" alt="image" src="https://github.com/herowws/flutter_popup/assets/41428542/c1ab417a-30b6-4f99-97c9-fbca4ccc697c">


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
PopupNavigator.pop<String>(context, 'selected_value');
```


## Migration Guide

### From `flutter_popup` to `flutter_smart_popup`

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


## last
<p>Our full-stack freelance team is opening to new projects</p>
<p>If you have any questions about Flutter, or if you need me to customize a Flutter application for you, please feel free to contact me:
QQ: 965471570 Gmail: herowws90@gmail.com</p>
<p>如果您有任何关于Flutter的问题，或者需要我为您定制一个Flutter应用程序，请联系我: QQ:965471570  Gmail:herowws90@gmail.com</p>
