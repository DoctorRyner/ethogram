module View.NotFound where

-- import           Miso.SPA    hiding (View, text)
import           Miso.Styled
import           Types

render :: Model -> View Event
render _ = text "404 page"
