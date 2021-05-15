import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputPhoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Your Phone'),
        elevation: 1.5,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 32,
        ),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {},
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              child: Container(
                padding: const EdgeInsets.fromLTRB(4, 1, 4, 3),
                child: TextField(
                  enabled: false,
                  enableInteractiveSelection: false,
                  style: TextStyle(
                    color: theme.textTheme.headline1!.color,
                  ),
                  decoration: InputDecoration(
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(
                        color: const Color.fromARGB(255, 201, 212, 216),
                      ),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    hintText: 'Choose a country',
                    hintStyle: TextStyle(
                      color: theme.textTheme.headline1!.color,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 18),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(right: 9),
                      child: TextField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                        ],
                        cursorColor: theme.textTheme.headline1!.color,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: theme.textTheme.headline1!.color,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Text(
                            '\+',
                            style: TextStyle(
                              color: theme.textTheme.headline1!.color,
                              fontSize: 18,
                            ),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: const Color.fromARGB(255, 78, 85, 98),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.accentColor,
                              width: 2,
                            ),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.only(left: 9),
                      child: TextField(
                        autofocus: true,
                        cursorColor: theme.textTheme.headline1!.color,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: theme.textTheme.headline1!.color,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: const Color.fromARGB(255, 78, 85, 98),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.accentColor,
                              width: 2,
                            ),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 32),
              child: const Text(
                'Please confirm your country code and enter your phone number.',
                style: const TextStyle(
                  color: const Color.fromARGB(255, 124, 137, 146),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
