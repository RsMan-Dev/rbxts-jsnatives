declare const JSON: {
  stringify: <T>(data: T) => string
  parse: <T>(data: string) => T
}

export default JSON
