module Types where

import           Data.Generics.Labels ()
import           GHC.Generics
import           Miso.SPA

data Event
    = NoEvent
    | Init
    | HandleURI URI
    | ChangeURI URI
    | ReqLocale
    | ResLocale (Response Locale)

data Model = Model
    { uri    :: URI
    , locale :: Locale
    } deriving (Show, Eq, Generic)

defaultModel :: Model
defaultModel = Model
    { uri    = URI "" Nothing "" "" ""
    , locale = mempty
    }
