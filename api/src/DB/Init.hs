{-# OPTIONS_GHC -Wno-unused-do-bind #-}

module DB.Init where

import           Config
import           Control.Exception                    (bracket)
import           Data.ByteString
import           Data.Pool
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.Migration
import           DB.Config
import           DB.Migration

initConnectionPool :: ByteString -> IO (Pool Connection)
initConnectionPool connStr = createPool (connectPostgreSQL connStr) close
     2 -- stripes
     60 -- unused connections are kept open for a minute
     10 -- max. 10 connections open per stripe

initDB :: ByteString -> IO ()
initDB connstr = bracket (connectPostgreSQL connstr) close $ \conn -> do
    withTransaction conn $ runMigration $ MigrationContext (MigrationCommands migration) True conn
    pure ()

runInitDB :: PostgreSQLConfig -> IO ()
runInitDB psqlConfig = initDB $ settings psqlConfig

