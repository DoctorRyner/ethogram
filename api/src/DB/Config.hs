module DB.Config where

import           Config
import           Data.ByteString
import           Database.PostgreSQL.Simple

settings :: PostgreSQLConfig -> ByteString
settings psqlConfig = postgreSQLConnectionString $ defaultConnectInfo
    { connectUser     = username psqlConfig
    , connectDatabase = dbname   psqlConfig
    , connectPassword = password psqlConfig
    }

