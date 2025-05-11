declare const SetUtils: {
  /**
   * Returns a new set that is the union of the two sets. (elements in either set1 or set2)
   * @param set1 - The first set.
   * @param set2 - The second set.
   * @returns A new set that is the union of the two sets.
   */
  union: <T>(set1: Set<T>, set2: Set<T>) => Set<T>;
  /**
   * Returns a new set that is the intersection of the two sets. (elements in both set1 and set2)
   * @param set1 - The first set.
   * @param set2 - The second set.
   * @returns A new set that is the intersection of the two sets.
   */
  intersection: <T>(set1: Set<T>, set2: Set<T>) => Set<T>;
  /**
   * Returns a new set that is the difference of the two sets. (elements in set1 that are not in set2)
   * @param set1 - The first set.
   * @param set2 - The second set.
   * @returns A new set that is the difference of the two sets.
   */
  difference: <T>(set1: Set<T>, set2: Set<T>) => Set<T>;
  /**
   * Returns a new set that is the symmetric difference of the two sets. (elements in either set1 or set2 but not in both)
   * @param set1 - The first set.
   * @param set2 - The second set.
   * @returns A new set that is the symmetric difference of the two sets.
   */
  symmetricDifference: <T>(set1: Set<T>, set2: Set<T>) => Set<T>;
  /**
   * Returns true if the first set is a subset of the second set. (all elements of set1 are in set2)
   * @param set1 - The first set.
   * @param set2 - The second set.
   * @returns True if the first set is a subset of the second set.
   */
  isSubsetOf: <T>(set1: Set<T>, set2: Set<T>) => boolean;
  /**
   * Returns true if the first set is a superset of the second set. (all elements of set2 are in set1)
   * @param set1 - The first set.
   * @param set2 - The second set.
   * @returns True if the first set is a superset of the second set.
   */
  isSupersetOf: <T>(set1: Set<T>, set2: Set<T>) => boolean;
  /**
   * Returns true if the two sets are disjoint. (no elements in common)
   * @param set1 - The first set.
   * @param set2 - The second set.
   * @returns True if the two sets are disjoint.
   */
  isDisjointFrom: <T>(set1: Set<T>, set2: Set<T>) => boolean;
};

export default SetUtils;