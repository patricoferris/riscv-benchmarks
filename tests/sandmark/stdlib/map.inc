(executable (promote (until-clean) (into ../../out)) (name map_bench) (modules map_bench))

(alias (name buildbench) (deps map_bench.exe))
