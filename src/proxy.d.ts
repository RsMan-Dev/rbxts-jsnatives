type ProxyTarget = Array<any> | Record<string | number, any> | Set<any> | Map<any, any> | Callback

type ProxyResult<T extends ProxyTarget, Hooks extends ProxyHandler<T>> = T & (Hooks extends { apply: (target: T, ...args: infer A) => infer R } ? { (...args: A): R } : {})

interface ProxyHandler<T extends ProxyTarget> {
  get?: (target: T, key: unknown, proxy: ProxyResult<T, this>) => any;
  set?: (target: T, key: unknown, value: unknown, proxy: ProxyResult<T, this>) => boolean;
  apply?: (target: T, proxy: ProxyResult<T, this>, ...args: unknown[]) => any;
  ownKeys?: (target: T, proxy: ProxyResult<T, this>) => Array<keyof T>;
  iter?: (target: T, proxy: ProxyResult<T, this>) => ReturnType<typeof pairs<T>>;
  len?: (target: T, proxy: ProxyResult<T, this>) => number;
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