-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Datocms.Enum.ArticleModelOrderBy exposing (..)

import Json.Decode as Decode exposing (Decoder)


type ArticleModelOrderBy
    = CreatedAt_ASC_
    | CreatedAt_DESC_
    | CreatedAt_ASC
    | CreatedAt_DESC
    | Id_ASC
    | Id_DESC
    | FirstPublishedAt_ASC_
    | FirstPublishedAt_DESC_
    | PublicationScheduledAt_ASC_
    | PublicationScheduledAt_DESC_
    | UnpublishingScheduledAt_ASC_
    | UnpublishingScheduledAt_DESC_
    | PublishedAt_ASC_
    | PublishedAt_DESC_
    | Status_ASC_
    | Status_DESC_
    | UpdatedAt_ASC_
    | UpdatedAt_DESC_
    | UpdatedAt_ASC
    | UpdatedAt_DESC
    | IsValid_ASC_
    | IsValid_DESC_
    | Name_ASC
    | Name_DESC


list : List ArticleModelOrderBy
list =
    [ CreatedAt_ASC_, CreatedAt_DESC_, CreatedAt_ASC, CreatedAt_DESC, Id_ASC, Id_DESC, FirstPublishedAt_ASC_, FirstPublishedAt_DESC_, PublicationScheduledAt_ASC_, PublicationScheduledAt_DESC_, UnpublishingScheduledAt_ASC_, UnpublishingScheduledAt_DESC_, PublishedAt_ASC_, PublishedAt_DESC_, Status_ASC_, Status_DESC_, UpdatedAt_ASC_, UpdatedAt_DESC_, UpdatedAt_ASC, UpdatedAt_DESC, IsValid_ASC_, IsValid_DESC_, Name_ASC, Name_DESC ]


