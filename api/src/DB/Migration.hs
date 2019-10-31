{-# LANGUAGE QuasiQuotes #-}

module DB.Migration where

import           Data.ByteString
import           Database.PostgreSQL.Simple.Migration
import           Text.InterpolatedString.QM

migration :: [MigrationCommand]
migration =
    [ MigrationInitialization
    , "Init" # [qm|"CREATE TABLE IF NOT EXISTS messages (msg text not null);"|]
    ]

(#) :: ScriptName -> ByteString -> MigrationCommand
(#) = MigrationScript
