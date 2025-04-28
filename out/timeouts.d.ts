export type TimeoutSymbol = {};
export declare function clearTimeout(sym: TimeoutSymbol | undefined): void;
export declare function setTimeout(cb: (sym: TimeoutSymbol) => void, ms?: number): TimeoutSymbol;
export declare function setInterval(cb: (sym: TimeoutSymbol) => void, ms?: number): TimeoutSymbol;
export declare function clearInterval(sym: TimeoutSymbol | undefined): void;
