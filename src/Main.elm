module Main exposing (main)

import Browser
import Html exposing (..)
-- START:imports
import Html.Attributes
    exposing
        ( class, disabled, placeholder, src, type_, value )
import Html.Events exposing (onClick, onInput, onSubmit)
-- END:imports
import Browser.Events exposing (onKeyDown)
import Json.Decode as Decode

type alias Model =
    { url : String
    , caption : String
    , liked : Bool
    , comments : List String
    , newComment : String
    }


baseUrl : String
baseUrl =
    "https://programming-elm.com/"

keyDecoder : Decode.Decoder Msg
keyDecoder =
  Decode.map toKey (Decode.field "key" Decode.string)

toKey : String -> Msg
toKey keyValue =
  case keyValue of
    "ArrowUp" ->
      ToggleLike
    "ArrowDown" ->
      ToggleLike
    _ ->
      ToggleLike


initialModel : Model
initialModel =
    { url = baseUrl ++ "1.jpg"
    , caption = "Surfing"
    , liked = False
    , comments = [ "Cowabunga, dude!" ]
    , newComment = ""
    }


viewLoveButton : Model -> Html Msg
viewLoveButton model =
    let
        buttonClass =
            if model.liked then
                "fa-heart"

            else
                "fa-heart-o"
    in
    div [ class "like-button" ]
        [ i
            [ class "fa fa-2x"
            , class buttonClass
            , onClick ToggleLike
            ]
            []
        ]


viewComment : String -> Html Msg
viewComment comment =
    li []
        [ strong [] [ text "Comment:" ]
        , text (" " ++ comment)
        ]


viewCommentList : List String -> Html Msg
viewCommentList comments =
    case comments of
        [] ->
            text ""

        _ ->
            div [ class "comments" ]
                [ ul []
                    (List.map viewComment comments)
                ]


viewComments : Model -> Html Msg
-- START:viewComments
viewComments model =
    div []
        [ viewCommentList model.comments
        , form [ class "new-comment", onSubmit SaveComment ] -- (1)
            [ input
                [ type_ "text"
                , placeholder "Add a comment..."
                , value model.newComment -- (2)
                , onInput UpdateComment -- (3)
                ]
                []
            , button
                [ disabled (String.isEmpty model.newComment) ] -- (4)
                [ text "Save" ]
            ]
        ]
-- END:viewComments


viewDetailedPhoto : Model -> Html Msg
viewDetailedPhoto model =
    div [ class "detailed-photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ]
            [ viewLoveButton model
            , h2 [ class "caption" ] [ text model.caption ]
            , viewComments model
            ]
        ]

init : flags -> ( Model, Cmd msg )
init _ =
    ( initialModel, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Picshare" ] ]
        , div [ class "content-flow" ]
            [ viewDetailedPhoto model ]
        ]


-- START:msg
type Msg
    = ToggleLike
    | UpdateComment String
    | SaveComment
-- END:msg


-- START:saveNewComment
saveNewComment : Model -> Model
saveNewComment model =
    let
        comment =
            String.trim model.newComment
    in
    case comment of
        "" ->
            model

        _ ->
            { model
                | comments = model.comments ++ [ comment ]
                , newComment = ""
            }
-- END:saveNewComment


update : Msg -> Model -> ( Model, Cmd Msg )
-- START:update
update msg model =
    case msg of
        ToggleLike ->
            ( { model | liked = not model.liked }, Cmd.none )

        UpdateComment comment ->
            ( { model | newComment = comment }, Cmd.none )

        SaveComment ->
            ( saveNewComment model, Cmd.none )
-- END:update

subscriptions : Model -> Sub Msg
subscriptions _ =
    onKeyDown keyDecoder

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
