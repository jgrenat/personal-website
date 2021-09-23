module YoutubeRequest exposing (Video, getLastVideos)

import DataSource exposing (DataSource)
import DataSource.Http as Http
import OptimizedDecoder exposing (Decoder)
import Pages.Secrets as Secrets
import Regex exposing (Regex)


type alias Video =
    { title : String
    , code : String
    , width : Int
    , height : Int
    , url : String
    }


getLastVideos : DataSource (List Video)
getLastVideos =
    Http.request
        (Secrets.succeed
            (\youtubeApiKey ->
                { url = "https://content-youtube.googleapis.com/youtube/v3/search?type=video&channelId=UCROJRWWGrrTmgGF1Wo9OX5w&key=" ++ youtubeApiKey
                , method = "GET"
                , headers = []
                , body = Http.emptyBody
                }
            )
            |> Secrets.with "YOUTUBE_API_KEY"
        )
        (OptimizedDecoder.field "items" (OptimizedDecoder.list videoDecoder))
        |> DataSource.andThen
            (\videoIds ->
                List.map fetchOembedData videoIds
                    |> DataSource.combine
            )


fetchOembedData : String -> DataSource Video
fetchOembedData videoId =
    Http.get
        (Secrets.succeed
            ("https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=" ++ videoId)
        )
        oembedDataDecoder


videoDecoder : Decoder String
videoDecoder =
    OptimizedDecoder.at [ "id", "videoId" ] OptimizedDecoder.string


oembedDataDecoder : Decoder Video
oembedDataDecoder =
    OptimizedDecoder.map5 Video
        (OptimizedDecoder.field "title" OptimizedDecoder.string)
        (OptimizedDecoder.field "html" codeDecoder)
        (OptimizedDecoder.field "thumbnail_width" OptimizedDecoder.int)
        (OptimizedDecoder.field "thumbnail_height" OptimizedDecoder.int)
        (OptimizedDecoder.field "thumbnail_url" OptimizedDecoder.string)


codeInHtmlRegex : Regex
codeInHtmlRegex =
    Maybe.withDefault Regex.never <|
        Regex.fromString "https://www.youtube.com/embed/([a-zA-Z0-9-]+)\\?feature="


codeDecoder : Decoder String
codeDecoder =
    OptimizedDecoder.string
        |> OptimizedDecoder.andThen
            (\html ->
                Regex.find codeInHtmlRegex html
                    |> List.head
                    |> Maybe.andThen (.submatches >> List.head)
                    |> Maybe.andThen identity
                    |> Maybe.map OptimizedDecoder.succeed
                    |> Maybe.withDefault (OptimizedDecoder.fail "Cannot extract youtube code from HTML")
            )
