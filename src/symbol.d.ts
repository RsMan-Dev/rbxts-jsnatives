
type SymbolCallable = {
  (name: string): symbol
}

declare interface SymbolConstructor extends SymbolCallable {
  /**
   * Creates a new symbol.
   * @param name - The name of the symbol.
   * @returns A new symbol.
   */
  new(name: string): symbol
  /**
   * Returns a symbol from a string. (Mimics JavaScript's `Symbol.for`) using global registry.
   * @param key - The key of the symbol.
   * @returns A symbol.
   */
  for(key: string): symbol
  /**
   * Checks if the given value is a symbol.
   * @param value - The value to check.
   * @returns Whether the value is a symbol.
   */
  isSymbol(value: any): value is symbol
}

declare const Symbol: SymbolConstructor

declare global {
  interface WeakMapWithSymbol<K extends object | symbol, V> extends Map<K, V> {}

  interface WeakMapConstructor {
    new<K extends object | symbol, V>(): WeakMapWithSymbol<K, V>
    new<K extends object | symbol, V>(entries: ReadonlyArray<[K, V]>): WeakMapWithSymbol<K, V>
  }

  interface WeakSetWithSymbol<T extends object | symbol> extends Set<T> {}

  interface WeakSetConstructor {
    new<T extends object | symbol>(): WeakSetWithSymbol<T>
    new<T extends object | symbol>(values: ReadonlyArray<T>): WeakSetWithSymbol<T>
  }
}

export default Symbol
