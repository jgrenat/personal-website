module Articles.WhatILoveInElm exposing (article)

import Articles exposing (Article, Lang(..))
import Element exposing (html)
import Html exposing (div)
import Html.Attributes exposing (class, style)
import Markdown
import Markdown.Config exposing (HtmlOption(..))
import Time


article : Article msg
article =
    { title = "Ce que j'aime en Elm"
    , content =
        html
            (div [ style "max-width" "100%", class "markdown" ]
                (Markdown.toHtml
                    (Just
                        { softAsHardLineBreak = True
                        , rawHtml = ParseUnsafe
                        }
                    )
                    articleContent
                )
            )
    , publicationDate = Time.millisToPosix 1569348329000
    , lang = Fr
    , slug = "ce-que-jaime-en-elm"
    }


articleContent : String
articleContent =
    """L'arrivée en 2012 de Elm sur la scène des langages de programmation s'est faite en toute discrétion. Ce langage dédié aux interfaces et applications web et compilant en JavaScript trouve progressivement ses utilisateurs sans pourtant être autant médiatisé que les alternatives JavaScript telles que React, AngularJS et Vue.js (qui ont bien souvent la puissance marketing d'un GAFAM derrière eux).

Développeur JavaScript depuis de nombreuses année lorsque j'ai découvert ce langage, j'ai immédiatement été séduit par le langage mais également par son écosystème. Je vais essayer dans cet article de vous partager certains de ces points.

TL;DR : Parcourez les titres des différentes parties 😉

## Simplicité du langage

Elm est simple. Le langage fait une seule chose et le fait bien : des interfaces et applications web. Très spécialisé, il contient donc le minimum d'éléments pour accomplir à bien sa mission et rien d'autre. Les dernières versions du langage ont d'ailleurs supprimé certains éléments jugés redondants, inutiles ou trop complexes. 

Les concepteurs n'hésitent pas à réécrire d'importantes parts du langage si de nouvelles manières de faire semblent plus intuitives et plus logiques. Cela provoque évidemment d'importants *breaking changes* entre les versions, mais nous verrons plus tard que cela n'est pas vraiment pénalisant lors des montées de version avec ce langage.

L'absence de rupture de compatibilité est l'une des grandes forces de JavaScript : un site web qui fonctionne aujourd'hui est censé toujours fonctionner correctement dans 15 ans ! C'est également malheureusement sa plus grande faiblesse : dès qu'une fonctionnalité est introduite dans le langage, elle l'est *ad vitam eternam* ! Conçu à l'époque pour un web très différent du web que nous connaissons aujourd'hui, le langage comporte aujourd'hui de nombreux défauts (très facilement utilisés par les détracteurs du langage) qui sont malheureusement voués à y rester.

Mais Elm est compilé, et c'est là toute sa force ! Un code qui fonctionne aujourd'hui fonctionnera toujours dans 15 ans si on le compile avec la même version, puisqu'elle produire le même code JavaScript ! Et cela n'empêche pas les versions suivantes de corriger leurs erreurs ! On peut donc facilement retirer des éléments du langage, gardant sa taille minimale. 

Un des effets indirects est qu'il y a en général une seule façon d'effectuer quelque chose et le développeur n'a donc pas à peser les pour et les contre de chacune des alternatives, ce qui peut parfois être dérangeant en JavaScript, qui possède par exemple de nombreux outils rien que pour gérer l'asynchrone (callbacks, promises, observables, async / await, ...).

Selon mon expérience, **un développeur n'ayant jamais fait de Elm est plus rapidement productif sur une codebase Elm qu'un développeur JavaScript sur un nouveau framework**.

## Simplicité des outils

Encore une fois, l'accent est mis sur la facilité pour les nouveaux arrivants. En installant Elm, l'utilisateur bénéficie de toute une gamme d'outils :

- un starter de projet pour initialiser rapidement un nouveau projet Elm
- un REPL (une console interactive) pour exécuter du code Elm directement dans un terminal
- un gestionnaire de paquets pour installer des modules et les publier
- elm-reactor, un environnement de développement complet capable de compiler le code à la volée
- le compilateur du langage

Et chacun de ces outils est vraiment intuitif et facile à utiliser. Un exemple ? Il suffit de regarder ce que retourne un `elm init`:

```bash
➜ project elm init
Hello! Elm projects always start with an elm.json file. I can create them!

Now you may be wondering, what will be in this file? How do I add Elm files to my project? How do I see it in the browser? How will my code grow? Do I need more directories? What about tests? Etc.

Check out <https://elm-lang.org/0.19.0/init> for all the answers!

Knowing all that, would you like me to create an elm.json file now? [Y/n]: y
Okay, I created it. Now read that link!
```
C'est souvent ce genre de message qu'on va trouver dans les outils Elm : une volonté d'expliquer ce qu'il se passe et de fournir tous les éléments nécessaires à quelqu'un débutant dans le langage pour apprendre.

Les erreurs du compilateur sont d'ailleurs très souvent citées pour leur côté simple et didactique :

```bash
-- TYPE MISMATCH ----------------------------------- Main.elm

I cannot do addition with String values like this one:

4| "Hello " + "World"
  ^^^^^^^^

The (+) operator only works with Int and Float values.

Hint: Switch to the (++) operator to append strings!
```
L'erreur vous indique l'endroit du code concerné, essaye de vous expliquer le plus précisément et humainement l'erreur rencontrée et va souvent vous proposer des pistes pour la corriger. 

Même quand l'erreur est complètement inconnue du compilateur (ce qui vous arrivera extrêmement rarement), l'idée est tout de même d'aider le développeur :

```bash
Compiling ...elm-0.19.1-beta-1-linux: ./Data/Vector/Generic/Mutable.hs:703 (modify): index out of bounds (3,3) 
CallStack (from HasCallStack): 
 error, called at ./Data/Vector/Internal/Check.hs:87:5 in vector-0.12.0.3- 028020653d7b6942874e2f105e314b1f8fd65010ca5f2ea9562b9a08a2bc03f9:Data.Vector.Internal.Check 

-- ERROR ---------------------------------------------

I ran into something that bypassed the normal error reporting process! I extracted whatever information I could from the internal error: 

> thread blocked indefinitely in an MVar operation 

These errors are usually pretty confusing, so start by asking around on one of forums listed at https://elm-lang.org/community to see if anyone can get you unstuck quickly. 

-- REQUEST -------------------------------------------

If you are feeling up to it, please try to get your code down to the smallest version that still triggers this message. Ideally in a single Main.elm and elm.json file. 

From there open a NEW issue at https://github.com/elm/compiler/issues with your reduced example pasted in directly. (Not a link to a repo or gist!) Do not worry about if someone else saw something similar. More examples is better! 

This kind of error is usually tied up in larger architectural choices that are hard to change, so even when we have a couple good examples, it can take some time to resolve in a solid way.
```

## Simplicité de l'écosystème

Là où *npm* s'impose comme le gestionnaire de paquets contenant le plus de modules, les packages Elm se comptent *uniquement* en centaines. Souvent il y a un module standard pour ce que l'on cherche à faire et le choix est donc rapide. Je n'ai personnellement jamais été bloqué par l'indisponibilité d'un package, notamment parce qu'il est en général facile d'utiliser également des modules JavaScript à travers [les ports en Elm](https://guide.elm-lang.org/interop/ports.html).

Et une catégorie se détache plus particulièrement, celle des packages liés à la gestion d'état ! En React il y a toujours un stade où il va falloir choisir entre Redux, MobX, gestion maison ou autre solution de gestion d'état plus ou moins dérivée de Flux. En Elm c'est plus simple : le langage gère directement l'état de l'application à travers la Elm Architecture, très proche de Redux. Et pour cause ! [Le créateur de Redux a en effet créé celui-ci en s'inspirant de Elm](https://redux.js.org/introduction/prior-art#elm). Étant intégrée directement dans le langage, son utilisation en Elm est d'ailleurs très intuitive.

On se pose donc au final très peu de questions en début de projet : on utilise ce langage framework et des packages utilisés par quasiment tous les projets Elm, sans devoir choisir entre de nombreuses solutions différentes. C'est pour moi l'un des inconvénients de React pour des équipes peu expérimentées : comme la bibliothèque couvre en elle-même peu de domaines, il faut choisir entre pas mal de solutions des choses comme la gestion d'état, les requêtes HTTP, etc.

## Simplicité du refactoring

Comme dit plus tôt, l'une des grandes forces de Elm est son compilateur. La seconde grande force de Elm est son absence d'erreur au runtime, et elle est directement liée à la première. Oui, vous avez bien lu ! En Elm, on considère qu'un code qui compile ne va pas planter en production, et c'est effectivement ce qui se produit en réalité. Voyez par exemple ce graphique, montrant les erreurs en production sur le site de NoRedInk sur 3 ans groupées selon qu'elles proviennent de leur code Elm (200 000 lignes de code) ou de leur code JavaScript (17 000 lignes, soit 11 fois moins !) :

<div style="text-align: center">  
    <img src="/images/noredink-js-elm-errors.png" alt="Ce graphique montre environ 60 000 erreurs JavaScript contre aucune erreur Elm affichée" style="max-width: 100%; width: 600px">
</div>

Côté Elm, même si on ne voit pas la courbe, il y a environ une dizaine d'erreurs. En effet, dans les versions précédentes du langage, il était possible pour un cas juger impossible de demander à l'application de se crasher. Et un jour un développeur s'est trompé... Cela n'est aujourd'hui même plus possible avec les nouvelles versions du langage !

Pour en revenir à cette conclusion toute simple : en Elm, quand ça compile, ça marche ! Du coup les refactoring deviennent très agréables : on commence par faire un petit changement dans le code, puis le compilateur va nous guider pour savoir ce que l'on doit changer. Rappelez-vous : ses erreurs sont très facilement compréhensibles. Et une fois que cela compile, notre refactoring est terminé ! 

Il devient alors très facile de modifier du code Elm, à tel point qu'on peut repousser les décisions à plus tard. Par exemple, nul besoin de choisir immédiatement l'architecture de vos fichiers : vous pouvez commencer avec un seul fichier, et le jour où ça devient trop pénible le split est facile (c'est souvent une simple histoire de copier/coller, comme en Elm tout est pur !).

De même, pas besoin de se lancer dans des abstractions hasardeuses, on peut décider d'attendre d'avoir plus de connaissance du métier / projet avant de réécrire certaines parties du code, avec l'assurance qu'on ne va rien oublier. 

Cette sérénité qu'apporte le langage retire toute peur de livrer en production un bug caché parce qu'on a *oublié* de penser à certains cas !

## Simplicité des dépendances

Régulièrement, on peut voir passer des vulnérabilités dans les packages publiés sur *npm*. D'où que viennent ces failles (*npm*, erreur humaine, faille technique, ...), le fait est qu'il apparaît dangereux d'ajouter une dépendance à son projet sans vérifier très attentivement sa fiabilité. Et pour cela, il n'existe pas de métrique précise : doit-on regarder le nombre de personnes l'utilisant, la fréquence des mises à jour, la célébrité de l'auteur, le code source directement ?

Et une dépendance innocente peut en tirer une autre qui, elle, peut l'être moins ! La philosophie "publiez et importez  des centaines de petit packages spécialisés pour éviter de refaire la roue" de *npm* encourage malheureusement les arbres de dépendance profonds et il est très compliqué de pouvoir contrôler exactement ce qu'on rajoute à son projet.

Elm est différent dans le sens où les dépendances présentent bien moins de risques. La raison est simple : le langage est plus strict dans sa syntaxe, notamment dans sa gestion des effets secondaires. Par *effet secondaire*, je parle ici de tout ce qui peut impacter l'extérieur d'un programme : les requêtes HTTP, l'accès aux cookies, le DOM, etc. Et c'est justement via ces effets  secondaires que proviennent la plupart des vulnérabilités ! 

En Elm, si un package installé désire utiliser une de ces fonctionnalités, cela est forcément explicite et le développeur ne peut pas l'ignorer. On sait donc quand il faut se méfier et où regarder précisément. De même, l'arbre de dépendances reste relativement plat et compréhensible.

Un autre aspect qui peut rebuter concerne la taille des dépendances. Un des conseils les plus donnés est de ne "pas ajouter toute une bibliothèque si on n'en utilise qu'une fonction ou deux". En effet, la nature dynamique de JavaScript rend compliqué le *tree-shaking* (la suppression automatique du code non utilisé lors du build), même si cet aspect a été quelque peu amélioré avec les modules ES6 qui peut maintenant le faire à l'échelle du fichier. Elm – lui – bénéficie de sa nature statique et permet d'effectuer du tree-shaking à l'échelle de la fonction. On n'hésite donc pas à rajouter une dépendance lorsqu'on n'en n'utilise qu'une petite partie."""
