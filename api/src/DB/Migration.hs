module DB.Migration where

import qualified Data.ByteString                      as BS
--import           Text.InterpolatedString.QM
import           Control.Exception
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.Migration

table :: BS.ByteString -> BS.ByteString
table = ("CREATE TABLE IF NOT EXISTS " <>) . (<> " (data jsonb);")

tableCustom :: BS.ByteString -> BS.ByteString
tableCustom = ("CREATE TABLE IF NOT EXISTS " <>) . (<> ";")

migration :: [MigrationCommand]
migration =
    [ MigrationInitialization
    , "Users" # table "users"
    ]

(#) :: ScriptName -> BS.ByteString -> MigrationCommand
(#) = MigrationScript

initDB :: BS.ByteString -> IO ()
initDB connstr = bracket (connectPostgreSQL connstr) close $ \conn -> do
    withTransaction conn $ runMigration $ MigrationContext (MigrationCommands migration) True conn
    pure ()
