module Page.Blog.Slug_ exposing (Data, Model, Msg, page)

import Article exposing (Article, Attribution)
import Browser.Navigation as Navigation
import Comments exposing (Comment, NewComment)
import Css exposing (absolute, alignItems, center, color, displayFlex, fontSize, fontStyle, fontWeight, height, int, italic, justify, justifyContent, left, lineHeight, margin3, marginBottom, marginRight, marginTop, none, paddingTop, pct, position, px, relative, rem, rgba, scale, spaceBetween, textAlign, textDecoration, top, transform, vh, width, zero)
import Css.Global as Global exposing (Snippet, global)
import Css.Transitions as Transition exposing (transition)
import DataSource exposing (DataSource)
import Datocms.Enum.ImgixParamsCrop exposing (ImgixParamsCrop(..))
import Datocms.Enum.ImgixParamsFit exposing (ImgixParamsFit(..))
import Datocms.Enum.SiteLocale as SiteLocale
import Datocms.InputObject exposing (ArticleModelFilter, buildArticleModelFilter, buildImgixParams, buildSlugFilter)
import Datocms.Object exposing (ArticleModelContentField, ArticleRecord, BannerAttributionRecord, FileField, HomePageRecord, ImageContentRecord)
import Datocms.Object.ArticleModelContentField as ArticleModelContentField
import Datocms.Object.ArticleRecord as ArticleRecord
import Datocms.Object.BannerAttributionRecord as BannerAttributionRecord
import Datocms.Object.FileField as FileField
import Datocms.Object.HomePageRecord as HomePageRecord
import Datocms.Object.ImageContentRecord as ImageContentRecord
import Datocms.Query as Query
import Datocms.Scalar exposing (BooleanType(..), FloatType(..), IntType(..), ItemId(..))
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import GraphqlRequest exposing (staticGraphqlRequest)
import Head
import Head.Seo as Seo
import Html.Styled exposing (Html, a, aside, div, em, figcaption, figure, h1, img, p, section, text)
import Html.Styled.Attributes exposing (alt, attribute, class, href, src, target)
import HtmlHelper exposing (link)
import Http
import Json.Decode as Decode
import Maybe.Extra as Maybe
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Ports
import Route exposing (Route(..))
import ScalarCodecs exposing (StructuredTextField(..))
import Shared
import String.Extra as String
import StructuredText exposing (StructuredText)
import StructuredText.Decode
import StructuredTextHelper exposing (ImageSize(..), StructuredTextBlock(..), structuredText)
import Supabase
import Time
import View exposing (View, userContentStyles)


type alias Model =
    { comments : CommentsList, commentForm : Comments.Form }


type CommentsList
    = Loading
    | Loaded (List Comment)
    | OnError


type Msg
    = CommentsRetrieved (Result Http.Error (List Comment))
    | SubmitNewComment (Result () NewComment)
    | CommentCreated (Result Http.Error ())
    | CommentFormChanged Comments.Form


type alias RouteParams =
    { slug : String
    }


type alias Data =
    { author : Author
    , article : Article
    }


type alias Author =
    { picture : String, description : String }


page : PageWithState RouteParams Data Model Msg
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildWithLocalState
            { view = view
            , init =
                \_ _ static ->
                    ( { comments = Loading, commentForm = Comments.emptyForm }
                    , Cmd.batch [ Ports.highlightCode (), Supabase.retrieveComments CommentsRetrieved static.data.article.id ]
                    )
            , update = update
            , subscriptions = \_ _ _ _ -> Sub.none
            }


update : PageUrl -> Maybe Navigation.Key -> Shared.Model -> StaticPayload Data RouteParams -> Msg -> Model -> ( Model, Cmd Msg )
update _ _ _ static msg model =
    case msg of
        CommentsRetrieved (Ok comments) ->
            ( { model | comments = Loaded comments }, Cmd.none )

        CommentsRetrieved (Err _) ->
            ( { model | comments = OnError }, Cmd.none )

        SubmitNewComment (Ok newComment) ->
            ( model, Supabase.createComment CommentCreated static.data.article.id newComment )

        SubmitNewComment (Err ()) ->
            ( model, Cmd.none )

        CommentCreated (Ok _) ->
            ( { model | commentForm = Comments.emptyForm }, Supabase.retrieveComments CommentsRetrieved static.data.article.id )

        CommentCreated (Err _) ->
            ( model, Cmd.none )

        CommentFormChanged newForm ->
            ( { model | commentForm = newForm }, Cmd.none )


articleRoutesSelection : SelectionSet String ArticleRecord
articleRoutesSelection =
    ArticleRecord.slug (\params -> { params | locale = Present SiteLocale.Fr })
        |> SelectionSet.nonNullOrFail


routes : DataSource (List RouteParams)
routes =
    Query.allArticles identity articleRoutesSelection
        |> staticGraphqlRequest
        |> DataSource.map (List.map RouteParams)


data : RouteParams -> DataSource Data
data routeParams =
    SelectionSet.map2 Data authorSelection (articleQuery routeParams.slug)
        |> staticGraphqlRequest


