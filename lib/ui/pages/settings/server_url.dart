/*
 * This file is part of hsas_h4o5f_app.
 * Copyright (c) 2023 HSAS H4o5F Team. All Rights Reserved.
 *
 * hsas_h4o5f_app is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * hsas_h4o5f_app is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * hsas_h4o5f_app. If not, see <https://www.gnu.org/licenses/>.
 */

part of '../settings.dart';

class ServerUrlSetting extends StatefulWidget {
  const ServerUrlSetting({
    Key? key,
    required this.prefs,
  }) : super(key: key);

  final SharedPreferences prefs;

  @override
  State<ServerUrlSetting> createState() => _ServerUrlSettingState();
}

class _ServerUrlSettingState extends State<ServerUrlSetting> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.serverUrl),
      subtitle: Text(
        widget.prefs.getStringPreference(serverUrlPreference)!,
      ),
      onTap: () async {
        controller.value = TextEditingValue(
          text: widget.prefs.getStringPreference(serverUrlPreference)!,
        );

        void submit(String value) {
          context.popDialog(value != '' ? value : defaultServerUrl);
        }

        bool validated = true;

        final serverUrl = await showStatefulAlertDialog<String>(
          context: context,
          builder: (context, setState) {
            return StatefulAlertDialogContent(
              title: Text(AppLocalizations.of(context)!.serverUrl),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  errorText: validated
                      ? null
                      : AppLocalizations.of(context)!.formatError,
                ),
                keyboardType: TextInputType.url,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    validated =
                        validateServerUrl(controller.value.text) != null;
                  });
                },
                onSubmitted: (value) => submit(value),
              ),
              actions: [
                TextButton(
                  onPressed: () => context.popDialog(),
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
                  ),
                ),
                TextButton(
                  onPressed: () => submit(controller.value.text),
                  child: Text(
                    MaterialLocalizations.of(context).okButtonLabel,
                  ),
                ),
              ],
            );
          },
        );

        if (serverUrl != null) {
          final updated = await widget.prefs.setStringPreference(
            serverUrlPreference,
            serverUrl,
          );

          if (updated) {
            try {
              await (await ParseUser.currentUser() as ParseUser).logout();
            } finally {
              if (mounted) {
                // TODO: 优化此处逻辑
                context.go('/');
              }
            }
          } else {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.formatError),
              ),
            );

            return;
          }
          setState(() {});
        }
      },
    );
  }
}
