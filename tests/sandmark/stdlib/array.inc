(executable (promote (until-clean) (into ../../out)) (name array_bench) (modules array_bench))

(alias (name buildbench) (deps array_bench.exe))
