tous: lsysteme tortue_volante

lsysteme: lsysteme.hs
	ghc -dynamic -Wall lsysteme.hs

tortue_volante: tortue_volante.hs
	ghc -dynamic -Wall tortue_volante.hs
	
.PHONY: tous
