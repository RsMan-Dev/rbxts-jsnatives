# @rbxts/jsnatives

[![npm version](https://img.shields.io/npm/v/@rbxts/jsnatives)](https://www.npmjs.com/package/@rbxts/jsnatives)
[![GitHub license](https://img.shields.io/github/license/RsMan-Dev/rbxts-jsnatives)](https://github.com/RsMan-Dev/rbxts-jsnatives/blob/main/LICENSE)

A TypeScript library for Roblox that provides JavaScript-like native functionality, including Proxy implementation, Object utilities, setTimeout/setInterval implementations using Roblox's RunService, and JSON implementation.

> ⚠️ Warning: When your project starts using proxies, ensure that you are never using pairs or ipairs. Use Object.* alternatives instead.

## Table of Contents

- [Installation](#installation)
- [Features](#features)
- [API Reference](#api-reference)
  - [Proxy](#➤-proxy)
  - [Object Utilities](#➤-object-utilities)
  - [Timeouts](#➤-timeouts)
  - [JSON](#➤-json)
- [License](#license)
- [Contributing](#contributing)

## Installation

Currently available through GitHub:

```bash
npm install @rbxts/jsnatives@github:RsMan-Dev/rbxts-jsnatives
```

> Note: NPM package coming soon!

## Features

### Proxy Implementation
Provides a robust Proxy implementation for object manipulation, allowing for custom behavior when accessing or modifying object properties.

### Object Utilities
Comprehensive set of Object utilities inspired by JavaScript's native Object methods, including:
- `Object.keys`, `Object.values`, `Object.entries` for iteration
- `Object.assign` for object merging
- `Object.isArray` for type checking
- `Object.isEmpty` for empty checks
- And many more utilities for object manipulation

### Timeouts
Implementation of `setTimeout` and `setInterval` using Roblox's RunService, providing familiar timing functionality.

### JSON
Full JSON implementation with `stringify` and `parse` methods for data serialization.

## API Reference

### ➤ Proxy

Creates a proxy object that wraps another object and allows for custom behavior when accessing or modifying properties.

```typescript
function Proxy<T extends object>(
  target: T,
  handlers: ProxyHandler<T>,
  rawData?: object,
  metaTable?: object
): T;
```

Example:
```typescript
import { Proxy } from "@rbxts/jsnatives";

const target = {}, obj = Proxy(target, {
  get: (target, key, proxy) => {
    print(`Getting ${key}`);
    return target[key];
  },
  set: (target, key, value, proxy) => {
    print(`Setting ${key} to ${value}`);
    target[key] = value;
    return true;
  },
  ownKeys: (target, proxy) => {
    return ["a", "b"];
  },
  apply: (target, proxy, ...args) => {
    print(`Calling ${target} with`, args);
    return target(...args);
  },
}, {
  // here are raw data on the table used to create the proxy
  // setting a value here will bypass the proxy index
  test: "from raw data",
}, {
  // here is the table that will be used as metatable
  // all metamethods that the proxy will define will be overriden
  test: "from metatable",
});

obj.a = 1; // prints: Setting a to 1
print(obj.a); // prints: Getting a, then prints: 1
print(obj.test); // prints: from raw data
print(Object.keys(obj)); // prints: { "a", "b" }
print(Object.values(obj)); // prints: { 1 } (as b is not defined), also prints Getting a, Getting b
print(Object.entries(obj)); // prints: { { "a", 1 }, { "b" } } (as b is not defined), also prints Getting a, Getting b
print(getmetatable(obj).test); // prints: from metatable
print(target === obj); // false
obj(); // prints: Calling  with {}
```

### ➤ Object Utilities

Provides a comprehensive set of object manipulation utilities, inspired by @rbxts/object-utils from roblox-ts

```typescript
import { Object } from "@rbxts/jsnatives";

const obj = { a: 1, b: 2 }, 
  arr = [1, 2, 3], 
  empty = {},
  map = new Map([["a", 1], ["b", 2]]), 
  set = new Set([1, 2, 3]);

Object.keys(obj); // ["a", "b"]
Object.keys(arr); // [1, 2, 3]
Object.keys(empty); // []
Object.keys(map); // ["a", "b"]
Object.keys(set); // [1, 2, 3]

Object.entries(obj); // [["a", 1], ["b", 2]]
Object.entries(arr); // [[1, 1], [2, 2], [3, 3]]
Object.entries(empty); // []
Object.entries(map); // [["a", 1], ["b", 2]]
Object.entries(set); // [[1, true], [2, true], [3, true]]

Object.values(obj); // [1, 2]
Object.values(arr); // [1, 2, 3]
Object.values(empty); // []
Object.values(map); // [1, 2]
Object.values(set); // [1, 2, 3]

Object.isArray(arr); // true
Object.isArray(obj); // false

Object.isEmpty(obj); // false
Object.isEmpty(empty); // true

Object.assign(obj, { c: 3 }); // { a: 1, b: 2, c: 3 }
Object.assign(map, { c: 3 }); // Map { "a" => 1, "b" => 2, "c" => 3 }

Object.fromEntries(entries); // { a: 1, b: 2 }

Object.hasOwn(obj, "a"); // true
Object.hasOwn(obj, "c"); // false

Object.is(obj, assign); // true
Object.is(obj, arr); // false

Object.dup(obj); // { a: 1, b: 2 }
Object.dup(obj, true); // { a: 1, b: 2 }, deep is false by default, if false, nested object keeps the same reference

Object.is(obj, map); // false

Object.equals(obj, map); // true
Object.equals(obj, map, true); // true, deep comparison

Object.toString(obj); // "a", toString is used to convert the object to a string as json string

Object.isCallable(obj); // false, checks if the object is callable, by checking if type is function or meta has __call metamethod
```

### Timeouts

```typescript
import { setTimeout, clearTimeout } from "@rbxts/jsnatives";

const timeout = setTimeout(() => {
  print("Hello after 1 second");
}, 1000);

// Clear the timeout if needed
clearTimeout(timeout);
```

### ➤ JSON

Full JSON implementation for data serialization.

```typescript
import { JSON } from "@rbxts/jsnatives";

const obj = { a: 1, b: 2 };
const str = JSON.stringify(obj); // "{"a":1,"b":2}"
const parsed = JSON.parse(str); // { a: 1, b: 2 }
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.
