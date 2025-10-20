import 'package:flutter/material.dart';

class RebuildDebugProbe extends StatefulWidget {
  const RebuildDebugProbe({super.key, required this.child});
  final Widget child;

  @override
  State<RebuildDebugProbe> createState() => _RebuildDebugProbeState();
}

class _RebuildDebugProbeState extends State<RebuildDebugProbe> with WidgetsBindingObserver {
  MediaQueryData? _lastMQ;
  ThemeData? _lastTheme;
  Locale? _lastLocale;
  Brightness? _lastBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    debugPrint('[Probe] didChangeMetrics (window size/insets changed)');
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    debugPrint('[Probe] didChangeLocales: $locales');
  }

  @override
  void didChangePlatformBrightness() {
    final b = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    debugPrint('[Probe] didChangePlatformBrightness: $b');
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final theme = Theme.of(context);
    final locale = Localizations.maybeLocaleOf(context);
    final brightness = MediaQuery.maybePlatformBrightnessOf(context);

    if (_lastMQ != null && mq != null) {
      if (_lastMQ!.size != mq.size) {
        debugPrint('[Probe] MediaQuery.size changed: ${_lastMQ!.size} -> ${mq.size}');
      }
      if (_lastMQ!.padding != mq.padding) {
        debugPrint('[Probe] MediaQuery.padding changed: ${_lastMQ!.padding} -> ${mq.padding}');
      }
      if (_lastMQ!.viewInsets != mq.viewInsets) {
        debugPrint('[Probe] MediaQuery.viewInsets changed: ${_lastMQ!.viewInsets} -> ${mq.viewInsets}');
      }
      if (_lastMQ!.viewPadding != mq.viewPadding) {
        debugPrint('[Probe] MediaQuery.viewPadding changed: ${_lastMQ!.viewPadding} -> ${mq.viewPadding}');
      }
    }

    if (_lastTheme != null && _lastTheme!.brightness != theme.brightness) {
      debugPrint('[Probe] Theme.brightness changed: ${_lastTheme!.brightness} -> ${theme.brightness}');
    }

    if (_lastLocale != null && _lastLocale != locale) {
      debugPrint('[Probe] Locale changed: $_lastLocale -> $locale');
    }

    if (_lastBrightness != null && _lastBrightness != brightness) {
      debugPrint('[Probe] PlatformBrightness changed: $_lastBrightness -> $brightness');
    }

    _lastMQ = mq;
    _lastTheme = theme;
    _lastLocale = locale;
    _lastBrightness = brightness;

    return widget.child;
  }
}
