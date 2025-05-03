export type ProxyTarget = Array<any> | Record<string | number, any> | Set<any> | Map<any, any>

export type ProxyHandler<T extends ProxyTarget> = {
  get?: (target: T, key: keyof T, proxy: T) => any;
  set?: (target: T, key: keyof T, value: unknown, proxy: T) => boolean;
  apply?: (target: T, proxy: T, ...args: unknown[]) => any;
  ownKeys?: (target: T, proxy: T) => Array<keyof T>;
  iter?: (target: T, proxy: T) => ReturnType<typeof pairs<T>>;
  len?: (target: T, proxy: T) => number;
}

type ProxyConstructor = {
  new <T extends ProxyTarget, H extends ProxyHandler<T>, Raw = {}>(target: T, hooks: H, raw?: Raw, metaDefaults?: object):
    T & Raw & (H extends { apply: (target: T, ...args: infer A) => infer R } ? { (...args: A): R } : {})
}

declare const Proxy: ProxyConstructor

export default Proxy