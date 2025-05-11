
type ReduceObjectArray<T> = T extends object ? T extends [infer F, ...infer R] ? F & ReduceObjectArray<R> : T : never

type DeepReadonly<T> = T extends object ? { readonly [K in keyof T]: DeepReadonly<T[K]> } : T

type DeepPartial<T> = T extends object ? { [K in keyof T]?: DeepPartial<T[K]> } : T

type Diff<T, U, Deep extends boolean> = T extends object 
? U extends object 
  ? {
    [K in keyof T]?: K extends keyof U 
      ? Deep extends true 
        ? Diff<T[K], U[K], Deep> 
        : T[K] 
      : T[K]
    } & {
      [K in Exclude<keyof U, keyof T>]?: Object["diffDeletedSymbol"]
    } 
  : {}
: T | undefined

type Object = {
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
  freeze: <T, Deep extends boolean>(obj: T, deep?: Deep) => Deep extends true ? DeepReadonly<T> : Readonly<T>,
  isFrozen: <T>(obj: T) => obj is Readonly<T>,
  seal: <T>(obj: T) => Readonly<T>,
  excludeTypes: <T, Deep extends boolean>(obj: T, types: (keyof CheckableTypes)[] | Set<keyof CheckableTypes>, deep?: Deep) => Deep extends true ? DeepPartial<T> : Partial<T>,
  diffDeletedSymbol: symbol,
  diff: <T, U, Deep extends boolean>(current: T, newData: U, deep?: Deep) => Diff<T, U, Deep>,
  patch: <T, U, Deep extends boolean>(current: T, diff: U, deep?: Deep) => T,
}

export declare const Object: Object