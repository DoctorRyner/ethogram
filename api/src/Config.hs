{-# OPTIONS_GHC -Wno-orphans #-}

module Config where

import           Data.ByteString
import           Data.Generics.Labels ()
import           Data.Text.Encoding
import           Data.Time
import           Data.Yaml
import           GHC.Generics

data PostgreSQLConfig = PostgreSQLConfig
    { dbname
    , username
    , password                   :: ByteString
    , poolSize                   :: Int
    , poolConnectionTimeoutInSec :: NominalDiffTime
    } deriving Generic

instance FromJSON ByteString where
    parseJSON = withText "ByteString" $ pure . encodeUtf8
    {-# INLINE parseJSON #-}

instance FromJSON PostgreSQLConfig

newtype Config = Config
    { psql :: PostgreSQLConfig
    } deriving Generic

instance FromJSON Config

load :: IO Config
load = either (error . show) pure =<< decodeFileEither "config/config.yaml"