decoder : Decoder ArticleModelOrderBy
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "_createdAt_ASC" ->
                        Decode.succeed CreatedAt_ASC_

                    "_createdAt_DESC" ->
                        Decode.succeed CreatedAt_DESC_

                    "createdAt_ASC" ->
                        Decode.succeed CreatedAt_ASC

                    "createdAt_DESC" ->
                        Decode.succeed CreatedAt_DESC

                    "id_ASC" ->
                        Decode.succeed Id_ASC

                    "id_DESC" ->
                        Decode.succeed Id_DESC

                    "_firstPublishedAt_ASC" ->
                        Decode.succeed FirstPublishedAt_ASC_

                    "_firstPublishedAt_DESC" ->
                        Decode.succeed FirstPublishedAt_DESC_

                    "_publicationScheduledAt_ASC" ->
                        Decode.succeed PublicationScheduledAt_ASC_

                    "_publicationScheduledAt_DESC" ->
                        Decode.succeed PublicationScheduledAt_DESC_

                    "_unpublishingScheduledAt_ASC" ->
                        Decode.succeed UnpublishingScheduledAt_ASC_

                    "_unpublishingScheduledAt_DESC" ->
                        Decode.succeed UnpublishingScheduledAt_DESC_

                    "_publishedAt_ASC" ->
                        Decode.succeed PublishedAt_ASC_

                    "_publishedAt_DESC" ->
                        Decode.succeed PublishedAt_DESC_

                    "_status_ASC" ->
                        Decode.succeed Status_ASC_

                    "_status_DESC" ->
                        Decode.succeed Status_DESC_

                    "_updatedAt_ASC" ->
                        Decode.succeed UpdatedAt_ASC_

                    "_updatedAt_DESC" ->
                        Decode.succeed UpdatedAt_DESC_

                    "updatedAt_ASC" ->
                        Decode.succeed UpdatedAt_ASC

                    "updatedAt_DESC" ->
                        Decode.succeed UpdatedAt_DESC

                    "_isValid_ASC" ->
                        Decode.succeed IsValid_ASC_

                    "_isValid_DESC" ->
                        Decode.succeed IsValid_DESC_

                    "name_ASC" ->
                        Decode.succeed Name_ASC

                    "name_DESC" ->
                        Decode.succeed Name_DESC

                    _ ->
                        Decode.fail ("Invalid ArticleModelOrderBy type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : ArticleModelOrderBy -> String
toString enum____ =
    case enum____ of
        CreatedAt_ASC_ ->
            "_createdAt_ASC"

        CreatedAt_DESC_ ->
            "_createdAt_DESC"

        CreatedAt_ASC ->
            "createdAt_ASC"

        CreatedAt_DESC ->
            "createdAt_DESC"

        Id_ASC ->
            "id_ASC"

        Id_DESC ->
            "id_DESC"

        FirstPublishedAt_ASC_ ->
            "_firstPublishedAt_ASC"

        FirstPublishedAt_DESC_ ->
            "_firstPublishedAt_DESC"

        PublicationScheduledAt_ASC_ ->
            "_publicationScheduledAt_ASC"

        PublicationScheduledAt_DESC_ ->
            "_publicationScheduledAt_DESC"

        UnpublishingScheduledAt_ASC_ ->
            "_unpublishingScheduledAt_ASC"

        UnpublishingScheduledAt_DESC_ ->
            "_unpublishingScheduledAt_DESC"

        PublishedAt_ASC_ ->
            "_publishedAt_ASC"

        PublishedAt_DESC_ ->
            "_publishedAt_DESC"

        Status_ASC_ ->
            "_status_ASC"

        Status_DESC_ ->
            "_status_DESC"

        UpdatedAt_ASC_ ->
            "_updatedAt_ASC"

        UpdatedAt_DESC_ ->
            "_updatedAt_DESC"

        UpdatedAt_ASC ->
            "updatedAt_ASC"

        UpdatedAt_DESC ->
            "updatedAt_DESC"

        IsValid_ASC_ ->
            "_isValid_ASC"

        IsValid_DESC_ ->
            "_isValid_DESC"

        Name_ASC ->
            "name_ASC"

        Name_DESC ->
            "name_DESC"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe ArticleModelOrderBy
fromString enumString____ =
    case enumString____ of
        "_createdAt_ASC" ->
            Just CreatedAt_ASC_

        "_createdAt_DESC" ->
            Just CreatedAt_DESC_

        "createdAt_ASC" ->
            Just CreatedAt_ASC

        "createdAt_DESC" ->
            Just CreatedAt_DESC

        "id_ASC" ->
            Just Id_ASC

        "id_DESC" ->
            Just Id_DESC

        "_firstPublishedAt_ASC" ->
            Just FirstPublishedAt_ASC_

        "_firstPublishedAt_DESC" ->
            Just FirstPublishedAt_DESC_

        "_publicationScheduledAt_ASC" ->
            Just PublicationScheduledAt_ASC_

        "_publicationScheduledAt_DESC" ->
            Just PublicationScheduledAt_DESC_

        "_unpublishingScheduledAt_ASC" ->
            Just UnpublishingScheduledAt_ASC_

        "_unpublishingScheduledAt_DESC" ->
            Just UnpublishingScheduledAt_DESC_

        "_publishedAt_ASC" ->
            Just PublishedAt_ASC_

        "_publishedAt_DESC" ->
            Just PublishedAt_DESC_

        "_status_ASC" ->
            Just Status_ASC_

        "_status_DESC" ->
            Just Status_DESC_

        "_updatedAt_ASC" ->
            Just UpdatedAt_ASC_

        "_updatedAt_DESC" ->
            Just UpdatedAt_DESC_

        "updatedAt_ASC" ->
            Just UpdatedAt_ASC

        "updatedAt_DESC" ->
            Just UpdatedAt_DESC

        "_isValid_ASC" ->
            Just IsValid_ASC_

        "_isValid_DESC" ->
            Just IsValid_DESC_

        "name_ASC" ->
            Just Name_ASC

        "name_DESC" ->
            Just Name_DESC

        _ ->
            Nothing
