type ProxyTarget = Array<any> | Record<string | number, any> | Set<any> | Map<any, any> | Callback

type ProxyResult<T extends ProxyTarget, Hooks extends ProxyHandler<T>> = T & (Hooks extends { apply: (target: T, ...args: infer A) => infer R } ? { (...args: A): R } : {})

interface ProxyHandler<T extends ProxyTarget> {
  /**
   * Called when a property is accessed and key is not present in raw object.
   * @param target - The target object.
   * @param key - The key of the property that is being accessed.
   * @param proxy - The proxy object.
   * @returns The value of the property.
   */
  get?: (target: T, key: unknown, proxy: T) => any;
  /**
   * Called when a property is set and key is not present in raw object.
   * @param target - The target object.
   * @param key - The key of the property that is being set.
   * @param value - The value of the property that is being set.
   * @param proxy - The proxy object.
   * @returns Whether the property was set successfully.
   */
  set?: (target: T, key: unknown, value: unknown, proxy: T) => boolean;
  /**
   * Called when proxy is called as a function.
   * @param target - The target object.
   * @param proxy - The proxy object.
   * @param args - The arguments of the function.
   * @returns The result of the function.
   */
  apply?: (target: T, proxy: T, ...args: unknown[]) => any;
  /**
   * Called when the Object.keys method is called on the proxy. 
   * @param target - The target object.
   * @param proxy - The proxy object.
   * @returns The keys of the object.
   */
  ownKeys?: (target: T, proxy: T) => Array<keyof T>;
  /**
   * Called when using the object in global iteration. (for ... of obj where object is array, map or set types)
   * @param target - The target object.
   * @param proxy - The proxy object.
   * @returns The iterator of the object.
   */
  iter?: (target: T, proxy: T) => ReturnType<typeof pairs<T>>;
  /**
   * Called when # is accessed on the proxy. (.size() in roblox ts)
   * @param target - The target object.
   * @param proxy - The proxy object.
   * @returns The length of the object.
   */
  len?: (target: T, proxy: T) => number;
}

type ProxyConstructor = {
  /**
   * Creates a new proxy.
   * @param target - The target object.
   * @param hooks - The hooks to apply to the proxy.
   * @param raw - The raw object.
   * @param metaDefaults - The meta defaults.
   */
  new <T extends ProxyTarget, H extends ProxyHandler<T>, Raw = {}>(
    target: T, 
    hooks: H, 
    raw?: Raw, 
    metaDefaults?: object
  ): ProxyResult<T, H>
}

declare const Proxy: ProxyConstructor

export default Proxy