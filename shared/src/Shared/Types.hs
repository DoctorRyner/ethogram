{-# LANGUAGE CPP #-}

module Shared.Types where

import           Data.Aeson
import           Data.Generics.Internal.VL.Lens ()
import           GHC.Generics
import           Miso.SPA                       ()
import           Miso.String

#ifndef ghcjs_HOST_OS
import           Data.Swagger

instance ToSchema User
#endif

instance ToJSON User
instance FromJSON User

data User = User
    { name
    , password :: MisoString
    } deriving Generic
