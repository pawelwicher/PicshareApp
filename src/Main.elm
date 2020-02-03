module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Browser
import Browser.Events exposing (onKeyDown)
import Json.Decode as Decode

type alias Model =
    { url : String
    , caption : String
    , liked : Bool 
    }

type Msg
    = Like
    | Unlike
    | None

keyDecoder : Decode.Decoder Msg
keyDecoder =
  Decode.map toKey (Decode.field "key" Decode.string)

toKey : String -> Msg
toKey keyValue =
  case keyValue of
    "ArrowUp" ->
      Like
    "ArrowDown" ->
      Unlike
    _ ->
      None

baseUrl : String
baseUrl =
    "https://programming-elm.com/"

initModel : Model
initModel =
    { url = baseUrl ++ "1.jpg"
    , caption = "Surfing"
    , liked = False
    }

viewPhoto : Model -> Html Msg
viewPhoto model =
    let
        buttonClass =
            if model.liked then
                "fa-heart"
            else
                "fa-heart-o"
        msg =
            if model.liked then
                Unlike
            else
                Like
    in
    div [ class "detailed-photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ]
            [ div [ class "like-button" ]
                [ i
                    [ class "fa fa-2x"
                    , class buttonClass
                    , onClick msg
                    ]
                    []
                ]
            , h2 [ class "caption" ] [ text model.caption ]
            ]
        ]

init : flags -> ( Model, Cmd msg )
init _ =
    ( initModel, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Picshare" ] ]
        , div [ class "content-flow" ]
            [ viewPhoto model ]
        ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Like ->
            ( { model | liked = True }, Cmd.none )
        Unlike ->
            ( { model | liked = False }, Cmd.none )
        None ->
            ( model, Cmd.none )

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