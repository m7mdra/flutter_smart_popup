part of flutter_smart_popup;

/// Utility class to help close popups with results
class PopupNavigator {
  /// Close the current popup with an optional result
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  /// Check if there's a popup that can be popped
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }
}

enum _ArrowDirection { top, bottom }

enum PopupPosition { auto, top, bottom }

class SmartPopup<T> extends StatefulWidget {
  final GlobalKey? anchorKey;
  final Widget content;
  final Widget child;
  final bool isLongPress;
  final Color? backgroundColor;
  final Color? arrowColor;
  final Color? barrierColor;
  final bool showArrow;
  final EdgeInsets contentPadding;
  final double? contentRadius;
  final BoxDecoration? contentDecoration;
  final VoidCallback? onBeforePopup;
  final VoidCallback? onAfterPopup;
  final ValueChanged<T?>? onResult;
  final bool rootNavigator;
  final PopupPosition position;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool enableBlur;
  final double blurSigma;

  const SmartPopup({
    super.key,
    required this.content,
    required this.child,
    this.anchorKey,
    this.isLongPress = false,
    this.backgroundColor,
    this.arrowColor,
    this.showArrow = true,
    this.barrierColor,
    this.contentPadding = const EdgeInsets.all(8),
    this.contentRadius,
    this.contentDecoration,
    this.onBeforePopup,
    this.onAfterPopup,
    this.onResult,
    this.rootNavigator = false,
    this.position = PopupPosition.auto,
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
    this.enableBlur = false,
    this.blurSigma = 5.0,
  });

  @override
  State<SmartPopup<T>> createState() => SmartPopupState<T>();
}

class SmartPopupState<T> extends State<SmartPopup<T>> {
  Future<T?> show() async {
    final anchor = widget.anchorKey?.currentContext ?? context;
    final renderBox = anchor.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    final offset = renderBox.localToGlobal(renderBox.paintBounds.topLeft);

    widget.onBeforePopup?.call();

    final result =
        await Navigator.of(context, rootNavigator: widget.rootNavigator)
            .push<T>(
      _PopupRoute<T>(
        targetRect: offset & renderBox.paintBounds.size,
        backgroundColor: widget.backgroundColor,
        arrowColor: widget.arrowColor,
        showArrow: widget.showArrow,
        barriersColor: widget.barrierColor,
        contentPadding: widget.contentPadding,
        contentRadius: widget.contentRadius,
        contentDecoration: widget.contentDecoration,
        position: widget.position,
        animationDuration: widget.animationDuration,
        animationCurve: widget.animationCurve,
        enableBlur: widget.enableBlur,
        blurSigma: widget.blurSigma,
        child: widget.content,
      ),
    );

    widget.onAfterPopup?.call();
    widget.onResult?.call(result);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: widget.isLongPress ? () => show() : null,
      onTapUp: !widget.isLongPress ? (_) => show() : null,
      child: widget.child,
    );
  }
}

class _PopupContent extends StatelessWidget {
  final Widget child;
  final GlobalKey childKey;
  final GlobalKey arrowKey;
  final _ArrowDirection arrowDirection;
  final double arrowHorizontal;
  final Color? backgroundColor;
  final Color? arrowColor;
  final bool showArrow;
  final EdgeInsets contentPadding;
  final double? contentRadius;
  final BoxDecoration? contentDecoration;

