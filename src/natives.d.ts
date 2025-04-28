type ProxyTarget = Array<any> | Record<string | number, any>

type LuaProxyHandler<T extends ProxyTarget> = {
  get?: (target: T, key: keyof T, proxy: T) => any;
  set?: (target: T, key: keyof T, value: unknown, proxy: T) => boolean;
  apply?: (target: T, proxy: T, ...args: unknown[]) => any;
  ownKeys?: (target: T, proxy: T) => Array<keyof T>;
  iter?: (target: T, proxy: T) => ReturnType<typeof pairs<T>>;
}

export declare function proxy<T extends ProxyTarget, H extends LuaProxyHandler<T>, Raw = {}>(target: T, hooks: H, raw?: Raw, metaDefaults?: object):
  T & Raw & (H extends { apply: (target: T, ...args: infer A) => infer R } ? { (...args: A): R } : {})

type ProxyConstructor = {
  new <T extends ProxyTarget, H extends LuaProxyHandler<T>, Raw = {}>(target: T, hooks: H, raw?: Raw, metaDefaults?: object):
    T & Raw & (H extends { apply: (target: T, ...args: infer A) => infer R } ? { (...args: A): R } : {})
}

export declare const Proxy: ProxyConstructor

type ReduceObjectArray<T> = T extends object ? T extends [infer F, ...infer R] ? F & ReduceObjectArray<R> : T : never

type Object = {
  isArray: <T>(obj: T) => obj is T & Array<unknown>,
  create: <T>(obj?: T | undefined) => T extends undefined ? {} : T & {},
  keys: {
    <T>(obj: ReadonlyArray<T>): Array<number>,
    <T>(obj: ReadonlySet<T>): Array<T>,
    <T>(obj: ReadonlyMap<T, unknown>): Array<T>,
    <T extends object>(obj: T): Array<keyof T>,
  },
  entries: {
    <T>(obj: ReadonlyArray<T>): Array<[number, NonNullable<T>]>,
    <T>(obj: ReadonlySet<T>): Array<[T, true]>,
    <K, T>(obj: ReadonlyMap<K, T>): Array<[K, NonNullable<T>]>,
    <T extends object>(obj: T): Array<[keyof T, NonNullable<T[keyof T]>]>,
  },
  values: {
    <T>(obj: ReadonlyArray<T>): Array<NonNullable<T>>,
    <T>(obj: ReadonlySet<T>): Array<true>,
    <T>(obj: ReadonlyMap<unknown, T>): Array<NonNullable<T>>,
    <T extends object>(obj: T): Array<NonNullable<T[keyof T]>>,
  },
  assign: <T, U>(target: T, ...sources: U[]) => T & ReduceObjectArray<U>,
  fromEntries: <P extends readonly [string | number | symbol, unknown]>(
    this: void,
    i: ReadonlyArray<P>,
  ) => Reconstruct<
    UnionToIntersection<
      P extends unknown ? { [k in P[0]]: P[1]; } : never
    >
  >,
  hasOwn: {
    <T>(obj: ReadonlyArray<T>, key: number): boolean,
    <T>(obj: ReadonlySet<T>, key: T): boolean,
    <K, T>(obj: ReadonlyMap<K, T>, key: K): boolean,
    <T extends object>(obj: T, key: keyof T): obj is T & Record<keyof T, NonNullable<T[keyof T]>>,
  },
  isEmpty: <T>(obj: T) => boolean,
  dup: <T>(obj: T, deep?: boolean) => T,
  is: <T, U>(obj: T, other: U) => obj is T & U,
  equals: <T, U>(obj: T, other: U, deep?: boolean) => obj is T & U,
  toString: <T>(obj: T) => string,
  isCallable: {
    (obj: unknown): obj is Callback,
    <T extends object>(obj: T): obj is T & Callback
  },
}

export declare const Object: Object

type JSON = {
  stringify: <T = unknown>(obj: T) => string,
  parse: <T = unknown>(str: string) => T,
}

export declare const JSON: JSON

