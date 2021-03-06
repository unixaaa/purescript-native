-----------------------------------------------------------------------------
--
-- Module      :  Language.PureScript.CodeGen.Common
-- Copyright   :  (c) 2013-15 Phil Freeman, Andy Arvanitis, and other contributors
-- License     :  MIT
--
-- Maintainer  :  Andy Arvanitis
-- Stability   :  experimental
-- Portability :
--
-- |
-- Common code generation utility functions
--
-----------------------------------------------------------------------------

{-# LANGUAGE PatternGuards #-}

module Language.PureScript.CodeGen.Cpp.Common where

import Prelude.Compat

import Data.Char
import Data.List (intercalate)

import Language.PureScript.Crash
import Language.PureScript.Names

-- |
-- Convert an Ident into a valid C++11 identifier:
--
--  * Alphanumeric characters are kept unmodified.
--
--  * Reserved C++11 identifiers are wrapped with '_'
--
--  * Symbols are wrapped with '_' between a symbol name or their ordinal value.
--
identToCpp :: Ident -> String
identToCpp (Ident name) | nameIsCppReserved name = '_' : name ++ "_"
identToCpp (Ident name@('$' : s)) | all isDigit s = name
identToCpp (Ident name) = concatMap identCharToString name
identToCpp (GenIdent _ _) = internalError "GenIdent in identToJs"

-- |
-- Test if a string is a valid Cpp identifier without escaping.
--
identNeedsEscaping :: String -> Bool
identNeedsEscaping s = s /= identToCpp (Ident s)

-- |
-- Attempts to find a human-readable name for a symbol, if none has been specified returns the
-- ordinal value.
--
identCharToString :: Char -> String
identCharToString c | isAlphaNum c = [c]
identCharToString '_' = "_"
identCharToString '.' = "_"
identCharToString '\'' = "_prime"
identCharToString c = "$0" ++ show (ord c)

-- |
-- Checks whether an identifier name is reserved in C++11.
--
nameIsCppReserved :: String -> Bool
nameIsCppReserved name =
  name `elem` [ "alignas"
              , "alignof"
              , "and"
              , "and_eq"
              , "any"
              , "asm"
              , "assert"
              , "auto"
              , "bitand"
              , "bitor"
              , "bool"
              , "boost"
              , "break"
              , "case"
              , "cast"
              , "catch"
              , "char"
              , "char16_t"
              , "char32_t"
              , "class"
              , "compl"
              , "concept"
              , "const"
              , "constexpr"
              , "const_cast"
              , "continue"
              , "constructor"
              , "decltype"
              , "default"
              , "delete"
              , "do"
              , "double"
              , "dynamic_cast"
              , "else"
              , "enum"
              , "explicit"
              , "export"
              , "extern"
              , "false"
              , "final"
              , "float"
              , "for"
              , "friend"
              , "goto"
              , "if"
              , "import"
              , "inline"
              , "int"
              , "list"
              , "long"
              , "mutable"
              , "namespace"
              , "new"
              , "nil"
              , "noexcept"
              , "not"
              , "not_eq"
              , "NULL"
              , "null"
              , "nullptr"
              , "nullptr_t"
              , "operator"
              , "or"
              , "or_eq"
              , "override"
              , "param"
              , "private"
              , "protected"
              , "public"
              , "PureScript"
              , "register"
              , "reinterpret_cast"
              , "requires"
              , "return"
              , "runtime_error"
              , "shared_list"
              , "short"
              , "signed"
              , "sizeof"
              , "static"
              , "static_assert"
              , "static_cast"
              , "std"
              , "string"
              , "struct"
              , "switch"
              , "symbol"
              , "template"
              , "this"
              , "thread_local"
              , "throw"
              , "true"
              , "try"
              , "typedef"
              , "typeid"
              , "typename"
              , "typeof"
              , "union"
              , "unknown_size"
              , "unsigned"
              , "using"
              , "virtual"
              , "void"
              , "volatile"
              , "wchar_t"
              , "while"
              , "xor"
              , "xor_eq" ] || properNameIsCppReserved name

normalizedName :: String -> String
normalizedName ('_' : s) | last s == '_', s' <- init s, nameIsCppReserved s' = s'
normalizedName s = s

moduleNameToCpp :: ModuleName -> String
moduleNameToCpp (ModuleName pns) =
  let name = intercalate "_" (runProperName `map` pns)
  in if properNameIsCppReserved name then '_' : name ++ "_" else name

-- |
-- Checks whether a proper name is reserved in C++11.
--
properNameIsCppReserved :: String -> Bool
properNameIsCppReserved name =
  name `elem` [ "Private"
              , "PureScript" ]
