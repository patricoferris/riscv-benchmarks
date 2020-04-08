(executable (promote (until-clean) (into ../../out)) (name lists) (modules lists))

(alias (name buildbench) (deps lists.exe))
