---
{
  "type": "blog",
  "author": "Jordane Grenat",
  "title": "Des types au top",
  "description": "En programmation, les types sont bien plus puissants que ce que peuvent nous laisser croire les types primitifs. Venez découvrir avec moi les super pouvoirs des types !",
  "image": "images/article-covers/types.jpg",
  "published": "2019-10-10",
}
---


## Le commencement

Ayant débuté avec PHP et JavaScript, j'ai longtemps cru que les types se limitaient en programmation à ce que j'en voyais alors : une donnée peut être un `number`, une `string`, un `bool`, une `list` ou  un `object`. Toute donnée dans mes programmes était une composition de ces différents éléments.

Par exemple, la représentation d'un dix de coeur dans un jeu de cartes pouvait être :

```javascript
const tenOfHeart = { value: 10, color: 'hearts' };
```

Mais alors comment représenter un valet de coeur ? Tout simplement en considérant qu'un valet vaut `11` !

```javascript
const jackOfHeart = { value: 11, color: 'hearts' };
```

Cela ne me choquait pas à l'époque. En regardant ce type de code aujourd'hui, deux considérations me viennent immédiatement à l'esprit. La première est que ce modèle va nous obliger à avoir une traduction mentale de nos valeurs : partout où on veut représenter un valet, on doit se souvenir qu'il correspond au `11`,  puis la dame au `12`, etc. C'est un effort cognitif à produire en plus et une chance de plus de commettre une erreur. Donc un bug !

L'autre considération est plus préoccupante : si la dame vaut `12`, le roi `13` et l'as `1`, que valent ces cartes ?

```javascript
const wtfOfHeart = { value: 199, color: 'hearts' };
const what = { value: 2.6, color: 'hearts' };
const areYouKidding = { value: NaN, color: 'green' };
```

Et c'est là l'un des principaux problèmes des types basiques : mis à part le type `bool` qui peut avoir deux valeurs (`true` et `false`), tous les autres types peuvent avoir virtuellement une infinité de valeurs possibles ! Or, il n'existe que 52 cartes dans le jeu classique qu'on souhaite représenter ! 

Notre représentation d'une carte peut donc avoir une infinité de valeurs possibles alors qu'on souhaite en gérer 52 au maximum. Il s'ensuit qu'il existe une `infinité - 52 = toujours une infinité` de valeurs absurdes qui peuvent perturber l'exécution de notre programme ! Ce qui va nous obliger aux emplacements stratégiques à effectuer des vérifications :

```javascript
const validColors = ['hearts', 'spades', 'clubs', 'diamonds'];
function playCard(card) {
	if (card.value < 1 || card.value > 13 
		|| !validColors.includes(card.colors)) {
		throw new Error('Invalid card!')
	}
	// ...
}
```

## Java à la rescousse

J'ai plus tard appris Java, découvrant au passage les `enum`s. C'est une façon bien pratique de représenter un nombre fini de valeurs, ce qui nous donne au final :

```java
public enum Value {
	ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, 
	EIGHT, NINE, TEN, JACK, QUEEN, KING;
}

public enum Color {
	HEARTS, CLUBS, SPADES, DIAMONDS;
}

public class Card {
	public Value value;
	public Color color;
}
```

Les choses s'améliorent ! Si on regarde le type `Value`, on se rend compte qu'il contient seulement 13 valeurs possibles et le type `Color` peut prendre 4 valeurs différentes. Le type `Card` étant composé d'une `Value` et d'une `Color`, on peut donc représenter la combinaison des deux, c'est-à-dire `13 * 4 = 52` valeurs différentes. Voyez comme les possibilités des types se *multiplient* quand on les combine !

Et ça tombe bien, notre jeu contient 52 cartes différentes, on peut donc uniquement modéliser des cartes valides ! Cela signifie qu'il n'est pas nécessaire de vérifier par la suite que notre carte est valide, comme c'était le cas avant. On gagne en sécurité dans notre code en ne permettant pas de représenter des états non cohérents, que nous appellerons **états impossibles**.

