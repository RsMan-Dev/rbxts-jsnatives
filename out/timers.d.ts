/**
 * Clears a timeout.
 * @param sym - The symbol of the timeout to clear.
 */
export declare function clearTimeout(sym: symbol | undefined): void;
/**
 * Sets a timeout.
 * @param cb - The callback to execute after the timeout.
 * @param ms - The timeout in milliseconds.
 * @returns The symbol of the timeout.
 */
export declare function setTimeout(cb: (sym: symbol) => void, ms?: number): symbol;
/**
 * Sets an interval.
 * @param cb - The callback to execute after the interval.
 * @param ms - The interval in milliseconds.
 * @returns The symbol of the interval.
 */
export declare function setInterval(cb: (sym: symbol) => void, ms?: number): symbol;
/**
 * Clears an interval.
 * @param sym - The symbol of the interval to clear.
 */
export declare function clearInterval(sym: symbol | undefined): void;
