(executable (promote (until-clean) (into ../../out)) (name stress) (modules stress))

(alias (name buildbench) (deps stress.exe))
