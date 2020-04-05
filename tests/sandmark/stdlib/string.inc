(executable (promote (until-clean) (into ../../out)) (name string_bench) (modules string_bench))

(alias (name buildbench) (deps string_bench.exe))