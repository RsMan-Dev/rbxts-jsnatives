type FlatArray<T, Depth extends number> = {
	done: T;
	recur: T extends ReadonlyArray<infer InnerArray>
		? FlatArray<InnerArray, [-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20][Depth]>
		: T;
}[Depth extends -1 ? "done" : "recur"];

declare const ArrayUtils: {
  isArray: (array: unknown) => array is unknown[];
  concat: {
    <T>(first: T, ...items: Array<T>): T[];
    <T>(first: T, ...items: Array<Array<T>>): T[];
    <T>(first: Array<T>, ...items: Array<Array<T> | T>): T[];
    <T>(...items: Array<Array<T> | T>): T[];
  };
  flat: <T, Depth extends number = 1>(array: Array<T>, depth?: Depth) => Array<FlatArray<T, Depth>>;
  flatMap: <T, U>(array: Array<T>, func: (item: T, index: number, array: ReadonlyArray<T>) => ReadonlyArray<U> | U) => Array<U>;
  reverse: <T>(array: Array<T>) => Array<T>;
  toReversed: <T>(array: Array<T>) => Array<T>;
  slice: <T>(array: Array<T>, start?: number, end?: number) => Array<T>;
  splice: <T>(array: Array<T>, start: number, count: number, ...items: T[]) => Array<T>;
};

export default ArrayUtils;