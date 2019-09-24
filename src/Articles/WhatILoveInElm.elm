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
    , lang = En
    , slug = "ce-que-jaime-en-elm"
    }


articleContent : String
articleContent =
    """L'arrivée en 2012 de Elm sur la scène des langages de programmation s'est faite en toute discrétion. Ce langage dédié aux interfaces et applications web et compilant en JavaScript trouve progressivement ses utilisateurs sans pourtant être autant médiatisé que les alternatives JavaScript telles que React, AngularJS et Vue.js (qui ont bien souvent la puissance marketing d'un GAFAM derrière eux).

Développeur JavaScript depuis de nombreuses année lorsque j'ai découvert ce langage il y a quelques années et ait immédiatement été séduit par le langage mais également par son écosystème. Je vais essayer dans cet article de vous partager certains de ces points, que vous pouvez survoler en lisant les titres des différentes sections.

## Simplicité du langage

Elm est simple. Le langage fait une seule chose et le fait bien : des interfaces et applications web. Très spécialisé, il contient donc le minimum d'éléments pour accomplir à bien sa mission et rien d'autre. Les dernières versions du langage ont d'ailleurs supprimé certains éléments jugés redondants, inutiles ou trop complexes.

Les concepteurs n'hésitent pas à réécrire d'importantes parts du langage si de nouvelles manières de faire semblent plus intuitives et plus logiques. Cela provoque évidemment d'importants *breaking changes* entre les versions, mais nous verrons plus tard que cela n'est pas vraiment pénalisant lors des montées de version avec ce langage.

L'absence de rupture de compatibilité est l'une des grandes forces de JavaScript : un site web qui fonctionne aujourd'hui est censé toujours fonctionner correctement dans 15 ans ! C'est également malheureusement sa plus grande faiblesse : dès qu'une fonctionnalité est introduite dans le langage, elle l'est *ad vitam eternam* ! Conçu à l'époque pour un web très différent du web que nous connaissons aujourd'hui, le langage comporte aujourd'hui de nombreux défauts (très facilement utilisés par les détracteurs du langage) qui sont malheureusement voués à y rester.

Mais Elm est compilé, et c'est là toute sa force ! Un code qui fonctionne aujourd'hui fonctionnera toujours dans 15 ans si on le compile avec la même version, puisqu'elle produire le même code JavaScript ! Et cela n'empêche pas les versions suivantes de corriger leurs erreurs !

Un des effets indirects est qu'il y a en général une seule façon d'effectuer quelque chose et le développeur n'a donc pas à peser les pour et les contre de chacune des alternatives, ce qui peut parfois être dérangeant en JavaScript, qui possède par exemple de nombreux outils rien que pour gérer l'asynchrone (callbacks, promises, observables, async / await, ...).

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

Côté Elm, même si on ne voit pas la courbe, il y a environ une dizaine d'erreurs. En effet, dans les versions précédentes du langage, il était possible pour un cas juger impossible de demander à l'application de se crasher. Et un jour un développeur s'est trompé... Cela n'est aujourd'hui même plus possible avec les nouvelles versions du langage !"""
