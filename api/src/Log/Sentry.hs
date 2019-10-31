module Log.Sentry where

import           Network.Wai.Handler.Warp               as Warp

import           Config
import           Control.Exception
import           Data.ByteString.Char8                  as BS
import           Network.Wai
import           System.Log.Raven
import           System.Log.Raven.Transport.HttpConduit
import           System.Log.Raven.Types

formatMessage :: Maybe Request -> SomeException -> String
formatMessage Nothing exception        = "Exception before request could be parsed: " ++ show exception
formatMessage (Just request) exception = "Exception " ++ show exception ++ " while handling request " ++ show request

recordUpdate :: Maybe Request -> SomeException -> SentryRecord -> SentryRecord
recordUpdate Nothing _ record        = record
recordUpdate (Just request) _ record = record
    { srCulprit = Just $ BS.unpack $ rawPathInfo request
    , srServerName = BS.unpack <$> requestHeaderHost request
    }

sentryOnException :: SentryConfig -> Maybe Request -> SomeException -> IO ()
sentryOnException sentryConfig mRequest exception = do
    sentryService <- initRaven
        (appUrl sentryConfig)
        id
        sendRecord
        silentFallback

    register
        sentryService
        "Ethogram Sentry Error Logger"
        Error
        (formatMessage mRequest exception)
        (recordUpdate mRequest exception)

    defaultOnException mRequest exception

