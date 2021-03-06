---
{
  "type": "blog",
  "author": "Jordane Grenat",
  "title": "Des types au top (2)",
  "description": "Après ce premier article sur les types, découvrons maintenant les possibilités plus avancées d'un système de types : du type unitaire aux dependents types, tout en passant par les phantom types, voyons ensemble leurs avantages !",
  "image": "images/article-covers/types-2.jpg",
  "published": "2020-02-11",
}
---

Dans [mon premier article sur les types](/blog/des-types-au-top), nous avons vu plusieurs notions : la **cardinalité** d'un type correspond au nombre de valeurs possibles de ce type, les **types algébriques** correspondent au fait de pouvoir *multipler* et *additionner* les types entre eux (et donc leur cardinalité). 

Nous allons voir dans cet article des notions plus avancées pour voir comment on peut jouer avec les types dans nos programmes.

## Le type unitaire

Jusqu'à maintenant, on a réussi à créer des types avec un nombre précis de valeurs possibles grâce aux enums. Par exemple, notre type `CardValue` contenait 13 valeurs possibles :

```java
public enum Value {  
  ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING;  
}
```

De même, nous connaissons le type `bool` qui possède une cardinalité de 2 et *pourrait* être représenté par un enum également :

```java
public enum Bool {  
  TRUE, FALSE; 
}
```

Allons plus loin, et créons un type de cardinalité 1 : 

```java
public enum Unit {  
  UNIT; 
}
```

A quoi peut donc nous servir un type contenant une seule valeur ? Intuitivement, on pourrait penser que cela n'a aucune utilité : une variable de ce type ne peut contenir que cette valeur et est donc constante. On peut en réalité trouver plusieurs cas d'utilisation !

### Représenter le "rien"

Premièrement, imaginons qu'on utilise un [Result](./des-types-au-top#des-applications-d-exception) pour obtenir le résultat d'une opération. Sauf que cette opération ne retourne aucun résultat, juste l'information selon laquelle tout s'est bien déroulé *ou* une erreur indiquant ce qui s'est mal déroulé.

On pourrait donc utiliser le type `Result<String, Error>` en retournant tout le temps une chaîne de caractère vide, mais ce serait *mentir* sur notre interface. On peut alors plutôt choisir de retourner le type unitaire que nous avons créé : `Result<Unit, Error>`. L'appelant sait directement que le cas du succès ne contient aucune information exploitable autre que le fait que notre opération soit un succès.

> Attention ! Dans beaucoup de langages, le type unitaire est un type déjà défini et est représenté comme un tuple vide : `()`. On écrirait ainsi plutôt `Result<(), Error>`. Je vais donc utiliser `()` dans la suite de cet article.

Ce cas d'utilisation est très proche du `Void` dans des langages comme Java, dont la seule valeur possible est la valeur joker `null`. On peut donc s'en servir généralement pour indiquer qu'une fonction ne retourne rien. Rappelez-vous, `null` n'existe pas dans certains langages et le type algébrique `Maybe` qui remplace certains de ses cas d'utilisation sert à caractériser une fonction qui retourne *parfois* des valeurs et *parfois* rien. Ici, avec `Void`, on parle de fonctions qui ne renvoient *jamais* de valeur.

### Une fonction sans arguments

Dans les langages fonctionnels, les fonctions sans argument sont généralement des constantes, par exemple en Elm :

```elm
myValue = 13
```

Les fonctions sont pures et retournent donc toujours la même valeur quand on leur donne les mêmes arguments. Ce qui explique pourquoi une fonction sans argument est une constante !

Ici, on assigne la valeur 13 à notre variable / constante `myValue`. Comme `13` est une valeur facile à calculer,  il n'y a aucun problème. Mais que se passe-t-il si la valeur de `myValue` est quelque chose de long ou coûteux à calculer ? Dans ce cas-là, on va chercher à la calculer seulement quand on en a besoin. De faire ce qu'on appelle du `lazy`.

Et pour ça, la solution la plus simple est de mettre un argument qui ne sert à rien :

```elm
myValue : () -> Int
myValue () = 13 -- remplacer par un calcul long à effectuer

-- On calcule cette valeur seulement quand on en a besoin :
myOtherValue = myValue ()
```

### Représenter les entiers naturels

Cet usage est plus exotique, mais on pourrait s'en servir pour représenter une liste d'entier naturels, à savoir ici  `0, 1, 2, 3, 4...`. Ce n'est en général pas possible dans les langages de programmation ne possédant pas de type `unsigned int`.

