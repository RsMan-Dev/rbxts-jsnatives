type FlatArray<T, Depth extends number> = {
	done: T;
	recur: T extends ReadonlyArray<infer InnerArray>
		? FlatArray<InnerArray, [-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20][Depth]>
		: T;
}[Depth extends -1 ? "done" : "recur"];

declare const ArrayUtils: {
  /**
   * Checks if the given value is an array.
   * @param array - The value to check if it is an array.
   * @returns Whether the value is an array.
   */
  isArray: (array: unknown) => array is unknown[];
  /**
   * Concatenates the given arrays, or elements in a new array.
   * @param first - The first array to concatenate.
   * @param items - The arrays to concatenate.
   * @returns The concatenated array.
   */
  concat: {
    <T>(first: T, ...items: Array<Array<T>>): T[];
    <T>(first: Array<T>, ...items: Array<Array<T> | T>): T[];
    <T>(...items: Array<Array<T> | T>): T[];
  };
  /**
   * Flattens the given array to a new array with all sub-array elements concatenated into it recursively up to the specified depth.
   * @param array - The array to flatten.
   * @param depth - The depth to flatten the array to.
   * @returns The flattened array.
   */
  flat: <T, Depth extends number = 1>(array: Array<T>, depth?: Depth) => Array<FlatArray<T, Depth>>;
  /**
   * map the given array with the given function and flatten the result.
   * @param array - The array to map and flatten.
   * @param func - The function to apply to each element of the array.
   * @returns The flattened array.
   */
  flatMap: <T, U>(array: Array<T>, func: (item: T, index: number, array: ReadonlyArray<T>) => ReadonlyArray<U> | U) => Array<U>;
  /**
   * Reverses the given array. does change the original array.
   * @param array - The array to reverse.
   * @returns The reversed array.
   */
  reverse: <T>(array: Array<T>) => Array<T>;
  /**
   * Returns a new array that is the reverse of the given array to a new array.
   */
  toReversed: <T>(array: Array<T>) => Array<T>;
  /**
   * Returns a new array that is a slice of the given array.
   * @param array - The array to slice.
   * @param start - The start index of the slice.
   * @param end - The end index of the slice.
   * @returns The sliced array.
   */
  slice: <T>(array: Array<T>, start?: number, end?: number) => Array<T>;
  /**
   * Removes or replaces existing elements and/or adds new elements in place. does change the original array. and returns the removed elements.
   * @param array - The array to splice.
   * @param start - The start index of the splice.
   * @param count - The number of elements to remove.
   * @param items - The items to add to the array.
   * @returns The spliced array.
   */
  splice: <T>(array: Array<T>, start: number, count: number, ...items: T[]) => Array<T>;
};

export default ArrayUtils;