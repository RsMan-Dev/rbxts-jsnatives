
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

  /**
   * Creates a new object with the given object as metatable's index, to mimic JavaScript's `Object.create`.
   * @param obj - The object to create a new object from.
   * @returns A new object with the given object as metatable's index.
   */
  create: <T>(obj?: T | undefined) => T extends undefined ? {} : T & {},

  /**
   * Returns an array of the keys of the given object. Supports Proxies, Arrays, Sets, Maps, and Objects.
   * @param obj - The object to get the keys of.
   * @returns An array of the keys of the given object.
   */
  keys: {
    <T>(obj: ReadonlyArray<T>): Array<number>,
    <T>(obj: ReadonlySet<T>): Array<T>,
    <T>(obj: ReadonlyMap<T, unknown>): Array<T>,
    <T extends object>(obj: T): Array<keyof T>,
  },

  /**
   * Returns an array of the entries of the given object. Supports Proxies, Arrays, Sets, Maps, and Objects.
   * @param obj - The object to get the entries of.
   * @returns An array of the entries of the given object.
   */
  entries: {
    <T>(obj: ReadonlyArray<T>): Array<[number, NonNullable<T>]>,
    <T>(obj: ReadonlySet<T>): Array<[T, true]>,
    <K, T>(obj: ReadonlyMap<K, T>): Array<[K, NonNullable<T>]>,
    <T extends object>(obj: T): Array<[keyof T, NonNullable<T[keyof T]>]>,
  },

  /**
   * Returns an array of the values of the given object. Supports Proxies, Arrays, Sets, Maps, and Objects.
   * @param obj - The object to get the values of.
   * @returns An array of the values of the given object.
   */
  values: {
    <T>(obj: ReadonlyArray<T>): Array<NonNullable<T>>,
    <T>(obj: ReadonlySet<T>): Array<true>,
    <T>(obj: ReadonlyMap<unknown, T>): Array<NonNullable<T>>,
    <T extends object>(obj: T): Array<NonNullable<T[keyof T]>>,
  },
  
  /**
   * Assigns the given sources to the target object. Overriding existing properties.
   * @param target - The target object to assign the sources to.
   * @param sources - The sources to assign to the target object.
   * @returns The target object.
   */
  assign: <T, U>(target: T, ...sources: U[]) => T & ReduceObjectArray<U>,

  /**
   * Creates an object from an array of key-value pairs.
   * @param i - The array of key-value pairs.
   * @returns The created object.
   */
  fromEntries: <P extends readonly [string | number | symbol, unknown]>(
    this: void,
    i: ReadonlyArray<P>,
  ) => Reconstruct<
    UnionToIntersection<
      P extends unknown ? { [k in P[0]]: P[1]; } : never
    >
  >,

  /**
   * Checks if the given object has the given key.
   * @param obj - The object to check the key of.
   * @param key - The key to check if the object has.
   * @returns Whether the object has the given key.
   */
  hasOwn: {
    <T>(obj: ReadonlyArray<T>, key: number): boolean,
    <T>(obj: ReadonlySet<T>, key: T): boolean,
    <K, T>(obj: ReadonlyMap<K, T>, key: K): boolean,
    <T extends object>(obj: T, key: keyof T): obj is T & Record<keyof T, NonNullable<T[keyof T]>>,
  },

  /**
   * Checks if the given object is empty.
   * @param obj - The object to check if it is empty.
   * @returns Whether the object is empty.
   */
  isEmpty: <T>(obj: T) => boolean,

  /**
   * Duplicates the given object. Supports Proxies, Arrays, Sets, Maps, and Objects.
   * Can recursively duplicate the object if the `deep` parameter is set to `true`, unless will copy only the first level.
   * @param obj - The object to duplicate.
   * @param deep - Whether to duplicate the object deeply.
   * @returns The duplicated object.
   */
  dup: <T>(obj: T, deep?: boolean) => T,

  /**
   * Checks if the given object is equal to the other object. (Mimics JavaScript's `Object.is`)
   * @param obj - The object to check if it is equal to the other object.
   * @param other - The other object to check if the object is equal to.
   * @returns Whether the object is equal to the other object.
   */
  is: <T, U>(obj: T, other: U) => obj is T & U,

  /**
   * Checks if the given object is equal to the other object, by comparing the values of the properties.
   * Can check the object deeply by setting the `deep` parameter to `true`, unless will check only the first level with shallow comparison.
   * @param obj - The object to check if it is equal to the other object.
   * @param other - The other object to check if the object is equal to.
   * @param deep - Whether to check the object deeply.
   * @returns Whether the object is equal to the other object.
   */
  equals: <T, U>(obj: T, other: U, deep?: boolean) => obj is T & U,

  /**
   * Returns the string representation of the given object, as json string
   * @param obj - The object to get the string representation of.
   * @returns The string representation of the given object.
   */
  toString: <T>(obj: T) => string,

  /**
   * Checks if the given object is callable.
   * @param obj - The object to check if it is callable.
   * @returns Whether the object is callable.
   */
  isCallable: {
    (obj: unknown): obj is Callback,
    <T extends object>(obj: T): obj is T & Callback
  },

  /**
   * Freezes the given object.
   * @param obj - The object to freeze.
   * @returns The frozen object.
   */
  freeze: <T, Deep extends boolean>(obj: T, deep?: Deep) => Deep extends true ? DeepReadonly<T> : Readonly<T>,

  /**
   * Checks if the given object is frozen.
   * @param obj - The object to check if it is frozen.
   * @returns Whether the object is frozen.
   */
  isFrozen: <T>(obj: T) => obj is Readonly<T>,

  /**
   * Seals the given object. A sealed object is an object that cannot be modified., but can still be mutated.
   * @param obj - The object to seal.
   * @returns The sealed object.
   */
  seal: <T>(obj: T) => Readonly<T>,

  /**
   * Excludes the given types from the given object.
   * @warn This function does changes the original object, use `Object.dup` to duplicate the object first if you want to keep the original object.
   * @warn deep does not include a depth limit or a cache, so it can be slow on large objects, or stack overflow on circular objects.
   * @param obj - The object to exclude the types from.
   * @param types - The types to exclude from the object.
   * @param deep - Whether to exclude the types deeply.
   * @returns The object with the excluded types.
   */
  excludeTypes: <T, Deep extends boolean>(obj: T, types: (keyof CheckableTypes)[] | Set<keyof CheckableTypes>, deep?: Deep) => Deep extends true ? DeepPartial<T> : Partial<T>,
  
  /**
   * A symbol that is used to indicate that a property has been deleted. in a diff object.
   */
  diffDeletedSymbol: symbol,

  /**
   * Returns a diff object between the current and other object.
   * The diff object is a object that contains the changes that have been made to the other object to become the current object.
   * @warn deep does not include a depth limit or a cache, so it can be slow on large objects, or stack overflow on circular objects.
   * @param current - The current object.
   * @param other - The other object.
   * @param deep - Whether to diff the object deeply.
   * @returns The diff object.
   */
  diff: <T, U, Deep extends boolean>(current: T, other: U, deep?: Deep) => Diff<T, U, Deep>,

  /**
   * Applies a diff object to the current object.
   * @warn This function does changes the original object, use `Object.dup` to duplicate the object first if you want to keep the original object.
   * @warn deep does not include a depth limit or a cache, so it can be slow on large objects, or stack overflow on circular objects.
   * @param current - The current object.
   * @param diff - The diff object.
   * @param deep - Whether to apply the diff deeply.
   * @returns The object with the applied diff.
   */
  patch: <T, U, Deep extends boolean>(current: T, diff: U, deep?: Deep) => T,
}

export declare const Object: Object