// Copyright 2024 Fries_I23
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';

class SameTypeCodec<T> extends Codec<T, T> {
  const SameTypeCodec();

  @override
  Converter<T, T> get decoder => _Converter<T>();

  @override
  Converter<T, T> get encoder => _Converter<T>();
}

class _Converter<T> extends Converter<T, T> {
  const _Converter();

  @override
  T convert(T input) => input;
}
