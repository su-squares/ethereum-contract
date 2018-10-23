#/bin/sh
#
# sh confirm-sol-merged.sh
#
# Test that one merged Solidity file is the failthful combination of other
# Solidity files. Because a deployed Solidity program must be one single file,
# a project must be flattened. Some people use a build tool for this. But you
# may prefer to do it manually to increase readability.
#
# William Entriken (c) 2018. MIT license.


## Program inputs ##############################################################

set -e # Exit on failure
mkdir -p build

CONTRACTS_DIRECTORY=contracts
BUILT_FILE=ALLINONE.sol
SOURCE_FILES="AccessControl.sol ERC165.sol ERC721.sol SupportsInterface.sol SuNFT.sol SuOperation.sol SuPromo.sol SuVending.sol SuMain.sol"


## Test 1 -- Confirm file above exactly match what is in the repo ##############

ls $CONTRACTS_DIRECTORY | sort > build/actual_files

echo "$BUILT_FILE $SOURCE_FILES" | tr " " "\n" | sort > build/expected_files

diff build/actual_files build/expected_files # Dies if not equal (see set -e)


## Test 2 -- Confirm compiler versions match ###################################

UNIQUE_VERSIONS=$(grep -h '^pragma solidity' contracts/* | sort -u | wc -l)

expr "$UNIQUE_VERSIONS = 1" # Quoting fixes whitespace from wc command


## Test 3 -- Confirm files match ###############################################

(
  cat $CONTRACTS_DIRECTORY/$BUILT_FILE |
  grep -v '^pragma solidity' |
  grep -v '^/\* .*\.sol \**/$' | # File divider lines like /* Contract.sol ****/
  perl -0pe 's|^\W/\*[\s\S]*?\*/||g' # The first comment block (banner)
) > build/combined

(
  cd $CONTRACTS_DIRECTORY
  for BUILD_FILE in $SOURCE_FILES; do
    cat $BUILD_FILE |
    grep -v '^pragma solidity' |
    grep -v '^import \"'
  done
) > build/individual

diff -B build/combined build/individual # Ignore changes in blank links
