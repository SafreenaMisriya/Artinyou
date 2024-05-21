import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';


class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({super.key});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

bool firstvalue = false;

class _ToggleSwitchState extends State<ToggleSwitch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
          Center(
            child: AnimatedToggleSwitch<bool>.size(
              current: firstvalue,
              values: const [false, true],
              iconOpacity: 0.2,
              indicatorSize: const Size.fromWidth(100),
              customIconBuilder: (context, local, global) => Text(
                local.value ? 'Soft Copy' : 'Hard Copy',
                style: TextStyle(
                    color: Color.lerp(
                        Colors.black, Colors.white, local.animationValue)),
              ),
              borderWidth: 5.0,
              iconAnimationType: AnimationType.onHover,
              style: ToggleStyle(
                indicatorColor: Colors.teal,
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  const BoxShadow(
                    blurRadius: 1,
                  ),
                ]
              ),
              selectedIconScale: 1.0,
              onChanged: (value) => setState(() {
                firstvalue=value;
              })
            ),
          )
     
    );
  }
}
