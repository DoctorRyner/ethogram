-- {-# LANGUAGE QuasiQuotes #-}

module DB.Migration where

import           Data.ByteString
import           Database.PostgreSQL.Simple.Migration
--import           Text.InterpolatedString.QM

table :: ByteString -> ByteString
table = ("CREATE TABLE IF NOT EXISTS " <>) . (<> " (data jsonb);")

tableCustom :: ByteString -> ByteString
tableCustom = ("CREATE TABLE IF NOT EXISTS " <>) . (<> ";")

migration :: [MigrationCommand]
migration =
    [ MigrationInitialization
    , "Users" # table "users"
    ]

(#) :: ScriptName -> ByteString -> MigrationCommand
(#) = MigrationScript
