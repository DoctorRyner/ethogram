module DB.SimpleResult
    ( module DB.SimpleResult
    , module DB.Hasql
    , module Hasql.Decoders
    , module Hasql.Session
    , module Hasql.Statement
    ) where

import           Control.Monad.IO.Class
import qualified Data.Aeson             as Aeson
import qualified Data.ByteString        as BS
import           Data.Foldable          (Foldable, foldl')
import           DB.Hasql
import           Hasql.Decoders         hiding (listArray)
import qualified Hasql.Encoders         as E
import           Hasql.Session
import           Hasql.Statement
import           Types

resToJson :: MonadIO m => Aeson.FromJSON a => Aeson.Value -> m a
resToJson res = case Aeson.fromJSON res of
    Aeson.Success a -> pure a
    Aeson.Error e   -> fail $ show e

jsonListD :: Result [Aeson.Value]
jsonListD = rowList $ column $ nonNullable jsonb

jsonSingleD :: Result Aeson.Value
jsonSingleD = singleRow $ column $ nonNullable jsonb

jsonListE :: E.Params [Aeson.Value]
jsonListE = E.param $ E.nonNullable $ arrayE E.jsonb

jsonSingleE :: E.Params Aeson.Value
jsonSingleE = E.param $ E.nonNullable E.jsonb

arrayE :: Foldable f => E.Value a -> E.Value (f a)
arrayE = E.array . E.dimension foldl' . E.element . E.nonNullable

query' :: BS.ByteString -> Result b -> Session b
query' sqlCode decoder = statement () $ Statement sqlCode mempty decoder True

query :: BS.ByteString -> Result a -> AppM a
query sqlCode decoder = either (fail . show) pure =<< db (query' sqlCode decoder)

queryParams :: BS.ByteString -> a -> E.Params a -> Result b -> AppM b
queryParams sqlCode val encoder decoder =
    either (fail . show) pure =<< db (statement val $ Statement sqlCode encoder decoder True)
