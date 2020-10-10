#  Le L-système et la Tortue

Ce dépôt correspond au TP de PF « Le L-système et la Tortue ».

SILLOU Justin Groupe 2 (B)

Pour récupérer l'archive :
```console
git clone https://github.com/justinsillou/pf-2-lsystemes
```

##  Contenu du dépôt

L-système et Tortue se trouvent dans : `lsysteme.hs` et `tortue_volante.hs`

## Afficher :

Dans le dossier `pf-2-lsystemes`:

- Dans un terminal:
```console
  make
```
- Pour afficher lsysteme:
```console
  ./lsysteme
```

- Pour afficher tortue_volante:
```console
  ./tortue_volante
```

## Modifications :  
Les elements affichés de base sont:
    - `hilbertAnime` pour lsysteme et `brindilleAnime` pour torue_volante

Les courbes disponibles pour lsysteme sont aussi `dragonAnime`, `vonKoch1Anime` et `vonKoch2Anime`  et pour tortue_volante `broussailleAnime`.

Que vous pouvez modifier dans le main :
```haskell
main = animate (InWindow "Tortue-Volante" (1000, 1000) (0, 0)) white "element a modifier" --retirer les ""
main = animate (InWindow "L-système" (1000, 1000) (0, 0)) white "element a modifier" -- retirer les ""
```

## Sujet : 

Le sujet ainsi que les consignes à réaliser se trouvent dans le dossier `sujet/`
