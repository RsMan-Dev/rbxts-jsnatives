import Symbol from "./symbol";

const timeouts = new WeakMap<symbol, () => false>();
const intervals = new WeakMap<symbol, () => false>();

export function clearTimeout(sym: symbol | undefined) {
  if (sym !== undefined && timeouts.get(sym)?.() === false) timeouts.delete(sym);
}

export function setTimeout(cb: (sym: symbol) => void, ms = 0) {
  const sym = Symbol("timeout");
  let active = true;
  task.delay(ms / 1000, () => {
    if (!active) return;
    cb(sym);
  })
  timeouts.set(sym, () => active = false);
  return sym;
}

export function setInterval(cb: (sym: symbol) => void, ms = 0) {
  const sym = Symbol("interval");
  let active = true;
  const run = () => task.delay(ms / 1000, () => {
    if (!active) return;
    cb(sym);
    run();
  })
  intervals.set(sym, () => active = false);
  return sym;
}

export function clearInterval(sym: symbol | undefined) {
  if (sym !== undefined && intervals.get(sym)?.() === false) intervals.delete(sym);
}