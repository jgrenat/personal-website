---
{
  "type": "blog",
  "author": "Jordane Grenat",
  "title": "Un design system en Elm",
  "description": "La méthodologie du design system apporte beaucoup au développement front-end. Sans surprise, Elm s'est révélé particulièrement adapté à l'implémentation de cette méthodologie !",
  "image": "images/article-covers/legos.png",
  "published": "2019-12-10",
}
---

Dans ma boîte, nous avons récemment démarré notre premier projet Elm pour un client. Je ne l'avais jusqu'à présent utilisé que pour des projets personnels ou des projets internes. Collaborant avec un graphiste et fort de mes expériences précédentes dans le monde JavaScript, j'ai tout de suite opté pour la méthodologie du Design System. 

L'idée est simple : plutôt que de travailler sur des pages entières, on va travailler sur les différents composants de nos pages. Ces composants sont développés indépendamment les uns des autres avec une collaboration forte entre un designer et un développeur. Le design system centralise ensuite toutes les règles et propriétés du projet (couleurs, espacements, typographies, etc.) ainsi que les composants sous leurs différents états.

Cet article n'étant pas destiné à rentrer dans les détails de la méthodologie en elle-même, je vous redirige vers cet excellent talk où Cécile Freyd-Foucault et Florent Berthelot l'expliquent point par point : [Designers, développeurs, créons la différence !](https://www.youtube.com/watch?v=jXcO7Qu1Gjs)

Ce qu'il faut retenir pour la suite de cet article, c'est qu'on essaye de centraliser au maximum les règles et composants graphiques de notre site pour l'exposer dans un endroit facilement accessible.

## Design system en Elm

J'étais assez curieux de voir ce que donnerait cette 	approche en Elm. L'idée d'avoir un langage fonctionnel dans lequel tout est pur et centré autour de fonctions réutilisables me semblait parfaitement correspondre. Et comme je le pensais, Elm s'est révélé idéal pour implémenter un design system !

> Avant d'aller plus loin, il me faut cependant éclaircir un point. Je vais parler dans la suite de cet article de **composants**. Ce terme désigne un élément visuellement distinct dans une page web, comme par exemple une carte dans une liste,  un tableau dans une page, etc. Dans le monde JavaScript, ce terme a tendance à signifier quelque chose de similaire, mais avec une particularité supplémentaire : les composants gèrent en général un état interne invisible de l'extérieur. En Elm, on cherchera à éviter au maximum les composants ayant un état interne pour privilégier au maximum les fonctions pures.

Nous avions plusieurs choix techniques possibles pour créer nos règles et composants :

 - utiliser la bibliothèque standard `elm/html` avec un fichier CSS et des classes suivant [les méthodologies OOCSS ou BEM](https://www.alsacreations.com/article/lire/1641-bonnes-pratiques-en-css-bem-et-oocss.html)
 - utiliser [`mdgriffith/elm-ui`](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) avec son approche sans CSS
 - utiliser [`rtfeldman/elm-css`](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/) qui propose une approche intéressante de CSS typé nous orientant vers du *CSS in Elm*

La curiosité pour cette dernière solution a joué un grand rôle dans le choix malgré ma réticence légendaire pour les solutions de *CSS in JavaScript*. La première alternative était très semblable à celle que j'ai l'habitude de suivre en JavaScript et je souhaitais changer pour ce projet. Quant à la deuxième option, j'avais déjà eu l'occasion d'utiliser un peu `elm-ui` et avait eu le sentiment qu'il réglait un problème que je n'avais personnellement pas : j'ai toujours apprécié le CSS et ses possibilités et me sentais un peu contraint par le champs réduit des possibles d'`elm-ui`. 

Nous sommes donc partis sur le fait d'utiliser `elm-css` avec ces quelques règles simples :

 - chaque composant (ou groupe de composants) a son propre fichier Elm dans lequel on peut trouver le composant et le CSS correspondant
 - ce CSS est défini de façon globale, c'est-à-dire qu'il génère une feuille de style CSS propre (par opposition au fait de n'utiliser que des styles *inline*, autre possibilité de `elm-css`)
 - les couleurs, typographies et espacements sont dans leur module propre
 - nos composants doivent être composables : chacun d'eux prend une liste d'attributs et d'enfants comme le ferait n'importe quelle fonction de `elm/html`

Petit exemple pour un bouton :

```elm  
button : ButtonType -> ButtonSize -> List (Html.Attribute msg) -> List (Html msg) -> Html msg  
button buttonType buttonSize attributes content =  
    let  
        typeClass =  
            class (getTypeClass buttonType)  
      
        sizeClass =  
            class (getSizeClass buttonSize)  
	in  
	Html.button  
        ([ class "button", typeClass, sizeClass ] ++ attributes)  
        content

styles : List Css.Snippet  
styles =  
    [ Css.Global.class "button"  
        [ borderRadius (px 3)  
        , textTransform uppercase  
        , cursor pointer    
        , textAlign center  
        , withClass "button--primary"  
            [ backgroundColor Colors.primary  
            , color Colors.colorOnPrimary  
            ]    
        , withClass "button--large"  
            [ padding2 (px 10) (px 16)  
            ]
        -- ... 	
        ]
    ]
```

On voit qu'on a un bouton générique qu'on peut personnaliser avec deux options : son type (primaire, secondaire, ...) et sa taille (large, medium, petit). Avec des fonctions Elm, c'est très simple à réaliser et les types nous aident à limiter les choix possibles !

Les styles sont définis à part puis centralisés entre composants et insérés une fois dans la page.

Une amélioration possible de ce code serait de typer nos classes pour éviter les erreurs d'inattention, mais nous n'avons pas encore ressenti le besoin d'aller jusque là :

```elm
type ButtonClass =
    Button
    | ButtonPrimary
    | ButtonSecondary
    | ButtonLarge

buttonClassToClass : ButtonClass -> Html.Attribute msg
buttonClassToClass buttonClass = 
    case buttonClass of 
        Button ->
            class "button"
        ButtonPrimary ->
            class "button--primary"
        ButtonSecondary ->
            class "button--secondary"
        ButtonLarge ->
            class "button--large"
```

## Les éléments de base

Un design system commence en général par les atomes, les éléments les plus simples. Nous avons donc commencé par créer un fichier `Colors` contenant toutes les couleurs de notre projet selon leur sémantique :

```elm  
borderLight : Color  
borderLight =  
    rgba 0 0 0 0.12

-- ... 

fieldBorder : Color  
fieldBorder =  
    borderLight
```

Viennent ensuite les textes. Nous avons choisi d'utiliser une unique fonction pour tous les textes de l'application afin de centraliser toutes les possibilités. Cette fonction s'appelle `typography` et est utilisée aussi bien dans nos pages que dans nos composants. L'astuce est que cette fonction prend deux arguments essentiels : le type de texte et la balise à utiliser :

```elm
type TypographyType  
    = Title1  
    | Title2  
    | Paragraph1
    | Paragraph2
    | Error

type alias Tag = 
    List (Html.Attribute msg) -> List (Html msg) -> Html msg

typography : TypographyType -> Tag -> List (Html.Attribute msg) -> String -> Html msg  
typography typographyType tagFunction attributes content =  
    let  
        className =  
            getClassName typographyType  
    in  
        tagFunction (class className :: attributes) [ text content ]

-- Exemple d'utilisation :

myTitle =
	typography Title1 h2 [] "My title"
```

L'avantage est qu'on peut combiner très facilement style et sémantique : on peut notamment respecter la hiérarchie `h1`,  `h2`, etc. sans être contraint au niveau de l'apparence du texte. 

De même, les espacements sont codifiés pour avoir un style plus uniforme sur le site :

```elm
type SpacingSize  
    = NoSpace | XXS | XS | S | M | L | XL  
  
spacing : SpacingSize -> Px  
spacing spacingSize =  
    case spacingSize of  
        NoSpace ->  
            px 0  
        XXS ->  
            px 4  
        XS ->  
            px 8  
        S ->  
            px 16  
        M ->  
            px 24  
        L ->  
            px 40  
        XL ->  
            px 60

-- Exemple d'utilisation (avec elm-css) :

myTitle =
    typography Title1 h2 
        [ css [ marginTop (spacing M) ] ] 
        "My title"
```

## Différentes approches de composants

Pour les gens issus des univers React, Angular ou autre, le réflexe de penser en composants est profondément ancré. En Elm cela est tout à fait valable mais il faut en général un peu de temps pour comprendre que la définition de composant diffère considérablement : un composant, ce n'est pas forcément un élément avec un état interne capable de gérer lui-même ses mises à jour.

Comme nous l'avons vu plus haut, un composant peut être une simple fonction ! Et j'irai même plus loin en disant que si vous le pouvez, essayez au maximum de représenter vos composants par une fonction, c'est de loin le type de composants le plus facile à utiliser. 

Mais cela ne suffit pas toujours et voici les différents cas que j'ai pu identifier :

 - mon composant n'a pas d'état interne
 - mon composant a un état interne mais pas d'effet secondaire
 - mon composant a des effets secondaires internes

Je vais revenir sur chacun de ces cas.

### Mon composant n'a pas d'état interne

Si votre composant n'a pas d'état à gérer, c'est de loin le plus simple ! C'est le cas du bouton vu plus haut, qui délègue à celui qui l'utilise la gestion du clic :

```elm
backButton =
	button Secondary Large 
	    [ type_ "button", onClick Back ] 
	    [ text "Back" ]
```

Mais par extension, un composant peut ne pas avoir d'état interne parce qu'il est tout à fait légitime que le parent soit en charge de cet état ! Par exemple, nous avons un bouton qui affiche un loader et se désactive une fois cliqué. Pour les requêtes HTTP, nous utilisons[krisajenkins/remotedata](https://package.elm-lang.org/packages/krisajenkins/remotedata/latest/RemoteData) sur toute notre application, et donc nous l'utilisons également pour l'état de notre bouton :

```elm
buttonWithStatus : RemoteData e a -> List (Html.Attribute msg) -> List (Html msg) -> Html msg  
buttonWithStatus status attributes content =  
    Html.button  
        ([ class "button"  
         , classList [ ( "button--loading", RemoteData.isLoading status ) ]  
         , disabled ( RemoteData.isLoading status )  
         ]  ++ attributes  
        )  
        (case status of  
            Loading ->  
                loader  
            _ ->  
                content  
        )
```

Comme le composant parent possède la responsabilité sur l'action effectuée, nul besoin d'avoir ce `RemoteData` dans l'état de notre composant, c'est un argument comme un autre !

### Mon composant a un état interne mais pas d'effets secondaires

Certains de nos composants ont tout de même besoin de garder un état interne qui ne devrait pas être stocké dans un composant parent. Par exemple, nos champs texte conservent toujours deux valeurs dans leur état interne : la valeur actuelle du champ et une valeur indiquant si l'utilisateur a déjà interagi avec le champ. 

```elm
module Input exposing (InputModel)

type InputModel  
    = InputModel { value : String, touchStatus : TouchStatus }
```

Une bonne pratique, comme on le voit ci-dessus, est d'utiliser un type opaque : notre module expose le type `InputModel` mais pas le constructeur `InputModel` (la nuance est importante, exposer le constructeur se ferait en modifiant la première ligne : `module Input exposing (InputModel(..))`).

Cela signifie qu'en dehors de notre fichier, le développeur n'est pas capable de modifier lui-même cet état ou d'en créer un : le composant est le seul responsable de son état interne. 

Souvent, on voit que dans ces cas là les développeurs Elm vont remettre en place une mini TEA dans le composant en lui créant une fonction `init`, `update`, `view` ainsi que des messages. Or, si effectivement il faut une façon d'initialiser le modèle et une façon de l'afficher, il n'est pas nécessaire d'avoir une fonction d'`update` ou des messages si votre composant n'a pas d'effet secondaire !

Pour cela, on va renvoyer le nouveau modèle directement dans le message généré, en demandant en argument supplémentaire un message dans lequel le stocker. Voici l'exemple :

```elm
input : String -> InputModel -> (InputModel -> msg) -> List (Html.Attribute msg) -> Html msg
input inputName (InputModel model) toMsg attributes =  
    input  
        [ class "input"  
        , type_ "text"  
        , name inputName
        , Attributes.value model.value
        , onInput (\newValue -> toMsg ( InputModel { model | value = newValue } ))
        ]  
        []
```

*(Ceci est un exemple très simplifié : notre composant `input` gère en réalité beaucoup plus de choses : un label, des erreurs, l'état activé / désactivé, etc.)*

On voit qu'on peut ainsi retourner directement à l'utilisateur le modèle modifié, ce qui est plus simple des deux côtés puisqu'on n'a pas besoin d'utiliser de `Html.map` ou d'appeler une fonction d'`update` pour le composant :

```elm
type alias Model = 
    { inputModel : Input.InputModel }

init : Model 
init = 
    { inputModel = Input.emptyInput }

type Msg =
    InputChanged Input.Model

update : Msg -> Model -> Model
update msg model = 
    case msg of
        InputChanged newModel ->
            { model | inputModel = newModel }
	
view : Model -> Html msg
view model =
    Input.input "myInput" model.inputModel InputChanged [] []
```

### Mon composant a un état interne et des effets secondaires

Si votre composant a des effets secondaires qui sont de sa responsabilité propre (et qui n'ont donc pas vocation a être gérés par le parent), il faudra utiliser une forme plus complexe et embarquer une mini Elm Architecture dans votre composant. 

Comprenez bien qu'on sort ici l'artillerie lourde : votre composant gère beaucoup plus de responsabilité et devient d'autant moins facile à utiliser. C'est donc la solution à n'utiliser que lorsque le besoin le justifie.

C'est le cas pour notre slider par exemple, dont voici les types exposés (le code étant trop long) :

```elm
type Model -- Model un type opaque

type Msg -- Msg est un type opaque

init : Float -> Float -> Float -> Model

update : Msg -> Model -> (Model, Cmd Msg)

view : Model -> Msg

subscriptions : Model -> Sub Msg

value : Model -> Float
```

On  reconnaît ici une [Elm Architecture](https://guide.elm-lang.org/architecture/). L'`init` prend trois `Float` en  argument : la valeur initiale, la valeur minimale et la valeur maximale. On reçoit en retour un Model qui est un type opaque. La seule façon de créer et donc d'utiliser notre composant est donc de passer par cette fonction. 

Les fonctions `update`, `view` et `subscriptions` sont standards, mais vont produire des messages de type `Slider.Msg`. Cela signifie que celui qui va les utiliser devra les *envelopper* dans un message à lui :

```elm
type Msg  
    = MessageFromSlider Slider.Msg  

type alias Model =  
    { sliderModel : Slider.Model }  

update : Msg -> Model -> ( Model, Cmd Msg )  
update msg model =  
    case msg of  
        MessageFromSlider sliderMsg ->  
            let  
                ( newSliderModel, sliderCmd ) =  
                    Slider.update msg model.sliderModel  
            in    
            ( { model | sliderModel = newSliderModel }  
            , Cmd.map MessageFromSlider sliderCmd  
            )

view : Model -> Html Msg  
view model =  
    div []  
        [ Slider.view model.sliderModel  
            |> Html.map MessageFromSlider  
        ]
          
subscriptions : Model -> Sub Msg  
subscriptions model =  
    Slider.subscriptions model.sliderModel  
        |> Sub.map MessageFromSlider
```

On enveloppe les messages du slider dans un message personnalisé grâce aux fonctions `Cmd.map`, `Html.map` et `Sub.map`. On obtiendra ainsi un message `MessageFromSlider` qui contient le message du slider. On se charge nous-même de transmettre ce message ainsi que le modèle à la fonction d'`update` du slider.

Comme on peut le voir, c'est une approche qui nécessite pas mal de code et qui est donc assez lourde. C'est pourquoi il est souvent recommandé de simplifier au maximum ses composants quand c'est possible. C'est un réflexe parfois dur à prendre quand on vient des frameworks JavaScript qui ont tendance à considérer que tout est un composant indépendant.

## Concrétiser son design system

Réutiliser des composants et les lister dans son code, c'est très bien, mais c'est encore mieux quand on dispose d'une galerie permettant de les passer en revue ! Pour cela, j'ai utilisé le package [`elm-ui-explorer`](https://package.elm-lang.org/packages/kalutheo/elm-ui-explorer/latest) de Théophile Kalumbu, un équivalent plus simple de [Storybook](https://storybook-design-system.netlify.com/?path=/docs/design-system-intro--page) dans l'univers JavaScript.

[Voici un exemple d'un design system avec elm-ui-explorer](https://kalutheo.github.io/elm-ui-explorer/examples/dsm/index.html#Getting%20Started/About/About)

Les avantages d'avoir cette galerie sont multiples. Premièrement, ils facilitent la discussion avec votre designer en se penchant directement sur l'implémentation que vous avez faite. Ils aident aussi les développeurs lorsqu'ils ont besoin de retrouver des composants ou de revoir les différentes capacités de leurs composants. Pendant la phase de développement, cela offre aussi l'énorme avantage de tester ses composants en totale isolation du reste du code, permettant ainsi de trouver des bugs visuels ou logiques qui auraient été durs à détecter autrement.

## Conclusion

Les design system c'est bien. Permettant d'harmoniser l'apparence visuelle de votre site, ils ont surtout de nombreux avantages lors du développement d'un site internet : ils facilitent la création de nouvelles pages, rendent plus productive la collaboration développeur / designer et permettent de détecter plus rapidement des régressions dans les composants de votre site.

En Elm, c'est très pratique. Comme tout est pur dans ce langage, sortir un composant pour le rendre réutilisable est à peu de choses près aussi simple qu'un copier / coller. Et une fois ces composants créés, les grands atouts du langages interviennent également : ils sont faciles à refactorer et simples à faire évoluer puisque le compilateur sera là pour assurer vos arrières.

Cette première expérience de design system en Elm a été pour moi extrêmement positive ! Ce n'était ni mon premier projet Elm, ni mon premier design system, mais la combinaison des deux s'est révélée extrêmement productive. Si cet article a réussi à vous convaincre, c'est à vous de jouer maintenant !
