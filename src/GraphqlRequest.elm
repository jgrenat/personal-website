module GraphqlRequest exposing (staticGraphqlRequest)

import DataSource exposing (DataSource)
import DataSource.Http as Http
import Graphql.Document
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Encode as Encode
import Pages.Secrets as Secrets


staticGraphqlRequest : SelectionSet value RootQuery -> DataSource value
staticGraphqlRequest selectionSet =
    Http.unoptimizedRequest
        (Secrets.succeed
            (\datocmsToken ->
                { url = "https://graphql.datocms.com/"
                , method = "POST"
                , headers = [ ( "Authorization", "Bearer " ++ datocmsToken ) ]
                , body =
                    Http.jsonBody
                        (Encode.object
                            [ ( "query"
                              , selectionSet
                                    |> Graphql.Document.serializeQuery
                                    |> Encode.string
                              )
                            ]
                        )
                }
            )
            |> Secrets.with "DATOCMS_TOKEN"
        )
        (selectionSet
            |> Graphql.Document.decoder
            |> Http.expectUnoptimizedJson
        )
