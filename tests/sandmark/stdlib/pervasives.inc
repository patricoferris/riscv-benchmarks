(executable (promote (until-clean) (into ../../out)) (name pervasives_bench) (modules pervasives_bench))

(alias (name buildbench) (deps pervasives_bench.exe))