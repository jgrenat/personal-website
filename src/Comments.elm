module Comments exposing (Comment, Form, NewComment, decoder, emptyForm, encodeNewComment, styles, view, viewForm)

import Css exposing (alignItems, backgroundColor, block, border, borderBottom3, borderRadius, color, cursor, display, displayFlex, flexEnd, fontSize, fontStyle, height, italic, justifyContent, marginBottom, marginTop, maxWidth, padding, paddingBottom, pct, pointer, px, rem, rgb, scale, solid, spaceBetween, transform, width, zero)
import Css.Global as Global exposing (Snippet)
import Css.Transitions as Transitions exposing (transition)
import DateHelper
import Datocms.Scalar exposing (ItemId(..))
import Html.Styled exposing (Html, button, div, form, label, li, text, textarea, ul)
import Html.Styled.Attributes exposing (class, name, type_)
import Html.Styled.Events exposing (onInput, onSubmit)
import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import String.Extra as String
import Time exposing (Posix)


type alias Comment =
    { author : Author
    , content : String
    , publishedAt : Posix
    }


type Author
    = Logged String
    | Anonymous


type alias NewComment =
    { comment : String }


type Form
    = Form { comment : String }


emptyForm : Form
emptyForm =
    Form { comment = "" }


view : Time.Zone -> List Comment -> Html msg
view zone comments =
    List.map (viewComment zone) comments
        |> ul [ class "comments-component" ]


viewComment : Time.Zone -> Comment -> Html msg
viewComment zone comment =
    li [ class "comment" ]
        [ div [ class "comment-header" ]
            [ div [ class "comment-author" ] [ text (authorName comment.author) ]
            , DateHelper.toHtml [ class "comment-date" ] zone comment.publishedAt
            ]
        , div [ class "comment-content" ] [ text comment.content ]
        ]


viewForm : (Result () NewComment -> msg) -> (Form -> msg) -> Form -> Html msg
viewForm toOnSubmitMsg onFormChange (Form { comment }) =
    form
        [ class "comments-form-component"
        , parseForm (Form { comment = comment }) |> toOnSubmitMsg |> onSubmit
        ]
        [ label [ class "label" ]
            [ text "Your comment"
            , textarea [ name "comment", class "textarea", onInput (\value -> onFormChange (Form { comment = value })) ] [ text comment ]
            ]
        , button [ class "button", type_ "submit" ]
            [ text "Comment the article"
            ]
        ]


parseForm : Form -> Result () NewComment
parseForm (Form form) =
    if String.isBlank form.comment then
        Err ()

    else
        Ok (NewComment form.comment)


authorName : Author -> String
authorName author =
    case author of
        Logged username ->
            username

        Anonymous ->
            "Anonymous"


decoder : Decoder Comment
decoder =
    Decode.map3 Comment
        (Decode.succeed Anonymous)
        (Decode.field "comment" Decode.string)
        (Decode.field "created_at" Iso8601.decoder)


encodeNewComment : ItemId -> NewComment -> Encode.Value
encodeNewComment (ItemId articleId) newComment =
    Encode.object <|
        [ ( "article_id", Encode.string articleId )
        , ( "comment", Encode.string newComment.comment )
        ]


styles : List Snippet
styles =
    [ Global.class "comments-component"
        [ Global.descendants
            [ Global.class "comment"
                [ borderBottom3 (px 1) solid (rgb 40 161 78)
                , paddingBottom (rem 0.5)
                , Global.adjacentSiblings
                    [ Global.class "comment"
                        [ marginTop (rem 1) ]
                    ]
                , Global.descendants
                    [ Global.class "comment-header"
                        [ displayFlex
                        , justifyContent spaceBetween
                        , alignItems flexEnd
                        ]
                    , Global.class "comment-author"
                        [ fontSize (rem 0.9)
                        , marginBottom (rem 0.2)
                        ]
                    , Global.class "comment-date"
                        [ fontSize (rem 0.8)
                        , marginBottom (rem 0.2)
                        , fontStyle italic
                        ]
                    ]
                ]
            ]
        ]
    , Global.class "comments-form-component"
        [ Global.descendants
            [ Global.class "input"
                [ display block
                , maxWidth (pct 100)
                , width (rem 15)
                , padding (rem 0.5)
                , marginTop (rem 0.3)
                ]
            , Global.class "textarea"
                [ display block
                , maxWidth (pct 100)
                , width (rem 30)
                , height (rem 8)
                , padding (rem 0.5)
                , marginTop (rem 0.3)
                ]
            , Global.class "label"
                [ display block
                , marginBottom (rem 1)
                ]
            , Global.class "button"
                [ padding (rem 1)
                , fontSize (rem 1.2)
                , cursor pointer
                , backgroundColor (rgb 40 161 78)
                , border zero
                , color (rgb 255 255 255)
                , borderRadius (px 3)
                , Css.hover
                    [ transform (scale 1.05)
                    , Css.property "transform-origin" "center left"
                    , transition [ Transitions.transform 100 ]
                    ]
                ]
            ]
        ]
    ]