articleQuery : String -> SelectionSet Article RootQuery
articleQuery slug =
    Query.article (\args -> { args | filter = Present (articleFilters slug) })
        articleSelection
        |> SelectionSet.nonNullOrFail


authorSelection : SelectionSet Author RootQuery
authorSelection =
    SelectionSet.map2 Author
        (HomePageRecord.picture pictureSelection |> SelectionSet.nonNullOrFail)
        (HomePageRecord.introductionText identity |> SelectionSet.nonNullOrFail)
        |> Query.homePage identity
        |> SelectionSet.nonNullOrFail


pictureSelection : SelectionSet String FileField
pictureSelection =
    FileField.url
        (\params -> { params | imgixParams = Present authorImgixParams })


authorImgixParams : Datocms.InputObject.ImgixParams
authorImgixParams =
    buildImgixParams
        (\params ->
            { params
                | w = Present (FloatType "80")
                , h = Present (FloatType "80")
                , mask = Present "ellipse"
                , fit = Present Crop
                , crop = Present [ Focalpoint, Faces, Entropy ]
            }
        )


articleFilters : String -> ArticleModelFilter
articleFilters slug =
    buildArticleModelFilter
        (\params ->
            { params
                | slug = Present (buildSlugFilter (\slugFilter -> { slugFilter | eq = Present slug }))
            }
        )


articleSelection : SelectionSet Article ArticleRecord
articleSelection =
    SelectionSet.map6 Article
        ArticleRecord.id
        (ArticleRecord.name (\args -> { args | locale = Present SiteLocale.Fr }) |> SelectionSet.nonNullOrFail)
        (ArticleRecord.banner bannerSelection
            |> SelectionSet.nonNullOrFail
        )
        (ArticleRecord.content
            (\args ->
                { args | locale = Present SiteLocale.Fr }
            )
            contentSelection
            |> SelectionSet.nonNullOrFail
        )
        (ArticleRecord.description identity |> SelectionSet.nonNullOrFail)
        (ArticleRecord.bannerAttribution identity bannerAttributionSelection
            |> SelectionSet.withDefault []
            |> SelectionSet.map (List.filterMap identity)
            |> SelectionSet.map List.head
        )


bannerAttributionSelection : SelectionSet Attribution BannerAttributionRecord
bannerAttributionSelection =
    SelectionSet.map3 Attribution
        (BannerAttributionRecord.author |> SelectionSet.nonNullOrFail)
        (BannerAttributionRecord.licenseName |> SelectionSet.map (Maybe.filter (not << String.isBlank)))
        (BannerAttributionRecord.licenseLink |> SelectionSet.map (Maybe.filter (not << String.isBlank)))


bannerSelection : SelectionSet Article.Banner Datocms.Object.FileField
bannerSelection =
    SelectionSet.map Article.Banner (FileField.url (\params -> { params | imgixParams = Present imgixParams }))


imgixParams : Datocms.InputObject.ImgixParams
imgixParams =
    buildImgixParams
        (\params ->
            { params
                | maxW = Present (IntType "800")
                , maxH = Present (IntType "250")
                , fit = Present Crop
            }
        )


decodeStructuredTextField : StructuredTextField -> List ( StructuredText.ItemId, StructuredTextBlock ) -> List ( StructuredText.ItemId, StructuredTextBlock ) -> Result String (StructuredText StructuredTextBlock)
decodeStructuredTextField (StructuredTextField value) blockItems linkItems =
    Decode.decodeValue (StructuredText.Decode.decoder (blockItems ++ linkItems)) value
        |> Result.mapError (\error -> "Cannot decode structured text document:" ++ Decode.errorToString error)


contentSelection : SelectionSet (StructuredText StructuredTextBlock) ArticleModelContentField
contentSelection =
    SelectionSet.map3 decodeStructuredTextField
        ArticleModelContentField.value
        (ArticleModelContentField.blocks articleBlockSelection)
        (ArticleModelContentField.links articleLinkSelection)
        |> SelectionSet.mapOrFail identity


articleBlockSelection : SelectionSet ( StructuredText.ItemId, StructuredTextBlock ) ImageContentRecord
articleBlockSelection =
    SelectionSet.map2 Tuple.pair
        (ImageContentRecord.id |> SelectionSet.map (\(ItemId id) -> StructuredText.itemId id))
        (SelectionSet.map3 StructuredTextHelper.ImageContentRaw
            (ImageContentRecord.image (FileField.url identity) |> SelectionSet.nonNullOrFail)
            (ImageContentRecord.image (FileField.alt identity) |> SelectionSet.nonNullOrFail)
            (ImageContentRecord.fullWidth
                |> SelectionSet.nonNullOrFail
                |> SelectionSet.map
                    (\(BooleanType isFullWidth) ->
                        if isFullWidth == "true" then
                            FullWidth

                        else
                            Normal
                    )
            )
            |> SelectionSet.map ImageContent
        )


