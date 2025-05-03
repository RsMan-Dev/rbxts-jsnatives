local SetUtils = {}

function SetUtils.union(set1: {[any]: true}, set2: {[any]: true})
  local result = {}
  for key in set1 do
    result[key] = true
  end
  for key in set2 do
    result[key] = true
  end
  return result
end

function SetUtils.intersection(set1: {[any]: true}, set2: {[any]: true})
  local result = {}
  for key in set1 do
    if set2[key] then
      result[key] = true
    end
  end
  return result
end

function SetUtils.difference(set1: {[any]: true}, set2: {[any]: true})
  local result = {}
  for key in set1 do
    if not set2[key] then
      result[key] = true
    end
  end
  return result
end

function SetUtils.symmetricDifference(set1: {[any]: true}, set2: {[any]: true})
  return SetUtils.union(SetUtils.difference(set1, set2), SetUtils.difference(set2, set1))
end

function SetUtils.isSubsetOf(set1: {[any]: true}, set2: {[any]: true})
  for key in set1 do
    if not set2[key] then
      return false
    end
  end
  return true
end

function SetUtils.isSupersetOf(set1: {[any]: true}, set2: {[any]: true})
  return SetUtils.isSubsetOf(set2, set1)
end

function SetUtils.isDisjointFrom(set1: {[any]: true}, set2: {[any]: true})
  for key in set1 do
    if set2[key] then
      return false
    end
  end
  return true
end

return {
  default = SetUtils,
}
