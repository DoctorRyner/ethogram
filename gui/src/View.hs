{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module View where

import           Miso.SPA      hiding (View, text)
import           Miso.Styled
import           Types
import           View.NotFound
import           View.Root

view :: Model -> View Event
view model = wrapper []
    [ linkCss "/normalize.css"
    , route
    ]
  where
    wrapper = styled "div" mempty
    route = case router model.uri of
        Root -> View.Root.render model
        _    -> View.NotFound.render model


