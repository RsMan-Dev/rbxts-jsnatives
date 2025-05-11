declare const Number: {
  /**
   * Converts the given value to a number, including floats and exponential notation.
   * @param value - The value to convert to a number.
   * @returns The number.
   */
  (value: unknown): number;
  /**
   * The smallest positive number that is greater than 0.
   */ 
  EPSILON: number;
  /**
   * The maximum safe integer.
   */
  MAX_SAFE_INTEGER: number;
  /**
   * The minimum safe integer.
   */
  MIN_SAFE_INTEGER: number;
  /**
   * The maximum value a number can have.
   */
  MAX_VALUE: number;
  /**
   * The minimum value a number can have.
   */
  MIN_VALUE: number;
  /**
   * The value of NaN.
   */
  NaN: number;
  /**
   * The value of Negative NaN.
   */
  NegativeNaN: number;
  /**
   * The value of Negative Infinity.
   */
  NEGATIVE_INFINITY: number;
  /**
   * The value of Positive Infinity.
   */
  POSITIVE_INFINITY: number;
  /**
   * Checks if the given value is a finite number.
   * @param value - The value to check.
   * @returns Whether the value is a finite number.
   */
  isFinite: (value: number) => boolean;
  /**
   * Checks if the given value is an integer.
   * @param value - The value to check.
   * @returns Whether the value is an integer.
   */
  isInteger: (value: number) => boolean;
  /**
   * Checks if the given value is NaN.
   * @param value - The value to check.
   * @returns Whether the value is NaN.
   */
  isNaN: (value: number) => boolean;
  /**
   * Checks if the given value is a safe integer.
   * @param value - The value to check.
   * @returns Whether the value is a safe integer.
   */
  isSafeInteger: (value: number) => boolean;
  /**
   * Converts the given number to an exponential notation.
   * @param value - The number to convert to an exponential notation.
   * @param fractionDigits - The number of digits after the decimal point.
   * @returns The exponential notation.
   */
  toExponential: (value: number, fractionDigits?: number) => string | null;
  /**
   * Parses the given value to a number.
   * @param value - The value to parse to a number.
   * @returns The number.
   */
  parseFloat: (value: unknown) => number;
  /**
   * Parses the given value to an integer, including 0x, 0b, and 0o notations, with radix 10 by default.
   * @param value - The value to parse to an integer.
   * @param radix - The radix of the number.
   * @returns The integer.
   */
  parseInt: (value: unknown, radix?: number) => number;
  /**
   * Converts the given number to a fixed point notation.
   * @param value - The number to convert to a fixed point notation.
   * @param digits - The number of digits after the decimal point.
   * @returns The fixed point notation.
   */
  toFixed: (value: number, digits?: number) => string;
  /**
   * Converts the given number to a string. with radix 10 by default.
   * @param value - The number to convert to a string.
   * @param radix - The radix of the number.
   * @returns The string.
   */
  toString: (value: number, radix?: number) => string;
};

export default Number;