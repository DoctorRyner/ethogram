module Cors where

import           Network.Wai
import           Network.Wai.Middleware.Cors

corsWithContentType :: Middleware
corsWithContentType = cors $ const $ Just $ simpleCorsResourcePolicy
    { corsRequestHeaders = ["Content-Type"]
    , corsMethods        = "PUT" : simpleMethods
    }
