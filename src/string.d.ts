type PatternAdmissible = string | number | boolean;
type NumericAdmissible = number | string;

declare const String: {
  /**
   * Returns the character code of the character at the given index. (using utf-8 encoding)
   * @param str - The string to get the character code of.
   * @param index - The index of the character to get the code of.
   * @returns The character code of the character at the given index.
   */
  charCodeAt: (str: string, index: number | string) => number;
  /**
   * Returns true if the string ends with the given search string.
   * @param str - The string to check if it ends with the given search string.
   * @param search - The string to search for.
   * @param position - The position to start searching from.
   * @returns True if the string ends with the given search string.
   */
  endsWith: (str: string, search: PatternAdmissible, position?: NumericAdmissible) => boolean;
  /**
   * Returns true if the string starts with the given search string.
   * @param str - The string to check if it starts with the given search string.
   * @param search - The string to search for.
   * @param position - The position to start searching from.
   * @returns True if the string starts with the given search string.
   */
  startsWith: (str: string, search: PatternAdmissible, position?: NumericAdmissible) => boolean;
  /**
   * Returns the index of the first occurrence of the given search string.
   * @param str - The string to search in.
   * @param search - The string to search for.
   * @param position - The position to start searching from.
   * @returns The index of the first occurrence of the given search string.
   */
  indexOf: (str: string, search: PatternAdmissible, position?: NumericAdmissible) => number;
  /**
   * Returns the index of the last occurrence of the given search string.
   * @param str - The string to search in.
   * @param search - The string to search for.
   * @param position - The position to start searching from.
   * @returns The index of the last occurrence of the given search string.
   */
  lastIndexOf: (str: string, search: PatternAdmissible, position?: NumericAdmissible) => number;
  /**
   * Returns the index of the first occurrence of the given search string in the given string table.
   * @param str - The string to search in.
   * @param patternTable - The table of patterns to search for.
   * @param position - The position to start searching from.
   * @returns The index of the first occurrence of the given search string in the given string table.
   */
  findOr: (str: string, patternTable: string[], position?: NumericAdmissible) => number;
  /**
   * Returns true if the string contains the given substring.
   * @param str - The string to search in.
   * @param substring - The substring to search for.
   * @param position - The position to start searching from.
   * @returns True if the string contains the given substring.
   */
  includes: (str: string, substring: PatternAdmissible, position?: NumericAdmissible) => boolean;
  /**
   * Returns a new string with the characters between the start and end indices removed.
   * @param str - The string to slice.
   * @param start - The start index of the slice.
   * @param end - The end index of the slice.
   * @returns The sliced string.
   */
  slice: (str: string, start?: NumericAdmissible, end?: NumericAdmissible) => string;
  /**
   * Returns a new string with the characters between the start and end indices removed.
   * @param str - The string to slice.
   * @param start - The start index of the slice.
   * @param length - The length of the slice.
   * @returns The sliced string.
   */
  substring: (str: string, start?: NumericAdmissible, length?: NumericAdmissible) => string;
  /**
   * Splits the string into an array of strings by the given separator.
   * @param str - The string to split.
   * @param separator - The separator to split the string by.
   * @param limit - The limit of the split.
   * @returns The split string.
   */
  split: (str: string, separator: PatternAdmissible, limit?: NumericAdmissible) => string[];
  /**
   * Removes the trailing whitespace from the string.
   * @param str - The string to trim.
   * @returns The trimmed string.
   */
  trimEnd: (str: string) => string;
  /**
   * Removes the leading whitespace from the string.
   * @param str - The string to trim.
   * @returns The trimmed string.
   */
  trimStart: (str: string) => string;
  /**
   * Removes the leading and trailing whitespace from the string.
   * @param str - The string to trim.
   * @returns The trimmed string.
   */
  trim: (str: string) => string;
  /**
   * Replaces all occurrences of the given search string with the given replace string.
   * @param str - The string to replace.
   * @param search - The string to search for.
   * @param replace - The string to replace the search string with.
   * @param limit - The limit of the replacement.
   * @returns The replaced string.
   */
  replaceAll: (str: string, search: PatternAdmissible, replace?: PatternAdmissible | ((v: string) => string) | Record<string, string>, limit?: NumericAdmissible) => string;
  /**
   * Replaces the first occurrence of the given search string with the given replace string.
   * @param str - The string to replace.
   * @param search - The string to search for.
   * @param replace - The string to replace the search string with.
   * @returns The replaced string.
   */
  replace: (str: string, search: PatternAdmissible, replace?: PatternAdmissible | ((v: string) => string) | Record<string, string>) => string;
  /** 
   * Repeats the given string the given number of times.
   * @param str - The string to repeat.
   * @param n - The number of times to repeat the string.
   * @returns The repeated string.
   */
  rep: typeof string.rep;
  /**
   * Returns the index of the first occurrence of the given pattern in the string.
   * @param str - The string to search in.
   * @param pattern - The pattern to search for.
   * @returns The index of the first occurrence of the given pattern in the string.
   */
  search: (str: string, pattern: PatternAdmissible) => number;
  /**
   * Returns the character at the given index.
   * @param str - The string to get the character from.
   * @param index - The index of the character to get.
   * @returns The character at the given index.
   */
  at: (str: string, index: NumericAdmissible) => string;
  /**
   * Concatenates the given strings.
   * @param str - The string to concatenate.
   * @param args - The strings to concatenate.
   * @returns The concatenated string.
   */
  concat: (...args: PatternAdmissible[]) => string;
  /**
   * Pads the end of the string with the given fill string.
   * @param str - The string to pad.
   * @param length - The length of the padded string.
   * @param fillString - The string to pad the end of the string with.
   * @returns The padded string.
   */
  padEnd: (str: string, length: NumericAdmissible, fillString?: string) => string;
  /**
   * Pads the start of the string with the given fill string.
   * @param str - The string to pad.
   * @param length - The length of the padded string.
   * @param fillString - The string to pad the start of the string with.
   * @returns The padded string.
   */
  padStart: (str: string, length: NumericAdmissible, fillString?: string) => string;
  /**
   * Pads the start and end of the string with the given fill string (pads both sides with always the same amount of characters).
   * @param str - The string to pad.
   * @param length - The length of the padded string.
   * @param fillString - The string to pad the start and end of the string with.
   * @returns The padded string.
   */
  padBoth: (str: string, length: NumericAdmissible, fillString?: string) => string;
  /**
   * Converts the string to lowercase.
   * @param str - The string to convert to lowercase.
   * @returns The lowercase string.
   */
  toLowerCase: typeof string.upper;
  /**
   * Converts the string to uppercase.
   * @param str - The string to convert to uppercase.
   * @returns The uppercase string.
   */
  toUpperCase: typeof string.lower;
  /**
   * Converts the string to camel case.
   * @param str - The string to convert to camel case.
   * @returns The camel case string.
   */
  toCamelCase: (str: string) => string;
  /**
   * Converts the string to pascal case.
   * @param str - The string to convert to pascal case.
   * @returns The pascal case string.
   */
  toPascalCase: (str: string) => string;
  /**
   * Converts the string to snake case.
   * @param str - The string to convert to snake case.
   * @returns The snake case string.
   */
  toSnakeCase: (str: string) => string;
  /**
   * Converts the string to kebab case.
   * @param str - The string to convert to kebab case.
   * @returns The kebab case string.
   */
  toKebabCase: (str: string) => string;
  /**
   * Converts the string to title case.
   * @param str - The string to convert to title case.
   * @returns The title case string.
   */
  toTitleCase: (str: string) => string;
  /**
   * Converts the string to sentence case.
   * @param str - The string to convert to sentence case.
   * @returns The sentence case string.
   */
  toSentenceCase: (str: string) => string;
}

export default String;