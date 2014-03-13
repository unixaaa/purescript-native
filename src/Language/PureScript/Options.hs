-----------------------------------------------------------------------------
--
-- Module      :  Language.PureScript.Options
-- Copyright   :  (c) Phil Freeman 2013
-- License     :  MIT
--
-- Maintainer  :  Phil Freeman <paf31@cantab.net>
-- Stability   :  experimental
-- Portability :
--
-- |
-- The data type of compiler options
--
-----------------------------------------------------------------------------

module Language.PureScript.Options where

-- |
-- The data type of compiler options
--
data Options = Options {
    -- |
    -- Perform tail-call elimination
    --
    optionsTco :: Bool
    -- |
    -- Perform type checks at runtime
    --
  , optionsPerformRuntimeTypeChecks :: Bool
    -- |
    -- Inline calls to ret and bind for the Eff monad
    --
  , optionsMagicDo :: Bool
    -- |
    -- When specified, checks the type of `main` in the module, and generate a call to run main
    -- after the module definitions.
    --
  , optionsMain :: Maybe String
    -- |
    -- Skip all optimizations
    --
  , optionsNoOptimizations :: Bool
    -- |
    -- Specify the namespace that PureScript modules will be exported to when running in the
    -- browser.
    --
  , optionsBrowserNamespace :: String
    -- |
    -- The modules to keep while enabling dead code elimination
    --
  , optionsModules :: [String]
    -- |
    -- The modules to code gen
    --
  , optionsCodeGenModules :: [String]
  } deriving Show

-- |
-- Default compiler options
--
defaultOptions :: Options
defaultOptions = Options False False False Nothing False "PS" [] []
