{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Types where

import           Miso.SPA

data Event
    = NoEvent
    | Init
    | HandleURI URI
    | ChangeURI URI
    | ReqLocale
    | ResLocale (Response Locale)
    
data Model = Model
    { uri  :: URI
    , locale :: Locale
    } deriving (Show, Eq)

defaultModel :: Model
defaultModel = Model
    { uri  = undefined
    , locale = mempty
    }