articleLinkSelection : SelectionSet ( StructuredText.ItemId, StructuredTextBlock ) ArticleRecord
articleLinkSelection =
    SelectionSet.map2 Tuple.pair
        (ArticleRecord.id |> SelectionSet.map (\(ItemId id) -> StructuredText.itemId id))
        (SelectionSet.map2 StructuredTextHelper.ArticleLinkRaw
            (ArticleRecord.name identity |> SelectionSet.nonNullOrFail)
            (ArticleRecord.slug identity |> SelectionSet.nonNullOrFail)
            |> SelectionSet.map ArticleLink
        )


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = static.sharedData.websiteName
        , image =
            { url = Pages.Url.external static.data.article.banner.src
            , alt = static.data.article.name
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = static.data.article.description
        , locale = Nothing
        , title = static.data.article.name
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel model static =
    { title = static.data.article.name ++ " - " ++ static.sharedData.websiteName
    , body =
        [ global (styles ++ Comments.styles)
        , div [ class "site-title" ]
            [ link Index [ class "site-name" ] [ text static.sharedData.websiteName ]
            , a [ href "https://twitter.com/JoGrenat" ]
                [ img [ src static.sharedData.twitterIconLink ] []
                ]
            ]
        , section [ class "article" ]
            [ h1 [ class "article-title" ] [ text static.data.article.name ]
            , viewBanner static.data.article
            , structuredText [ class "article-content" ] static.data.article.content
            ]
        , aside [ class "author-card" ]
            [ img [ class "author-picture", src static.data.author.picture ] []
            , p [ class "author-description" ] [ text static.data.author.description ]
            ]
        , section [ class "article-comments" ]
            [ Comments.view (sharedModel.timeZone |> Maybe.withDefault Time.utc)
                (case model.comments of
                    Loading ->
                        []

                    Loaded comments ->
                        comments

                    OnError ->
                        []
                )
            , div [ class "article-comments-form" ]
                [ Comments.viewForm SubmitNewComment CommentFormChanged model.commentForm
                ]
            ]
        ]
    }


viewBanner : Article -> Html msg
viewBanner article =
    figure
        [ class "article-banner"
        , attribute "aria-hidden" "true"
        , (if article.bannerAttribution == Nothing then
            ""

           else
            "article-banner--withAttribution"
          )
            |> class
        ]
        [ img [ src article.banner.src, alt "" ] []
        , case article.bannerAttribution of
            Nothing ->
                text ""

            Just attribution ->
                figcaption []
                    ([ text "Image by "
                     , em [] [ text attribution.author ]
                     ]
                        ++ (case ( attribution.licenseName, attribution.licenseLink ) of
                                ( Nothing, _ ) ->
                                    []

                                ( Just licenseName, Nothing ) ->
                                    [ text (" under the " ++ licenseName ++ " license") ]

                                ( Just licenseName, Just licenseLink ) ->
                                    [ text " under the "
                                    , a [ href licenseLink, target "_blank" ] [ text licenseName ]
                                    , text " license"
                                    ]
                           )
                    )
        ]


styles : List Snippet
styles =
    [ Global.class "site-title"
        [ displayFlex
        , justifyContent spaceBetween
        , alignItems center
        , fontSize (rem 1.5)
        , margin3 (rem 0.5) zero (rem 2)
        , Global.descendants
            [ Global.a [ textDecoration none ]
            , Global.img
                [ width (rem 2)
                , transition [ Transition.transform 100 ]
                , Css.hover
                    [ transform (scale 1.5)
                    ]
                ]
            , Global.class "site-name"
                [ transition [ Transition.transform 100 ]
                , Css.property "transform-origin" "center left"
                , Css.hover
                    [ transform (scale 1.1)
                    ]
                ]
            ]
        ]
    , Global.class "article"
        [ marginTop (px 20)
        , Global.descendants
            [ Global.class "article-title"
                [ fontSize (rem 3)
                , textAlign center
                , marginBottom (rem 3)
                , fontWeight (int 900)
                ]
            , Global.class "article-banner"
                [ width (pct 100)
                , paddingTop (pct (250 / 800 * 100))
                , position relative
                , Global.descendants
                    [ Global.img
                        [ position absolute, top zero, left zero, width (pct 100), height (pct 100) ]
                    ]
                , Global.withClass "article-banner--withAttribution"
                    [ marginBottom (rem 4)
                    , Global.descendants
                        [ Global.selector "figcaption"
                            [ position absolute
                            , top (pct 103)
                            , left zero
                            , width (pct 100)
                            , textAlign center
                            , fontSize (rem 0.8)
                            , color (rgba 0 0 0 0.7)
                            , Global.descendants
                                [ Global.em
                                    [ fontStyle italic
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            , Global.class "article-content" (marginBottom (vh 5) :: userContentStyles)
            ]
        ]
    , Global.class "author-card"
        [ displayFlex
        , alignItems center
        , marginTop (rem 2.5)
        , Global.children
            [ Global.class "author-picture"
                [ marginRight (rem 1)
                ]
            , Global.class "author-description"
                [ textAlign justify
                , fontSize (rem 1)
                , lineHeight (rem 1.5)
                ]
            ]
        ]
    , Global.class "article-comments"
        [ marginTop (rem 3)
        ]
    , Global.class "article-comments-form"
        [ marginTop (rem 2)
        ]
    ]
