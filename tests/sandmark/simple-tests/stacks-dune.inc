(executable (promote (until-clean) (into ../../out)) (name stacks) (modules stacks))

(alias (name buildbench) (deps stacks.exe))
