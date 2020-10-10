import Graphics.Gloss -- SILLOU Justin Groupe 2B

--main = display (InWindow "L-système" (1000, 1000) (0, 0)) white dessin
--dessin = interpreteMot (((-150,0),0),100,1,pi/3,"F+-") "F+F--F+F"

main = animate (InWindow "L-système" (1000, 1000) (0, 0)) white hilbertAnime

type Symbole = Char
type Mot = [Symbole]
type Axiome = Mot
type Regles = Symbole -> Mot
type LSysteme = [Mot]
type EtatTortue = (Point, Float) -- (position, cap)
type Config = (EtatTortue -- État initial de la tortue
              ,Float      -- Longueur initiale d’un pas
              ,Float      -- Facteur d’échelle
              ,Float      -- Angle pour les rotations de la tortue
              ,[Symbole]) -- Liste des symboles compris par la tortue
type EtatDessin = (EtatTortue, Path)

{-
type Path = [Point]
line :: Path -> Picture
-}

-- IMPLEMENTATION --

-- 1 méthode récusive
motSuivant :: Regles -> Mot -> Mot
motSuivant _ [] = []
motSuivant r (x:xs) = (r x) ++ (motSuivant r xs)

-- fct bien choisie du prélude
motSuivant' :: Regles -> Mot -> Mot
motSuivant' r mot = concat(map r mot)

--motSuivant'' :: Regles -> Mot -> Mot
--motSuivant'' r mot = [r symbole | symbole `elem` mot , r]

-- 2
regles_vonkoch :: Regles
regles_vonkoch 'F' = "F-F++F-F"
regles_vonkoch '+' = "+"
regles_vonkoch '-' = "-"

-- 3
lsysteme :: Axiome -> Regles -> LSysteme
lsysteme a r = iterate (motSuivant r) a

-- TORTUE --

-- Utilistion d'une configuration de base pour les tests
configBase :: Config
configBase = (((-150,0),0),100,1,pi/3,"F+-")

-- 4
-- récupération des différentes valeurs de la configuration
etatInitial :: Config -> EtatTortue
etatInitial (a,_,_,_,_) = a

longueurPas :: Config -> Float
longueurPas (_,b,_,_,_) = b

facteurEchelle :: Config -> Float
facteurEchelle (_,_,c,_,_) = c

angle :: Config -> Float
angle (_,_,_,d,_) = d

symbolesTortue :: Config -> [Symbole]
symbolesTortue (_,_,_,_,e) = e

-- 5 {- c = config -}
avance :: Config -> EtatTortue -> EtatTortue
avance c ((x, y), cap) = ((x + (longueurPas c) * cos(cap), y + (longueurPas c) * sin(cap)), cap)

-- 6
tourneAGauche :: Config -> EtatTortue -> EtatTortue
tourneAGauche c (position, cap) = (position, cap + angle c)

tourneADroite :: Config -> EtatTortue -> EtatTortue
tourneADroite c (position, cap) = (position, cap - angle c)

-- 7
filtreSymbolesTortue :: Config -> Mot -> Mot
filtreSymbolesTortue _ [] = []
filtreSymbolesTortue c (x:xs)
  | x `elem` symbolesTortue c = x : filtreSymbolesTortue c xs
  | otherwise = "" ++ filtreSymbolesTortue c xs

--8
interpreteSymbole :: Config -> EtatDessin -> Symbole -> EtatDessin
interpreteSymbole c (etatTortue, path) symbole
-- Ajout en tête
  | symbole == 'F' = (avance c etatTortue, fst (avance c etatTortue) : path)
  | symbole == '+' = (tourneAGauche c etatTortue, path)
  | otherwise = (tourneADroite c etatTortue, path)

--10
interpreteMot :: Config -> Mot -> Picture
interpreteMot config mot = Line (snd (initInterpreteMot config ((etatInitial config), [fst (etatInitial config)]) (filtreSymbolesTortue config mot)))

initInterpreteMot :: Config -> EtatDessin -> Mot -> EtatDessin
initInterpreteMot _ etatDessin "" = etatDessin
initInterpreteMot config etatDessin (x:xs) = initInterpreteMot config (interpreteSymbole config etatDessin x) xs

--11
lsystemeAnime :: LSysteme -> Config -> Float -> Picture
lsystemeAnime l c t = interpreteMot c (l !! enieme)
  where enieme = round t `mod` 8


vonKoch1 :: LSysteme
vonKoch1 = lsysteme "F" regles
    where regles 'F' = "F-F++F-F"
          regles  s  = [s]

vonKoch2 :: LSysteme
vonKoch2 = lsysteme "F++F++F++" regles
    where regles 'F' = "F-F++F-F"
          regles  s  = [s]

hilbert :: LSysteme
hilbert = lsysteme "X" regles
    where regles 'X' = "+YF-XFX-FY+"
          regles 'Y' = "-XF+YFY+FX-"
          regles  s  = [s]

dragon :: LSysteme
dragon = lsysteme "FX" regles
    where regles 'X' = "X+YF+"
          regles 'Y' = "-FX-Y"
          regles  s  = [s]

vonKoch1Anime :: Float -> Picture
vonKoch1Anime = lsystemeAnime vonKoch1 (((-400, 0), 0), 800, 1/3, pi/3, "F+-")

vonKoch2Anime :: Float -> Picture
vonKoch2Anime = lsystemeAnime vonKoch2 (((-400, -250), 0), 800, 1/3, pi/3, "F+-")

hilbertAnime :: Float -> Picture
hilbertAnime = lsystemeAnime hilbert (((-400, -400), 0), 800, 1/2, pi/2, "F+-")

dragonAnime :: Float -> Picture
dragonAnime = lsystemeAnime dragon (((0, 0), 0), 50, 1, pi/2, "F+-")
