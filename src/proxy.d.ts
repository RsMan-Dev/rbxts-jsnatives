type ProxyTarget = Array<any> | Record<string | number, any> | Set<any> | Map<any, any> | Callback

type ProxyResult<T extends ProxyTarget, Hooks extends ProxyHandler<T>> = T & (Hooks extends { apply: (target: T, ...args: infer A) => infer R } ? { (...args: A): R } : {})

interface ProxyHandler<T extends ProxyTarget> {
  get?: (target: T, key: unknown, proxy: T) => any;
  set?: (target: T, key: unknown, value: unknown, proxy: T) => boolean;
  apply?: (target: T, proxy: T, ...args: unknown[]) => any;
  ownKeys?: (target: T, proxy: T) => Array<keyof T>;
  iter?: (target: T, proxy: T) => ReturnType<typeof pairs<T>>;
  len?: (target: T, proxy: T) => number;
}

type ProxyConstructor = {
  new <T extends ProxyTarget, H extends ProxyHandler<T>, Raw = {}>(
    target: T, 
    hooks: H, 
    raw?: Raw, 
    metaDefaults?: object
  ): ProxyResult<T, H>
}

declare const Proxy: ProxyConstructor

export default Proxy