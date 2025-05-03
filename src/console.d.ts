declare const console: {
  clear: () => void
  rawLog: (...args: unknown[]) => void
  log: (...args: unknown[]) => void
  debug: (...args: unknown[]) => void
  info: (...args: unknown[]) => void
  warn: (...args: unknown[]) => void
  error: (...args: unknown[]) => void
  time: (label?: string) => void
  timeEnd: (label?: string) => void
  group: (...args: unknown[]) => void
  groupCollapsed: (...args: unknown[]) => void
  groupEnd: () => void
}

export default console