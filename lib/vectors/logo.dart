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

part of '../vectors.dart';

class Logo extends Vector {
  const Logo({
    super.key,
    super.size,
    super.fill,
  }) : super(
          assetName: 'assets/vectors/logo.svg.vec',
          semanticsLabel: 'H4o5F',
        );
}

class LogoWithText extends Vector {
  const LogoWithText({
    super.key,
    super.size,
    super.fill,
  }) : super(
          assetName: 'assets/vectors/logo_with_text.svg.vec',
          semanticsLabel: 'H4o5F',
        );
}
