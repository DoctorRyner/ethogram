{-# OPTIONS_GHC -Wno-unused-do-bind #-}

module DB.Init where

import           Config
import           Control.Exception          (bracket)
import           Data.ByteString
import           Data.Pool
import           Database.PostgreSQL.Simple
import           DB.Config

initConnectionPool :: ByteString -> IO (Pool Connection)
initConnectionPool connStr = createPool (connectPostgreSQL connStr) close
     2 -- stripes
     60 -- unused connections are kept open for a minute
     10 -- max. 10 connections open per stripe

initDB :: ByteString -> IO ()
initDB connstr = bracket (connectPostgreSQL connstr) close $ \conn -> do
  execute_ conn
    "CREATE TABLE IF NOT EXISTS messages (msg text not null)"
  return ()

runInitDB :: PostgreSQLConfig -> IO ()
runInitDB psqlConfig = initDB $ settings psqlConfig
