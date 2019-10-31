{-# OPTIONS_GHC -F -pgmF=record-dot-preprocessor #-}

module Config where

import           Data.Yaml
import           GHC.Generics

data PostgreSQLConfig = PostgreSQLConfig
    { dbname
    , username
    , password :: String
    } deriving Generic

instance FromJSON PostgreSQLConfig

newtype SentryConfig = SentryConfig
    { appUrl :: String
    } deriving Generic

instance FromJSON SentryConfig

data Config = Config
    { sentry :: SentryConfig
    , psql   :: PostgreSQLConfig
    } deriving Generic

instance FromJSON Config

load :: IO Config
load = either (error . show) pure =<< decodeFileEither "config/config.yaml"
