# jsnatives

A TypeScript library for Roblox that provides JavaScript-like native functionality, including:

- Proxy implementation for object manipulation
- Object utilities (keys, entries, values, assign, etc.)
- setTimeout and setInterval implementations using Roblox's RunService

> Warn: When your project starts using proxies, ensure that you are never using pairs, or ipairs, use Object.* alternatives instead.

This library is verry likely to add more native features, so keep an eye on the repo.

If you want some missing features, feel free to open an issue, and contact me on Discord if you feel it's important: @rsman

## Installation (will provide npm package soon)

<!-- ```bash
npm install @rbxts/jsnatives
``` -->
from github directly:

```bash
npm install @rbxts/jsnatives@github:RsMan-Dev/rbxts-jsnatives
```

## Usage

### Proxy

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
    print(`Calling ${target} with ${args}`);
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
print(Object.values(obj)); // prints: { 1 } (as b is not defined)
print(Object.entries(obj)); // prints: { { "a", 1 }, { "b" } } (as b is not defined)
print(getmetatable(obj).test); // prints: from metatable
print(target === obj); // false
```

### Object Utilities (Highly inspired from @rbxts/object-utils, thanks to TrizaSoftware)

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

### JSON

```typescript
import { JSON } from "@rbxts/jsnatives";

const obj = { a: 1, b: 2 }; 
const str = JSON.stringify(obj); // "{"a":1,"b":2}"
const parsed = JSON.parse(str); // { a: 1, b: 2 }
```

## License

ISC
