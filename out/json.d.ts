declare const JSON: {
  /**
   * Stringifies the given value to a JSON string.
   * @param data - The value to stringify.
   * @returns The JSON string.
   */
  stringify: <T>(data: T) => string
  /**
   * Parses the given JSON string and returns the resulting object.
   * @param data - The JSON string to parse.
   * @returns The parsed object.
   */
  parse: <T>(data: string) => T
}

export default JSON
