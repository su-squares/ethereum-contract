pragma solidity ^0.4.20;

import "./SuNFT.sol";

/// @title The features that square owners can use
/// @author William Entriken (https://phor.net)
/// @dev See SuMain contract documentation for detail on how contracts interact.
contract SuOperation is SuNFT {

    event Personalized(uint256 _nftId);

    /// @dev The main SuSquare struct. The owner may set these properties, subject
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
    ///  for a square are free then cost 100 finney (0.1 ether) each
    /// @param _squareId The top-left is 1, to its right is 2, ..., top-right is
    ///  100 and then 101 is below 1... the last one at bottom-right is 10000
    /// @param _squareId A 10x10 image for your square, in 8-bit RGB words
    ///  ordered like the squares are ordered. See Imagemagick's command
    ///  convert -size 10x10 -depth 8 in.rgb out.png
    /// @param _title A description of your square (max 64 bytes UTF-8)
    /// @param _href A hyperlink for your square (max 100 bytes)
    function personalizeSquare(
        uint256 _squareId,
        bytes _rgbData,
        string _title,
        string _href
    )
        external
        payable
    {
        address owner = ownerOf(_squareId);
        require(msg.sender == owner);
        require(bytes(_title).length <= 64);
        require(bytes(_href).length <= 100);
        require(_rgbData.length == 300);
        suSquares[_squareId].version++;
        suSquares[_squareId].rgbData = _rgbData;
        suSquares[_squareId].title = _title;
        suSquares[_squareId].href = _href;
        if (suSquares[_squareId].version > 3) {
            require(msg.value == 100 finney);
        }

        Personalized(_squareId);
    }

    /* Ignore this for now
    function checkPng(bytes _pngData) public {
        require(_pngData.length <= 400);
        require(_pngData.length >= 67); // Smallest legal PNG file size
        // Basic PNG validation, source: http://www.libpng.org/pub/png/spec/1.2/PNG-Structure.html
        // "The first eight bytes of a PNG file always contain the following (decimal) values:"
        require(_pngData[0] == 0x89); // 8-byte signature
        require(_pngData[1] == "P");
        require(_pngData[2] == "N");
        require(_pngData[3] == "G");
        require(_pngData[4] == 0x0d);
        require(_pngData[5] == 0x0a);
        require(_pngData[6] == 0x1a);
        require(_pngData[7] == 0x0a);
        // "The IHDR chunk must appear FIRST."
        // - "Each chunk consists of four parts:"
        // - "Length"
        require(_pngData[8] == 0x00);
        require(_pngData[9] == 0x00);
        require(_pngData[10] == 0x00);
        require(_pngData[11] == 0x0d);
        // - "Chunk Type"
        require(_pngData[12] == "I"); // IHDR chunk header
        require(_pngData[13] == "H");
        require(_pngData[14] == "D");
        require(_pngData[15] == "R");
        // - "Chunk Data"
        // "The IHDR ... contains:"
        require(_pngData[16] == 0x00); // IHDR width
        require(_pngData[17] == 0x00);
        require(_pngData[18] == 0x00);
        require(_pngData[19] == 0x0a);
        require(_pngData[20] == 0x00); // IHDR height
        require(_pngData[21] == 0x00);
        require(_pngData[22] == 0x00);
        require(_pngData[23] == 0x0a);
        // That's enough validation, I think
    }
    */
}
