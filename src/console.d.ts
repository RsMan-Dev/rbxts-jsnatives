declare const console: {
  /**
   * Clears the console.
   */
  clear: () => void
  /**
   * Logs the given arguments to the console without formatting.
   */
  rawLog: (...args: unknown[]) => void
  /**
   * Logs the given arguments to the console.
   */
  log: (...args: unknown[]) => void
  /**
   * Logs the given arguments to the console.
   */
  debug: (...args: unknown[]) => void
  /**
   * Logs the given arguments to the console.
   */
  info: (...args: unknown[]) => void
  /**
   * Logs the given arguments to the console.
   */
  warn: (...args: unknown[]) => void
  /**
   * Logs the given arguments to the console.
   */
  error: (...args: unknown[]) => void
  /**
   * Starts a timer with the given label.
   */
  time: (label?: string) => void
  /**
   * Stops the timer with the given label.
   */
  timeEnd: (label?: string) => void
  /**
   * Logs the given arguments to the console.
   */
  group: (...args: unknown[]) => void
  /**
   * Logs the given arguments to the console.
   */
  groupCollapsed: (...args: unknown[]) => void
  /**
   * Ends the group with the given label.
   */
  groupEnd: () => void
}

export default console