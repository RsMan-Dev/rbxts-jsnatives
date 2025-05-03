
type SymbolCallable = {
  (name: string): symbol
}

declare interface SymbolConstructor extends SymbolCallable {
  new(name: string): symbol
  for(key: string): symbol
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
