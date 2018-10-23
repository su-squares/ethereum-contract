pragma solidity ^0.4.24;

import "./SuNFT.sol";

/// @title The features that square owners can use
/// @author William Entriken (https://phor.net)
contract SuOperation is SuNFT {
    /// @dev The personalization of a square has changed
    event Personalized(uint256 _nftId);

    /// @dev The main SuSquare struct. The owner may set these properties,
    ///  subject to certain rules. The actual 10x10 image is rendered on our
    ///  website using this data.
    struct SuSquare {
        /// @dev This increments on each update
        uint256 version;

        /// @dev A 10x10 pixel image, stored 8-bit RGB values from left-to-right
        ///  and top-to-bottom order (normal English reading order). So it is
        ///  exactly 300 bytes. Or it is an empty array.
        ///  So the first byte is the red channel for the top-left pixel, then
        ///  the blue, then the green, and then next is the red channel for the
        ///  pixel to the right of the first pixel.
        bytes rgbData;

        /// @dev The title of this square, at most 64 bytes,
        string title;

        /// @dev The URL of this square, at most 100 bytes, or empty string
        string href;
    }

    /// @notice All the Su Squares that ever exist or will exist. Each Su Square
    ///  represents a square on our webpage in a 100x100 grid. The squares are
    ///  arranged in left-to-right, top-to-bottom order. In other words, normal
    ///  English reading order. So suSquares[1] is the top-left location and
    ///  suSquares[100] is the top-right location. And suSquares[101] is
    ///  directly below suSquares[1].
    /// @dev There is no suSquares[0] -- that is an unused array index.
    SuSquare[10001] public suSquares;

    /// @notice Update the contents of your square, the first 3 personalizations
    ///  for a square are free then cost 10 Finney (0.01 Ether) each
    /// @param _squareId The top-left is 1, to its right is 2, ..., top-right is
    ///  100 and then 101 is below 1... the last one at bottom-right is 10000
    /// @param _squareId A 10x10 image for your square, in 8-bit RGB words
    ///  ordered like the squares are ordered. See Imagemagick's command
    ///  convert -size 10x10 -depth 8 in.rgb out.png
    /// @param _title A description of your square (max 64 bytes UTF-8)
    /// @param _href A hyperlink for your square (max 96 bytes)
    function personalizeSquare(
        uint256 _squareId,
        bytes _rgbData,
        string _title,
        string _href
    )
        external
        onlyOwnerOf(_squareId)
        payable
    {
        require(bytes(_title).length <= 64);
        require(bytes(_href).length <= 96);
        require(_rgbData.length == 300);
        suSquares[_squareId].version++;
        suSquares[_squareId].rgbData = _rgbData;
        suSquares[_squareId].title = _title;
        suSquares[_squareId].href = _href;
        if (suSquares[_squareId].version > 3) {
            require(msg.value == 10 finney);
        }
        emit Personalized(_squareId);
    }
}