Alors comment faire ? Imaginons que nous mettions notre type unitaire dans une liste (`List<()>`), on pourrait donc avoir une liste `[(), ()]` ou `[(), (), (), ()]` ou même une liste vide `[]`. Comme chaque élément de cette liste est forcément le type unitaire, la seule information que cette liste peut nous donner, c'est sa *taille*. Or, la taille d'une liste est précisément une liste d'entier naturels du type `0, 1, 2, 3, 4...`. 

On pourrait donc implémenter un type basé sur une liste du type unitaire qui nous garantirait d'avoir uniquement des entiers positifs ou zéro ! 

Dans la réalité, on utilise plutôt un type algébrique pour représenter les entiers naturels :

```elm
type NaturalInt = 
  Zero
  | Succ NaturalInt

zero = Zero
one = Succ Zero
two = Succ (Succ Zero)
-- ...
```

## Le type vide

Un type avec une cardinalité de 1 peut donc nous être utile, mais qu'en est-il d'un type de cardinalité 0, qui ne possède donc aucune valeur ? Étonnamment, ce genre de type a également des utilités ! Mais voyons comment définir ce genre de type en Haskell :

```haskell
data Void
```

On définit ici un type algébrique sans aucune valeur possible. En Elm, cette  syntaxe n'est pas possible, on a donc recours à une petite astuce pour créer le type vide `Never` :

```elm
type Never = JustOneMore Never
```

On a donc bien un constructeur présent (`JustOneMore`), mais celui-ci contient un `Never`, on doit donc lui donner une valeur en utilisant le constructeur `JustOneMore` qui doit lui-même contenir un `Never`. On entre dans une récursion infinie et il est donc impossible de créer une valeur de ce type.

### Le cas impossible

Mais alors quelle peut être l'utilité de ce type qu'on ne peut pas utiliser ? Eh bien justement de démontrer que quelque chose est impossible !

Imaginons que notre fonction retourne un `Result` pour une raison précise (pour se conformer à une interface par exemple) mais que cette fonction ne peut pas échouer (il n'y a aucun cas d'erreur possible). On pourrait signifier que ce résultat est forcément valide en utilisant `Result<MyResult, Void>`. Comme il est impossible de créer une valeur de type `Void`, le résultat sera forcément toujours de type `Ok MyResult`. Notre certitude est donc prouvée par notre système de type et vérifiée par le compilateur.

### Ne m'attendez pas !

`Void` peut également être utilisé en retour de fonction, avec une conséquence inéluctable : cette fonction ne peut jamais retourner de valeur ! La fonction ne peut donc pas se terminer de la fonction habituelle. Dans certains langages, cela peut vouloir dire que la fonction a une autre façon de se terminer (renvoyer une exception par exemple). Mais cela peut aussi vouloir dire que cette fonction ne va jamais se terminer (boucle infinie) ! On pourrait ainsi représenter une fonction chargée de calculer une à une les décimales de pi en les affichant au fur et à mesure. Comme il y en a une infinité, cette fonction ne se terminerait jamais ! 

L'utilisation du type vide peut donc être une indication de boucle infinie volontaire. Le type porte ainsi une information supplémentaire sur notre programme qui est vérifiée par le compilateur.

## Les types fantômes

Le type vide peut également être utilisé pour d'autres usages : les types fantômes – *phantom types* en anglais. Ce terme fait référence à des paramètre de types non utilisés dans la définition du type. Un exemple sera plus parlant. Ici, nous avons un type `PasswordInput` utilisé pour stocker le password saisi par un utilisateur dans un formulaire lorsqu'il veut s'enregistrer sur notre site. L'exemple est en Elm :

```elm
type PasswordInput a = Value String
```

On passe en paramètre de la définition de notre type un type `a` qu'on n'utilise pas dans la définition à droite. Mais alors à quoi sert-il ? Eh bien cela devient très utile lorsqu'on n'expose pas directement le constructeur `Value` et qu'on expose à la place une fonction `createInputValue`. Cette fonction est donc la seule façon de créer un `PasswordInput` :

```elm
type NotValidated = NotValidated
type Validated = Validated

createInputValue : String -> PasswordInput NotValidated
createInputValue value =
    Value value
```

Ici, `NotValidated` et `Validated` sont deux types unitaires qui ne vont être utilisés que dans nos signatures de type pour **taguer** notre type, indiquant s'il a été validé ou non. Ici, on crée un `PasswordInput NotValidated`, notre type de retour comporte donc l'information que cet input n'a pas été validé. Comme ces deux types sont là uniquement pour les signatures de type et non pour leurs valeurs, on peut expliciter ce fait en les rendant non instanciables grâce au type vide `Never`:

```elm
type NotValidated = NotValidated Never
type Validated = Validated Never
```

Créant maintenant une fonction de validation dont le but sera de modifier ce *tag* si l'input est valide :

