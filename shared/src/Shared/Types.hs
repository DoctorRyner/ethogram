{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Shared.Types where

import           Data.Aeson
import           Data.Text
import           GHC.Generics
import           Miso.String

data User = User
    { username
    , password :: Text
    , avatar   :: Maybe Text
    } deriving Generic

instance ToJSON User
instance FromJSON User
