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

import 'dart:developer';
import 'dart:io';

import 'package:xml/xml.dart';

class RssFeed {
  RssFeed({
    required this.title,
    required this.description,
    required this.link,
    required this.items,
  });

  final String title;
  final String description;
  final String link;
  final List<RssItem> items;

  static Future<RssFeed> parse(String xmlString) async {
    final document = XmlDocument.parse(xmlString);
    final channel = document.findAllElements('channel').first;
    return RssFeed(
      title: channel.findElements('title').first.innerText,
      description: channel.findElements('description').first.innerText,
      link: channel.findElements('link').first.innerText,
      items:
          channel.findAllElements('item').map((e) => RssItem.parse(e)).toList(),
    );
  }
}

class RssItem {
  RssItem({
    required this.title,
    required this.description,
    required this.link,
    required this.pubDate,
    this.author,
  });

  final String title;
  final String description;
  final String link;
  final DateTime pubDate;
  final String? author;

  static RssItem parse(XmlElement element) {
    return RssItem(
      title: element.findElements('title').first.innerText,
      description: element.findElements('description').first.innerText,
      link: element.findElements('link').first.innerText,
      pubDate: (String date) {
        try {
          return HttpDate.parse(date);
        } catch (e) {
          log(
            'Failed to parse date with `HttpDate.parse()`: $date, trying `DateTime.parse()`.',
            error: e,
          );
        }
        try {
          return DateTime.parse(date);
        } catch (e) {
          log(
            'Failed to parse date with `DateTime.parse()`: $date, using `DateTime.now()`.',
            error: e,
          );
        }
        return DateTime.now();
      }(element.findElements('pubDate').first.innerText),
      author: (Iterable<XmlElement> elements) {
        if (elements.isEmpty) return null;
        return elements.first.innerText;
      }(element.findElements('author')),
    );
  }
}