```elm
type Error = InvalidPassword

validatePassword : PasswordInput NotValidated -> Result Error (PasswordInput Validated)
validatePassword (Value password) =
    if isValid password then
        Ok (Value password)
    else
        Err InvalidPassword
```

La fonction `validatePassword` permet de modifier le tag si le password est valide ou de retourner une erreur dans le cas inverse. Elle prend également en argument un password tagué `NotValidated` : avec un email identifié comme `Validated`, on ne pourrait pas utiliser cette fonction. Cette vérification se fait *au moment de la compilation*.

On peut noter qu'on ne change en rien la *valeur* de notre input, mais uniquement son *type*, qui agit donc en marqueur pour savoir s'il a été validé.

Enfin, voici la signature de la fonction permettant l'enregistrement du mot de passe côté backend :

```elm
saveNewPassword : PasswordInput Validated -> Cmd Msg
```

Comme on le voit, on peut ici inscrire dans notre système de type que notre password est bien valide, donc qu'il a passé avec succès la phase de validation de `validatePassword`. Et puisque le compilateur va vérifier cette contrainte, on peut s'y fier !

## Les dependent types

Avec les phantom types, on se rend compte qu'il est possible de jouer sur le *type* plutôt que sur la *valeur* pour faire porter une information supplémentaire à notre donnée. Cependant, nous n'avons jamais mélangé *valeur* et *type* ; ceux-ci sont toujours rigoureusement séparés. 

Imaginons qu'on possède un tableau de 5 éléments, et qu'on cherche à récupérer le 5ème élément. Les indices commencent à 0, on cherche donc à récupérer l'élément à l'index 4 grâce à la fonction `index` :

```idris
fifthElement = index 4 my5Elements
```

Jusqu'ici tout va bien, et on récupère effectivement notre 5ème élément. Mais que se passerait-il si on essayait de récupérer le 6ème élément ?

```idris
sixthElement = index 5 my5Elements
```

Dans la plupart des langages, ce code va déclencher une exception du style `OutOfBoundException`. Dans certains autres langages, la fonction `index` retourne un `Maybe` ou un `Either` pour représenter la possibilité d'erreur. En [Idris](https://www.idris-lang.org/), en revanche, ce dernier bout de code **ne compile pas** !

Comment est-ce possible ? Tout simplement parce que notre tableau d'éléments (on appelle ça un vecteur — `Vect` — en Idris) est défini comme ceci :

```idris
my5Elements : Vect 5 Element
my5Elements = One :: Two :: Three :: Four :: Five :: Nil
```

Le type est très particulier : on voit un nombre – et donc une *valeur* – pour indiquer que ce `Vect` contient 5 éléments ! C'est ce qu'on appelle un `dependent type` – possible notamment en Idris – ce qui fait que le compilateur est capable de vérifier si l'index auquel on cherche à accéder est valide ou non !

En vérité, la fonction `index` est définie grâce au type `Fin n` qui représente les entiers naturels ou nuls strictement inférieurs à `n`. Par exemple `Fin 5` est un type qui contient les valeurs suivantes : `0, 1, 2, 3, 4`. Voici le type de `index` :

```idris
index : Fin n -> Vect n e -> e
```

On ne pourra donc jamais utiliser un nombre invalide pour accéder à l'index d'un `Vect`, et si on souhaite utiliser une valeur dynamique comme index, il faudra d'abord prouver qu'elle est dans l'interval désiré !

Idris est cependant principalement un langage utilisé dans la recherche et n'est pas destiné à construire des applications grand public en production. C'est pourtant le langage le plus *utilisable* comportant des *dependent types* aujourd'hui. De plus, l'étape de compilation est très lente à cause de toute la complexité supplémentaire.

Cela reste cependant un exemple intéressant de ce que peuvent permettre des systèmes de type.

## Conclusion

La plupart des langages les plus utilisés aujourd'hui possèdent un *type system* basique. Sans types algébriques, il est par exemple compliqué de modéliser exactement notre métier sans y incorporer de nombreux cas impossibles.  

On note cependant depuis peu une émergence de langages au *type system* plus avancé, comme TypeScript (même s'il est très facile de tricher dans ce langage), Swift, Kotlin et Rust. Et c'est à mon sens une très bonne chose ! 

On voit qu'il est bien souvent possible d'inscrire dans nos types nos exigences et règles métiers. Le code s'en retrouve plus lisible et plus cohérent. Améliorer sa modélisation permet d'améliorer la compréhension qu'on a de son code et diminue du même coup la charge cognitive nécessaire pour le comprendre.

Chaque `Maybe` et `Either`, par exemple, peut représenter de l'incertitude. Et quand on commence à modéliser son incertitude, on réalise rapidement que nos codebases en sont remplies. C'est à ce moment précis qu'on peut alors chercher à la réduire, en utilisant au maximum nos types.
