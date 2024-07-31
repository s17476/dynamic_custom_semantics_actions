import 'package:dynamic_custom_semantics_actions/context_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CustomSemanticsActions',
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
  bool _optionOneEnabled = false;
  bool _optionTwoEnabled = true;

  List<ContextMenuItem> _createContextMenuOne() => [
        if (_optionOneEnabled)
          ContextMenuItem(
            label: 'Disable',
            callback: () {
              setState(() {
                _optionOneEnabled = false;
              });

              Future.delayed(
                Durations.medium2,
                () => SemanticsService.announce('Disabled', TextDirection.ltr),
              );
            },
          )
        else
          ContextMenuItem(
            label: 'Enable',
            callback: () {
              setState(() {
                _optionOneEnabled = true;
              });

              Future.delayed(
                Durations.medium2,
                () => SemanticsService.announce('Enabled', TextDirection.ltr),
              );
            },
          )
      ];

  List<ContextMenuItem> _createContextMenuTwo() => [
        if (_optionTwoEnabled)
          ContextMenuItem(
            label: 'Hide',
            callback: () {
              setState(() {
                _optionTwoEnabled = false;
              });

              Future.delayed(
                Durations.medium2,
                () => SemanticsService.announce('Hidden', TextDirection.ltr),
              );
            },
          )
      ];

  @override
  Widget build(BuildContext context) {
    final contextMenuOneItems = _createContextMenuOne();
    final contextMenuTwoItems = _createContextMenuTwo();

    // This does the trick.
    // Semantics widget will update custom semantics actions,
    // because its label has changed. I'm used to add a dot '.' here.
    final labelOne = 'First label${_optionOneEnabled ? '.' : ''}';
    final labelTwo = 'Second label${_optionTwoEnabled ? '.' : ''}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('CustomSemanticsActions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Semantics(
              label: labelOne,
              customSemanticsActions:
                  contextMenuOneItems.toCustomSemanticAction(),
              child: InkWell(
                onLongPress: () =>
                    showContextMenu(context, contextMenuOneItems),
                child: const ExcludeSemantics(
                  child: Text('First widget'),
                ),
              ),
            ),
            Semantics(
              label: labelTwo,
              customSemanticsActions: contextMenuTwoItems
                  .toCustomSemanticAction(overrideDefaultAction: true),
              child: InkWell(
                onLongPress: () =>
                    showContextMenu(context, contextMenuTwoItems),
                child: const ExcludeSemantics(
                  child: Text('Second widget'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
