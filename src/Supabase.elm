module Supabase exposing (createComment, retrieveComments)

import Comments exposing (Comment, NewComment, decoder)
import Datocms.Scalar exposing (ItemId(..))
import Http
import Json.Decode as Decode


supabaseToken : String
supabaseToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzMzY3ODIzOCwiZXhwIjoxOTQ5MjU0MjM4fQ.ZPWzEanHEI9p2WVwqOZSoMuyQqP1Lf16ZfkoGv24JnM"


retrieveComments : (Result Http.Error (List Comment) -> msg) -> ItemId -> Cmd msg
retrieveComments toMsg (ItemId articleId) =
    Http.request
        { method = "GET"
        , headers = [ Http.header "apikey" supabaseToken ]
        , url = "https://bwwglcprakfsvitaikjv.supabase.co/rest/v1/comments?article_id=eq." ++ articleId
        , body = Http.emptyBody
        , expect = Http.expectJson toMsg (Decode.list Comments.decoder)
        , timeout = Nothing
        , tracker = Nothing
        }


createComment : (Result Http.Error () -> msg) -> ItemId -> NewComment -> Cmd msg
createComment toMsg articleId newComment =
    Http.request
        { method = "POST"
        , headers = [ Http.header "apikey" supabaseToken, Http.header "Prefer" "return=representation" ]
        , url = "https://bwwglcprakfsvitaikjv.supabase.co/rest/v1/comments"
        , body = Http.jsonBody (Comments.encodeNewComment articleId newComment)
        , expect = Http.expectWhatever toMsg
        , timeout = Nothing
        , tracker = Nothing
        }
