import Symbol from "./symbol";

const timeouts = new WeakMap<symbol, () => false>();
const intervals = new WeakMap<symbol, () => false>();


/**
 * Clears a timeout.
 * @param sym - The symbol of the timeout to clear.
 */
export function clearTimeout(sym: symbol | undefined) {
  if (sym !== undefined && timeouts.get(sym)?.() === false) timeouts.delete(sym);
}

/**
 * Sets a timeout.
 * @param cb - The callback to execute after the timeout.
 * @param ms - The timeout in milliseconds.
 * @returns The symbol of the timeout.
 */
export function setTimeout(cb: (sym: symbol) => void, ms = 0) {
  let active = true;
  const sym = Symbol("timeout"), thread = task.delay(ms / 1000, () => {
    if (!active) return;
    cb(sym);
  })
  timeouts.set(sym, () => {
    task.cancel(thread);
    return active = false;
  });
  return sym;
}

/**
 * Sets an interval.
 * @param cb - The callback to execute after the interval.
 * @param ms - The interval in milliseconds.
 * @returns The symbol of the interval.
 */
export function setInterval(cb: (sym: symbol) => void, ms = 0) {
  const sym = Symbol("interval");
  let active = true, thread: thread | undefined = undefined;
  const run = () => {
    if (!active) return;
    if (thread) task.cancel(thread);
    thread = task.delay(ms / 1000, () => {
      if (!active) return;
      cb(sym);
      run();
    })
  }
  run();
  intervals.set(sym, () => {
    if (thread) task.cancel(thread);
    return active = false;
  });
  return sym;
}

/**
 * Clears an interval.
 * @param sym - The symbol of the interval to clear.
 */
export function clearInterval(sym: symbol | undefined) {
  if (sym !== undefined && intervals.get(sym)?.() === false) intervals.delete(sym);
}