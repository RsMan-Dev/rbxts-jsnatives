declare const SetUtils: {
  union: <T>(set1: Set<T>, set2: Set<T>) => Set<T>;
  intersection: <T>(set1: Set<T>, set2: Set<T>) => Set<T>;
  difference: <T>(set1: Set<T>, set2: Set<T>) => Set<T>;
  symmetricDifference: <T>(set1: Set<T>, set2: Set<T>) => Set<T>;
  isSubsetOf: <T>(set1: Set<T>, set2: Set<T>) => boolean;
  isSupersetOf: <T>(set1: Set<T>, set2: Set<T>) => boolean;
  isDisjointFrom: <T>(set1: Set<T>, set2: Set<T>) => boolean;
};

export default SetUtils;