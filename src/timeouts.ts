import { RunService } from "@rbxts/services";

const timeouts = new WeakMap<object, ReturnType<RunService['Heartbeat']['Connect']>>();
export type TimeoutSymbol = {}

export function clearTimeout(sym: TimeoutSymbol | undefined) {
  if (!sym) return;
  const conn = timeouts.get(sym);
  if (conn) {
    conn.Disconnect();
    timeouts.delete(sym);
  }
}

export function setTimeout(cb: (sym: TimeoutSymbol) => void, ms = 0) {
  const sym = {} as TimeoutSymbol;
  let t = 0, sec = ms / 1000;
  const conn = RunService.Heartbeat.Connect(dt => {
    t += dt;
    if (t >= sec) (clearTimeout(sym), cb(sym));
  })
  timeouts.set(sym, conn);
  return sym;
}

export function setInterval(cb: (sym: TimeoutSymbol) => void, ms = 0) {
  const sym = {} as TimeoutSymbol;
  let t = 0, sec = ms / 1000;
  const conn = RunService.Heartbeat.Connect(dt => {
    t += dt;
    if (t >= sec) (t = 0, cb(sym));
  })
  timeouts.set(sym, conn);
  return sym;
}

export function clearInterval(sym: TimeoutSymbol | undefined) {
  clearTimeout(sym);
}