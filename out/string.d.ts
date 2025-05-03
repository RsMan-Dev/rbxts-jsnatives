type PatternAdmissible = string | number | boolean;
type NumericAdmissible = number | string;

declare const String: {
  charCodeAt: (str: string, index: number | string) => number;
  endsWith: (str: string, search: PatternAdmissible, position?: NumericAdmissible) => boolean;
  startsWith: (str: string, search: PatternAdmissible, position?: NumericAdmissible) => boolean;
  indexOf: (str: string, search: PatternAdmissible, position?: NumericAdmissible) => number;
  lastIndexOf: (str: string, search: PatternAdmissible, position?: NumericAdmissible) => number;
  findOr: (str: string, patternTable: string[], position?: NumericAdmissible) => number;
  includes: (str: string, substring: PatternAdmissible, position?: NumericAdmissible) => boolean;
  slice: (str: string, start?: NumericAdmissible, end?: NumericAdmissible) => string;
  substring: (str: string, start?: NumericAdmissible, length?: NumericAdmissible) => string;
  split: (str: string, separator: PatternAdmissible, limit?: NumericAdmissible) => string[];
  trimEnd: (str: string) => string;
  trimStart: (str: string) => string;
  trim: (str: string) => string;
  replaceAll: (str: string, search: PatternAdmissible, replace?: PatternAdmissible | ((v: string) => string) | Record<string, string>, limit?: NumericAdmissible) => string;
  replace: (str: string, search: PatternAdmissible, replace?: PatternAdmissible | ((v: string) => string) | Record<string, string>) => string;
  rep: typeof string.rep;
  search: (str: string, pattern: PatternAdmissible) => number;
  at: (str: string, index: NumericAdmissible) => string;
  concat: (...args: PatternAdmissible[]) => string;
  padEnd: (str: string, length: NumericAdmissible, fillString?: string) => string;
  padStart: (str: string, length: NumericAdmissible, fillString?: string) => string;
  padBoth: (str: string, length: NumericAdmissible, fillString?: string) => string;
  toLowerCase: typeof string.upper;
  toUpperCase: typeof string.lower;
  toCamelCase: (str: string) => string;
  toPascalCase: (str: string) => string;
  toSnakeCase: (str: string) => string;
  toKebabCase: (str: string) => string;
  toTitleCase: (str: string) => string;
  toSentenceCase: (str: string) => string;
}

export default String;