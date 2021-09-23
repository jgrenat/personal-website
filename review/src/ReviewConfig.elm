module ReviewConfig exposing (config)

{-| Do not rename the ReviewConfig module or the config function, because
`elm-review` will look for these.

To add packages that contain rules, add them to this review project using

    `elm install author/packagename`

when inside the directory containing this file.

-}

import NoAlways
import NoBooleanCase
import NoDebug.Log
import NoDebug.TodoOrToString
import NoExposingEverything
import NoImportingEverything
import NoMissingTypeAnnotation
import NoMissingTypeAnnotationInLetIn
import NoPrematureLetComputation
import NoUnused.Dependencies
import NoUnused.Modules
import NoUnused.Patterns
import NoUnused.Variables
import Review.Rule as Rule exposing (Rule)


config : List Rule
config =
    [ NoAlways.rule
    , NoBooleanCase.rule
    , NoDebug.Log.rule
    , NoDebug.TodoOrToString.rule
    , NoExposingEverything.rule
    , NoImportingEverything.rule []
    , NoMissingTypeAnnotation.rule
    , NoMissingTypeAnnotationInLetIn.rule
    , NoPrematureLetComputation.rule
    , NoUnused.Dependencies.rule
    , NoUnused.Modules.rule
    , NoUnused.Patterns.rule
    , NoUnused.Variables.rule
    ]
        |> List.map (Rule.ignoreErrorsForDirectories [ "src/Datocms/", ".elm-pages/" ])