  const _PopupContent({
    Key? key,
    required this.child,
    required this.childKey,
    required this.arrowKey,
    required this.arrowHorizontal,
    required this.showArrow,
    this.arrowDirection = _ArrowDirection.top,
    this.backgroundColor,
    this.arrowColor,
    this.contentRadius,
    required this.contentPadding,
    this.contentDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          key: childKey,
          padding: contentPadding,
          margin: const EdgeInsets.symmetric(vertical: 10).copyWith(
            top: arrowDirection == _ArrowDirection.bottom ? 0 : null,
            bottom: arrowDirection == _ArrowDirection.top ? 0 : null,
          ),
          constraints: const BoxConstraints(minWidth: 50),
          decoration: contentDecoration ??
              BoxDecoration(
                color: backgroundColor ?? Colors.white,
                borderRadius: BorderRadius.circular(contentRadius ?? 10),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
          child: child,
        ),
        Positioned(
          top: arrowDirection == _ArrowDirection.top ? 2 : null,
          bottom: arrowDirection == _ArrowDirection.bottom ? 2 : null,
          left: arrowHorizontal,
          child: RotatedBox(
            key: arrowKey,
            quarterTurns: arrowDirection == _ArrowDirection.top ? 2 : 4,
            child: CustomPaint(
              size: showArrow ? const Size(16, 8) : Size.zero,
              painter: _TrianglePainter(color: arrowColor ?? Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final path = Path();
    paint.isAntiAlias = true;
    paint.color = color;

    path.lineTo(size.width * 0.66, size.height * 0.86);
    path.cubicTo(size.width * 0.58, size.height * 1.05, size.width * 0.42,
        size.height * 1.05, size.width * 0.34, size.height * 0.86);
    path.cubicTo(size.width * 0.34, size.height * 0.86, 0, 0, 0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width * 0.66, size.height * 0.86,
        size.width * 0.66, size.height * 0.86);
    path.cubicTo(size.width * 0.66, size.height * 0.86, size.width * 0.66,
        size.height * 0.86, size.width * 0.66, size.height * 0.86);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _PopupRoute<T> extends PopupRoute<T> {
  final Rect targetRect;
  final PopupPosition position;
  final Widget child;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool enableBlur;
  final double blurSigma;

  static const double _margin = 10;
  static final Rect _viewportRect = Rect.fromLTWH(
    _margin,
    Screen.statusBar + _margin,
    Screen.width - _margin * 2,
    Screen.height - Screen.statusBar - Screen.bottomBar - _margin * 2,
  );

  final GlobalKey _childKey = GlobalKey();
  final GlobalKey _arrowKey = GlobalKey();
  final Color? backgroundColor;
  final Color? arrowColor;
  final bool showArrow;
  final Color? barriersColor;
  final EdgeInsets contentPadding;
  final double? contentRadius;
  final BoxDecoration? contentDecoration;

  double _maxHeight = _viewportRect.height;
  _ArrowDirection _arrowDirection = _ArrowDirection.top;
  double _arrowHorizontal = 0;
  double _scaleAlignDx = 0.5;
  double _scaleAlignDy = 0.5;
  double? _bottom;
  double? _top;
  double? _left;
  double? _right;

  _PopupRoute({
    RouteSettings? settings,
    ImageFilter? filter,
    TraversalEdgeBehavior? traversalEdgeBehavior,
    required this.child,
    required this.targetRect,
    this.backgroundColor,
    this.arrowColor,
    required this.showArrow,
    this.barriersColor,
    required this.contentPadding,
    this.contentRadius,
    this.contentDecoration,
    this.position = PopupPosition.auto,
    required this.animationDuration,
    this.animationCurve = Curves.easeInOut,
    this.enableBlur = false,
    this.blurSigma = 5.0,
  }) : super(
          settings: settings,
          filter: filter,
          traversalEdgeBehavior: traversalEdgeBehavior,
        );

  @override
  // ignore: deprecated_member_use
  Color? get barrierColor => barriersColor ?? Colors.black.withOpacity(0.1);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Popup';

  @override
  TickerFuture didPush() {
    super.offstage = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final childRect = _getRect(_childKey);
      final arrowRect = _getRect(_arrowKey);
      _calculateArrowOffset(arrowRect, childRect);
      _calculateChildOffset(childRect);
      super.offstage = false;
    });
    return super.didPush();
  }

  Rect? _getRect(GlobalKey key) {
    final currentContext = key.currentContext;
    final renderBox = currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || currentContext == null) return null;
    final offset = renderBox.localToGlobal(renderBox.paintBounds.topLeft);
    var rect = offset & renderBox.paintBounds.size;

    if (Directionality.of(currentContext) == TextDirection.rtl) {
      rect = Rect.fromLTRB(0, rect.top, rect.right - rect.left, rect.bottom);
    }

    return rect;
  }

  // Calculate the horizontal position of the arrow
  void _calculateArrowOffset(Rect? arrowRect, Rect? childRect) {
    if (childRect == null || arrowRect == null) return;
    // Calculate the distance from the left side of the screen based on the middle position of the target and the popover layer
    var leftEdge = targetRect.center.dx - childRect.center.dx;
    final rightEdge = leftEdge + childRect.width;
    leftEdge = leftEdge < _viewportRect.left ? _viewportRect.left : leftEdge;
    // If it exceeds the screen, subtract the excess part
    if (rightEdge > _viewportRect.right) {
      leftEdge -= rightEdge - _viewportRect.right;
    }
    final center = targetRect.center.dx - leftEdge - arrowRect.center.dx;
    // Prevent the arrow from extending beyond the padding of the popover
    if (center + arrowRect.center.dx > childRect.width - 15) {
      _arrowHorizontal = center - 15;
    } else if (center < 15) {
      _arrowHorizontal = 15;
    } else {
      _arrowHorizontal = center;
    }

    _scaleAlignDx = (_arrowHorizontal + arrowRect.center.dx) / childRect.width;
  }

  // Calculate the position of the popover
  void _calculateChildOffset(Rect? childRect) {
    if (childRect == null) return;

    final topHeight = targetRect.top - _viewportRect.top;
    final bottomHeight = _viewportRect.bottom - targetRect.bottom;
    final maximum = max(topHeight, bottomHeight);
    _maxHeight = childRect.height > maximum ? maximum : childRect.height;

    if (position == PopupPosition.top ||
        (position == PopupPosition.auto && _maxHeight > bottomHeight)) {
      _bottom = Screen.height - targetRect.top;
      _arrowDirection = _ArrowDirection.bottom;
      _scaleAlignDy = 1;
    } else {
      _top = targetRect.bottom;
      _arrowDirection = _ArrowDirection.top;
      _scaleAlignDy = 0;
    }

    final left = targetRect.center.dx - childRect.center.dx;
    final right = left + childRect.width;
    if (right > _viewportRect.right) {
      _right = _margin;
    } else {
      _left = left < _margin ? _margin : left;
    }
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return child;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    child = _PopupContent(
      childKey: _childKey,
      arrowKey: _arrowKey,
      arrowHorizontal: _arrowHorizontal,
      arrowDirection: _arrowDirection,
      backgroundColor: backgroundColor,
      arrowColor: arrowColor,
      showArrow: showArrow,
      contentPadding: contentPadding,
      contentRadius: contentRadius,
      contentDecoration: contentDecoration,
      child: child,
    );
    if (!animation.isCompleted) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: animationCurve,
      );
      child = FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          alignment: FractionalOffset(_scaleAlignDx, _scaleAlignDy),
          scale: curvedAnimation,
          child: child,
        ),
      );
    }
    return Stack(
      children: [
        // Blur backdrop layer
        if (enableBlur)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurSigma * animation.value,
                      sigmaY: blurSigma * animation.value,
                    ),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  );
                },
              ),
            ),
          ),
        // Popup content
        Positioned(
          left: _left,
          right: _right,
          top: _top,
          bottom: _bottom,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _viewportRect.width,
              maxHeight: _maxHeight,
            ),
            child: Material(
              color: Colors.transparent,
              type: MaterialType.transparency,
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Duration get transitionDuration => animationDuration;
}
