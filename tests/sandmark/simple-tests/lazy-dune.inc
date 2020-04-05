(executable (promote (until-clean) (into ../../out)) (name lazylist) (modules lazylist))
(executable (promote (until-clean) (into ../../out)) (name lazy_primes) (modules lazy_primes))

(alias (name buildbench) (deps lazylist.exe lazy_primes.exe))
