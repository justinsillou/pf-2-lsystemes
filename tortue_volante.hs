import Graphics.Gloss --SILLOU Justin Groupe 2B

main = animate (InWindow "Tortue-Volante" (1000, 1000) (0, 0)) white brindilleAnime

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
type EtatDessin = ([EtatTortue], [Path])

-- IMPLEMENTATION --

-- 1
motSuivant :: Regles -> Mot -> Mot
motSuivant _ [] = []
motSuivant r (x:xs) = (r x) ++ (motSuivant r xs)

-- motSuivant' :: Regles -> Mot -> Mot
-- motSuivant'' :: Regles -> Mot -> Mot

-- 3
lsysteme :: Axiome -> Regles -> LSysteme
lsysteme a r = iterate (motSuivant r) a

-- TORTUE --
{-
Config Example:
(((-150,0),0),100,1,pi/3,"F+-")
(((position, cap), longueurPas, facteurEchelle, angle, [Symbole]))
-}

configBase :: Config
configBase = (((-150,0),0),100,1,pi/3,"F+-")

-- 4
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
interpreteSymbole c (e:es, p:ps) symbole
-- Ajout en tête
  | symbole == 'F' = (avance c e : es, (p ++ [fst (avance c e)]) : ps)
  | symbole == '+' = (tourneAGauche c e : es,  (p ++ [fst (tourneAGauche c e)]) : ps)
  | symbole == '-' = (tourneADroite c e : es, (p ++ [fst (tourneADroite c e)]) : ps)
  | symbole == '[' = (e:e:es, p:p:ps)
  | otherwise = (es, p:ps)

--10
interpreteMot :: Config -> Mot -> Picture
interpreteMot config mot = Line  (head (snd (foldl (interpreteSymbole config) ([etatInitial config], [[fst (etatInitial config)]]) (filtreSymbolesTortue config mot))))

--11
lsystemeAnime :: LSysteme -> Config -> Float -> Picture
lsystemeAnime l c t = interpreteMot c (l !! enieme)
  where enieme = round t `mod` 8

{--}
brindille :: LSysteme
brindille = lsysteme "F" regles
    where regles 'F' = "F[-F]F[+F]F"
          regles  s  = [s]

broussaille :: LSysteme
broussaille = lsysteme "F" regles
    where regles 'F' = "FF-[-F+F+F]+[+F-F-F]"
          regles  s  = [s]


brindilleAnime :: Float -> Picture
brindilleAnime = lsystemeAnime brindille (((0, -400), pi/2), 800, 1/3, 25*pi/180, "F+-[]")

broussailleAnime :: Float -> Picture
broussailleAnime = lsystemeAnime broussaille (((0, -400), pi/2), 500, 2/5, 25*pi/180, "F+-[]")

{--}