On gagne aussi en clarté en lisant le code : plus besoin de faire un effort mental pour convertir `11` en `Jack`, puisque dans le code nous utilisons directement `JACK`.

## Le joker (pas celui de Joaquin Phoenix)

Tout va bien jusqu'à ce qu'on se rappelle un petit élément d'importance : notre jeu de 52 cartes en contient en vérité 54, puisqu'il y a les deux jokers (le rouge et le noir). Et comme je veux jouer au [8 américain](https://www.maison-facile.com/magazine/multimedia/se-divertir/jouer-entre-amis/188-jeux-de-cartes-le-8-americain/), j'en ai besoin ! Modifions donc notre modèle :

```java
public enum Value {
	ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, 
	EIGHT, NINE, TEN, JACK, QUEEN, KING, JOKER;
}

public enum Color {
	HEARTS, CLUBS, SPADES, DIAMONDS, RED, BLACK;
}
```

Avez-vous remarqué ce qu'il vient de se passer ? Notre type `Value` contient maintenant `14` valeurs possibles, et le type `Color` en contient 6. Si on les combine, on se rend compte que notre type `Card` peut représenter `14 * 6 = 84` valeurs ! On a donc 30 valeurs impossibles qui se sont glissés avec nos `52 + 2 = 54` valeurs possibles. Encore une fois, il faudra faire des vérifications dans le code...

Ou peut-être que non ?

## Les types algébriques 

Rappelez-vous : combiner deux valeurs dans un objet revient à multiplier les cas possibles de chacune de ces valeurs :

```java
public class Card {
	public Value value;
	public Color color;
}
// Value * Color = 13 * 4 = 52
```

Le nombre de valeurs possibles d'un type s'appelle la **cardinalité**. Ici, la cardinalité du type `Value` est 13 (= il peut avoir 13 valeurs différentes), celle du type `Color` est 4 et celle du type `Card` est 52.

Pour obtenir 54 valeurs possibles et représenter nos deux jokers, on aimerait idéalement pouvoir avoir une cardinalité de `52 + 2 = 54`. Or, nous savons uniquement *multipler* les cardinalités des types, pas les additionner ! Vraiment ? Ce n'est pas si sûr !

Si on ajoutait simplement une nouvelle couleur, notre type `Color` deviendrait ainsi :

```java
public enum Color {
	HEARTS, CLUBS, SPADES, DIAMONDS, NEW_COLOR;
}
``` 

Sa cardinalité devient donc `4 + 1 = 5`. Eh oui, ajouter 1 membre à un enum équivaut à ajouter 1 à sa cardinalité !

Prenons maintenant un peu de recul. Pour décrire le type `Color` en toutes lettres, on pourrait dire ceci :

 > `Color` est un type qui peut valoir `HEARTS` **ou** `CLUBS` **ou** `SPADES` **ou** `DIAMONDS` **ou** `NEW_COLOR`.

A l'inverse, on constate que notre type `Card` serait plutôt décrit de la façon suivante :

 > `Card` est un type composé d'une `Value` **et** d'une `Color`. 

Intuitivement, on comprend donc qu'un "**ou**" revient à *additionner* les cardinalités, alors qu'un "**et**" revient à *multipler* les cardinalités !

Mais alors comment décrire  notre type `Card` contenant les deux jokers ? Voilà ce que je propose :

 > Card est un type qui peut valoir `BLACK_JOKER` **ou** `RED_JOKER` **ou** être composé d'une `Value` **et** d'une `Color`.

 On voit donc qu'on souhaite *additionner* trois éléments différents, dont le dernier est une *multiplication* de deux éléments. Quelque chose comme ça :

```java
public enum Card {
	BLACK_JOKER, RED_JOKER, SIMPLE_CARD(Value, Color);
}
``` 

Sauf qu'évidemment, cette syntaxe n'est pas du Java valide ! Il s'agit d'un **type algébrique**, c'est-à-dire un type composé d'autres types, soit en les additionnant (on parle alors de `types somme`), soit en les multipliant (on parle alors de `types produit`). 

Ils ne sont malheureusement pas supportés dans tous les langages. Voilà comment on pourrait le représenter en [Elm, un langage front-end compilant en JavaScript](./ce-que-jaime-en-elm) :

```elm
type Card =
	BlackJoker 
	| RedJoker
	| SimpleCard Value Color
```

On peut ensuite utiliser ce type :

```elm
myBlackJoker = BlackJoker
myTenOfClubs = SimpleCard Ten Clubs
```

Il n'est ainsi plus possible de représenter de valeurs impossibles dans notre programme ! La cardinalité de notre représentation est égale à la cardinalité du problème métier qu'on souhaite représenter. On peut donc éviter partout dans le code des vérifications manuelles : si on possède une valeur de type `Card`, celle-ci est forcément valide. C'est toute une catégorie de bugs évitée !

Les langages supportant les *types algébriques* sont par exemple Rust, Haskell, Scala, OCaml, Elm, ReasonML, etc. Ce sont surtout des langages fonctionnels. Certains les utilisent plus ou moins en [*Kotlin*](https://proandroiddev.com/algebraic-data-types-in-kotlin-337f22ef230a) également.

## J'ai menti...

Il faut que je fasse un aveu : je vous ai menti dans les premières parties de cet article. Plus exactement en parlant du code suivant :

```java
public enum Value {
	ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, 
	EIGHT, NINE, TEN, JACK, QUEEN, KING;
}

public enum Color {
	HEARTS, CLUBS, SPADES, DIAMONDS;
}

public class Card {
	public Value value;
	public Color color;
}
```

Je vous ai affirmé que la cardinalité du type `Card` était de `13 * 4 = 52`, mais ce n'est pas le cas. En effet, nous sommes en Java et il faut donc compter avec la possibilité que les valeurs soient `null`. On a donc 5 valeurs possibles pour la `Color` (`HEARTS`, `CLUBS`, `SPADES`, `DIAMONDS` et `null`) et 14 valeurs possibles pour la `Value`, ce qui nous fait une cardinalité de `14 * 5 = 70`, bien au-delà de la cardinalité qu'on cherchait à représenter !

`null` est censé représenter une valeur qui n'est pas présente, souvent parce qu'elle n'a pas été initialisée. Mais cette valeur est un peu magique : `null` peut être de n'importe quel type et on doit donc le compter dans toutes nos cardinalités. 

Beaucoup d'exceptions et de bugs sont dus à ces valeurs `null` en Java, parce que le développeur oublie de les gérer. En JavaScript, c'est même pire, puisqu'on a `null` et `undefined` à prendre en compte ! A tel point que des langages ont décidé de ne pas avoir cette *valeur joker* dans le langage. 

Mais alors comment représenter une valeur qui peut être définie ou non ? Essayons en toutes lettres de définir une chaine de caractères qui peut ne pas être définie :

 > C'est une valeur qui peut valoir `null` **ou** contenir une `String`

Est-ce que ça ne ressemble pas à un *type somme* ? Et effectivement, c'est comme ça que ces langages le définissent, petit exemple en Elm :

```elm
type MaybeString = 
	Nothing
	| Just String
```

On voit que la valeur est soit `Nothing`, soit un `Just` contenant notre chaine de caractères. Et ça fait toute la différence avec le `null` de Java : partout où une valeur peut ne pas être définie, le développeur doit l'indiquer dans son type (en utilisant `MaybeString` au lieu de `String` par exemple). Comme c'est *explicite*, le compilateur peut donc vous forcer à gérer le cas, évitant un bug dû à l'inattention d'un développeur !

J'ai également menti une seconde fois : le type `MaybeString` n'existe pas en Elm. Il s'agit en fait d'un type `Maybe` générique qui prend en argument un type (`a` dans l'exemple ci-dessous) pour retourner un `Maybe a`. Cela évite de redéfinir un `MaybeInt`, un `MaybeString`, un `MaybeCard`... Voyez le `a` comme une variable représentant un type.

```elm
type Maybe a =
	Nothing
	| Just a

myCard : Maybe Card -- indique le type de myCard
myCard = Just RedJoker
```

C'est fini, plus de mensonges entre nous !

## Des applications d'exception

La grande force des types algébriques, c'est qu'ils vous donnent les moyens de modéliser votre modèle de façon beaucoup plus précise ! Nous l'avons vu pour le cas des valeurs qui peuvent être non définies, mais les applications sont très nombreuses.

Par exemple, prenons une opération qui peut échouer : nous essayons de lire le contenu d'un fichier. Cette requête peut échouer de différentes manières : le fichier n'existe pas, le programme n'a pas les droits en lecture, le fichier est bloqué par une autre ressource, .... Dans certains langages, la façon de gérer ces erreurs est toute trouvée : les *exceptions*. En Java notamment, il faut *penser* à gérer ces exceptions avec un bloc `try...catch` :

```java
try {
	Files.readAllLines(filePath, UTF_8);`
} catch (IOException e) {
	// gestion de l'erreur
}
```

C'est ici acceptable parce que le compilateur force l'utilisateur à gérer cette `IOException` explicitement, soit avec ce bloc `try...catch`, soit en indiquant dans la définition de la fonction que celle-ci peut renvoyer une exception. Cependant, en lisant [la documentation de `Files.readAllLines`](https://docs.oracle.com/javase/7/docs/api/java/nio/file/Files.html#readAllLines(java.nio.file.Path,%20java.nio.charset.Charset%29), on se rend compte qu'il existe un second type d'exception, `SecurityException` qui est une `RuntimeException`. 

Pour ceux qui ne font pas de Java, cela veut dire que le développeur n'est pas *obligé* de gérer cette erreur. Et j'irai même plus loin : rien n'est fait pour que le développeur ait *conscience* que cette erreur peut se produire ! Il est dès lors possible que ces erreurs se manifestent en production.

Une exception va remonter la pile d'appels jusqu'à ce qu'elle soit attrapée par un `try...catch` ou remonter jusqu'à l'utilisateur le cas échéant. Dans de plus en plus de langages, on a tendance à ne plus utiliser d'exceptions à cause de ce côté *magique* et implicite. Pour rendre cela explicite, on fait porter cette information par le type de retour de notre fonction, comme on pouvait le faire plus haut avec un `Maybe String` pour une valeur pouvant être non définie.

En Rust par exemple, il existe un type `Result`  défini comme ceci :

```rust
enum Result<T, E> {
   Ok(T),
   Err(E),
}
```

`T` et `E` sont des variables de types, cela signifie donc que notre valeur de type `Result` est soit un `Ok` contenant une valeur de type `T`, soit un `Err` de  type `E`. Dès lors, le développeur est obligé d'extraire cette valeur et donc de considérer et gérer le cas d'erreur de façon explicite.

La signature de la fonction `read` en Rust est du coup la suivante :


```rust
fn read(&mut self, buf: &mut [u8]) -> Result<usize, io::Error>
```

La seule partie importante pour nous est le retour : on reçoit un `Result` qui, en cas de succès va être un `Ok` contenant un `usize` (un pointeur en mémoire vers le résultat) et en cas d'échec va être un `Err` contenant la cause de l'erreur de type `io::Error`.

On voit ici qu'en plus de sécuriser le développement de l'application en forçant le développeur à gérer les cas d'erreur, le type `Result` joue le rôle de **documentation** du code : on *sait* que cette méthode peut échouer en lisant la signature.

## Je perds la *bool*

Mais pas besoin d'avoir des *types algébriques* pour améliorer son code grâce aux types, on peut déjà aller loin avec des *enum*s. Regardons cette fonction en Java, permettant de commander un produit en ligne :

```java
public Order orderProduct(Product product, boolean withGiftWrap) {
	// ...
}

orderProduct(book, true);
```

On peut remarquer deux choses : la fonction retourne un `Order`, alors que d'expérience, ce genre de méthode peut sûrement échouer pour de nombreuses raisons différentes. Cela signifie que cette méthode a de grandes chances de lancer des exceptions en cas d'erreur ! Mais passons, c'est le second point qui nous intéresse ici : si on ne voit que l'appel de la fonction, on peut se demander ce que signifie ce `true` passé en second argument.  La seule façon de le savoir est d'aller voir la définition de la fonction pour constater qu'il s'agit de l'ajout ou non de papier cadeau. On appelle cela *boolean blindness*.

Souvent, les booléens sont utilisés par facilité, alors que l'utilisation d'un enum améliorerait de beaucoup la lisibilité :

```java
public enum GiftWrap {
	NO_GIFT_WRAP, WITH_GIFT_WRAP;
}

public Order orderProduct(Product product, GiftWrap giftWrap) {
	// ...
}

orderProduct(book, WITH_GIFT_WRAP);
```

N'est-ce pas plus lisible ? Et surtout cela nous permettra d'évoluer plus facilement : si demain on souhaite laisser le choix entre deux types de papier cadeaux, on peut juste rajouter des éléments à l'enum :

```java
public enum GiftWrap {
	NO_GIFT_WRAP, CHILD_GIFT_WRAP, ADULT_GIFT_WRAP;
}
```

A chaque fois qu'on se retrouve à utiliser des booléens, il faut se demander si notre intention ne serait pas plus clair avec un enum explicitant vraiment la valeur métier.

## L'appliquer dès aujourd'hui

Si vous avez l'occasion d'utiliser un langage avec des types algébriques qui correspond à votre problème, foncez ! Ce n'est cependant pas toujours le cas, et bien qu'il soit possible d'émuler leur fonctionnement dans certains langages, la création est souvent peu pratique.

Cependant, on trouve dans tous les langages des bibliothèques d'utilitaires fournissant des éléments comme le `Maybe` (parfois appelé `Option` ou `Optional`) et le `Result` (parfois appelé `Either`,  `Try` s'il est  spécialisé pour des exceptions). C'est le cas en Java notamment avec [l'excellente bibliothèque Vavr](https://www.vavr.io/). En TypeScript, vous pouvez également activer l'option [`strictNullChecks`](https://basarat.gitbooks.io/typescript/docs/options/strictNullChecks.html) qui ajoute plus de vérifications sur les `null` et `undefined`.

Dans tous les cas, mon premier conseil est le suivant : débarrassez-vous de `null`. Rendez  l'absence de valeur explicite et vous éviterez beaucoup de problèmes. Faites de même avec les exceptions.

Mon second conseil est d'éviter au maximum la *primitive obsession* : n'hésitez pas à créer des objets / enums plutôt que d'utiliser les types primitifs comme `string`, `bool` et `number`. Il me semble avoir vu un jour cette citation dont je ne connais ni l'origine ni l'auteur et que j'ai peut-être involontairement déformée (n'hésitez pas à m'envoyer la référence si vous l'avez) :

  > Quand vous écrivez qu'une fonction prend un `string` en argument, votre fonction *doit* accepter l'intégralité des oeuvres de Shakespeare en mandarin en paramètre.

Et mon dernier conseil est sans doute le plus important : essayez de rendre possible uniquement les valeurs que votre métier accepte ; éliminez grâce aux types le maximum d'états impossibles. En ce sens, je vous recommande cet excellent talk de Richard Feldman (en anglais) : [Making impossible states impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8).


**[Cet article possède une seconde partie, cliquez ici pour lire la suite.](/blog/des-types-au-top-2)**
