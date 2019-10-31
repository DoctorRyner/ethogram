module View.Root where

-- import           Miso.SPA    hiding (View, text)
import           Miso.Styled
import           Types

render :: Model -> View Event
render _ = text "/"
