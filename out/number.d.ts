declare const Number: {
  (value: unknown): number;
  EPSILON: number;
  MAX_SAFE_INTEGER: number;
  MIN_SAFE_INTEGER: number;
  MAX_VALUE: number;
  MIN_VALUE: number;
  NaN: number;
  NegativeNaN: number;
  NEGATIVE_INFINITY: number;
  POSITIVE_INFINITY: number;
  isFinite: (value: number) => boolean;
  isInteger: (value: number) => boolean;
  isNaN: (value: number) => boolean;
  isSafeInteger: (value: number) => boolean;
  toExponential: (value: number, fractionDigits?: number) => string | null;
  parseFloat: (value: unknown) => number;
  parseInt: (value: unknown, radix?: number) => number;
  toFixed: (value: number, digits?: number) => string;
  toString: (value: number, radix?: number) => string;
};

export default Number;