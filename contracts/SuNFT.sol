pragma solidity ^0.4.20;

import "./ERC721.sol";
import "./PublishInterfaces.sol";

/// @title Compliance with ERC-721 (draft) for Su Squares
/// @dev This implementation assumes:
///  - A fixed supply of NFTs, cannot mint or burn
///  - ids are numbered sequentially starting at 1.
///  - NFTs are initially assigned to this contract
///  - This contract does not externally call its own functions
///  - This contract does not receive NFTs
/// @author William Entriken (https://phor.net)
contract SuNFT is ERC721, ERC721Metadata, ERC721Enumerable, ERC165, PublishInterfaces {

    // COMPLIANCE WITH ERC721 //////////////////////////////////////////////////

    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);

    /// @dev This emits when the approved address for an NFT is changed or
    ///  reaffirmed. The zero address indicates there is no approved address.
    ///  When a Transfer event emits, this also indicates that the approved
    ///  address for that NFT (if any) is reset to none.
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0));
        return _nftsOfOwnerWithSubstitutions[_owner].length;
    }

    /// @notice Find the owner of an NFT
    /// @param _tokenId The identifier for an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId)
        public
        view
        mustBeValidNFT(_tokenId)
        returns (address _owner)
    {
        _owner = _ownerOfNFTWithSubstitutions[_tokenId];
        // Handle substitutions
        if (_owner == address(0)) {
            _owner = address(this);
        }
    }

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable
    {
        _safeTransferFrom(_from, _to, _tokenId, data);
    }

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to []
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable
    {
        _safeTransferFrom(_from, _to, _tokenId, "");
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(address _from, address _to, uint256 _tokenId)
        external
        payable
        mustBeValidNFT(_tokenId)
        canSend(_tokenId)
    {
        address owner = _ownerOfNFTWithSubstitutions[_tokenId];
        // Handle substitutions
        if (owner == address(0)) {
            owner = address(this);
        }
        require(owner == _from);
        require(_to != address(0));
        _transfer(_tokenId, _to);
    }

    /// @notice Set or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId)
        external
        payable
        // assert(mustBeValidNFT(_tokenId))
        canOperate(_tokenId)
    {
        address _owner = _ownerOfNFTWithSubstitutions[_tokenId];
        // Handle substitutions
        if (_owner == address(0)) {
            _owner = address(this);
        }
        _approvedOfNFT[_tokenId] = _approved;
        Approval(_owner, _approved, _tokenId);
    }

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all your asset.
    /// @dev Emits the ApprovalForAll event
    /// @param _operator Address to add to the set of authorized operators.
    /// @param _approved True if the operators is approved, false to revoke approval
    function setApprovalForAll(address _operator, bool _approved) external {
        _operatorsOfAddress[msg.sender][_operator] = _approved;
        ApprovalForAll(msg.sender, _operator, _approved);
    }

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 _tokenId)
        external
        view
        mustBeValidNFT(_tokenId)
        returns (address)
    {
        return _approvedOfNFT[_tokenId];
    }

    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return _operatorsOfAddress[_owner][_operator];
    }

    // COMPLIANCE WITH ERC721Metadata //////////////////////////////////////////

    /// @notice A descriptive name for a collection of NFTs in this contract
    function name() external pure returns (string) {
        return "Su Squares";
    }

    /// @notice An abbreviated name for NFTs in this contract
    function symbol() external pure returns (string) {
        return "SU";
    }

    /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
    /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
    ///  3986. The URI may point to a JSON file that conforms to the "ERC721
    ///  Metadata JSON Schema".
    function tokenURI(uint256 _tokenId)
        external
        view
        mustBeValidNFT(_tokenId)
        returns (string _tokenURI)
    {
        _tokenURI = "https://tenthousandsu.com/erc721/00000.json";
        bytes memory _tokenURIBytes = bytes(_tokenURI);
        _tokenURIBytes[33] = byte(48+(_tokenId / 10000) % 10);
        _tokenURIBytes[34] = byte(48+(_tokenId / 1000) % 10);
        _tokenURIBytes[35] = byte(48+(_tokenId / 100) % 10);
        _tokenURIBytes[36] = byte(48+(_tokenId / 10) % 10);
        _tokenURIBytes[37] = byte(48+(_tokenId / 1) % 10);

    }

    // COMPLIANCE WITH ERC721Enumerable ////////////////////////////////////////

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() external view returns (uint256) {
        return TOTAL_SUPPLY;
    }

    /// @notice Enumerate valid NFTs
    /// @dev Throws if `_index` >= `totalSupply()`.
    /// @param _index A counter less than `totalSupply()`
    /// @return The token identifier for the `_index`th NFT,
    ///  (sort order not specified)
    function tokenByIndex(uint256 _index) external view returns (uint256) {
        require(_index < TOTAL_SUPPLY);
        return _index + 1;
    }

    /// @notice Enumerate NFTs assigned to an owner
    /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
    ///  `_owner` is the zero address, representing invalid NFTs.
    /// @param _owner An address where we are interested in NFTs owned by them
    /// @param _index A counter less than `balanceOf(_owner)`
    /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
    ///   (sort order not specified)
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId) {
        require(_owner != address(0));
        _tokenId = _nftsOfOwnerWithSubstitutions[_owner][_index];
        // Handle substitutions
        if (_owner == address(this)) {
            if (_tokenId == 0) {
                _tokenId = _index + 1;
            }
        }
    }

    // INTERNAL INTERFACE //////////////////////////////////////////////////////

//TODO: consider making this throw if _nftId is an invalid NFT
    modifier mustBeOwnedByThisContract(uint256 _nftId) {
        address owner = _ownerOfNFTWithSubstitutions[_nftId];
        require(owner == address(0) || owner == address(this));
        _;
    }

    modifier canOperate(uint256 _tokenId) {
        // assert(msg.sender != address(this))
        address owner = _ownerOfNFTWithSubstitutions[_tokenId];
        require(msg.sender == owner || _operatorsOfAddress[owner][msg.sender]);
        _;
    }

//TODO: can save gas if you put a _from check here too...
    modifier canSend(uint256 _tokenId) {
        // assert(msg.sender != address(this))
        address owner = _ownerOfNFTWithSubstitutions[_tokenId];
        address approved = _approvedOfNFT[_tokenId];
        require(msg.sender == owner || msg.sender == approved ||
            _operatorsOfAddress[owner][msg.sender]);
        _;
    }

    modifier allowedToSendNFT(uint256 _nftId, address _addr) {
//TODO: IMPLEMEENT
        //require(...)
        _;
    }

    modifier mustBeValidNFT(uint256 _nftId) {
        require(_nftId >= 1 && _nftId <= TOTAL_SUPPLY);
        _;
    }

    /// @dev Actually do a transfer, does NO precondition checking
    function _transfer(uint256 _nftId, address _to) internal {
        // Here are the preconditions we are not checking:
        // assert(allowedToSendNFT(msg.sender, _nftId))
        // assert(mustBeValidNFT(_nftId))
        // assert(_to != address(0));

        // Find the FROM address
        address fromWithSubstitution = _ownerOfNFTWithSubstitutions[_nftId];
        address from = fromWithSubstitution;
        if (fromWithSubstitution == address(0)) {
            from = address(this);
        }

        // Take away from the FROM address
        // The Entriken algorithm for deleting from an indexed, unsorted array
        uint256 indexToDeleteWithSubstitution = _indexOfNFTOfOwnerWithSubstitutions[_nftId];
        uint256 indexToDelete;
        if (indexToDeleteWithSubstitution == 0) {
            indexToDelete = _nftId - 1;
        } else {
            indexToDelete = indexToDeleteWithSubstitution - 1;
        }
        if (indexToDelete != _nftsOfOwnerWithSubstitutions[from].length - 1) {
            uint256 lastNftWithSubstitution = _nftsOfOwnerWithSubstitutions[from][_nftsOfOwnerWithSubstitutions[from].length - 1];
            uint256 lastNft = lastNftWithSubstitution;
            if (lastNftWithSubstitution == 0) {
                // assert(from ==  address(0) || from == address(this));
                lastNft = _nftsOfOwnerWithSubstitutions[from].length;
            }
            _nftsOfOwnerWithSubstitutions[from][indexToDelete] = lastNft;
            _indexOfNFTOfOwnerWithSubstitutions[lastNft] = indexToDelete + 1;
        }
        delete _nftsOfOwnerWithSubstitutions[from][_nftsOfOwnerWithSubstitutions[from].length - 1]; // get gas back
        _nftsOfOwnerWithSubstitutions[from].length--;
        // Right now _indexOfNFTOfOwnerWithSubstitutions[_nftId] is invalid, set it below based on the new owner

        // Give to the TO address
        _nftsOfOwnerWithSubstitutions[_to].push(_nftId);
        _indexOfNFTOfOwnerWithSubstitutions[_nftId] = (_nftsOfOwnerWithSubstitutions[_to].length - 1) + 1;

        // External processing
        _ownerOfNFTWithSubstitutions[_nftId] = _to;
        Transfer(from, _to, _nftId);
    }
    // PRIVATE STORAGE AND FUNCTIONS ///////////////////////////////////////////

    uint256 private constant TOTAL_SUPPLY = 10000; // SOLIDITY ISSUE #3356 make this immutable

    bytes4 private constant MAGIC_ONERC721RECEIVED = bytes4(keccak256("onERC721Received(address,uint256,bytes)"));

    /// @dev The owner of each NFT
    ///  If value == address(0), NFT is owned by address(this)
    ///  If value != address(0), NFT is owned by value
    ///  assert(This contract never assigns awnerhip to address(0) or destroys NFTs)
    ///  See commented out code in constructor, saves hella gas
    mapping (uint256 => address) private _ownerOfNFTWithSubstitutions;

    /// @dev The authorized address for each NFT
    mapping (uint256 => address) private _approvedOfNFT;

    /// @dev The authorized operators for each address
    mapping (address => mapping (address => bool)) private _operatorsOfAddress;

    /// @dev The list of NFTs owned by each address
    ///  Nomenclature: this[key][index] = value
    ///  If key != address(this) or value != 0, then value represents an NFT
    ///  If key == address(this) and value == 0, then index + 1 is the NFT
    ///  assert(0 is not a valid NFT)
    ///  See commented out code in constructor, saves hella gas
    mapping (address => uint256[]) private _nftsOfOwnerWithSubstitutions;

    /// @dev (Location + 1) of each NFT in its owner's list
    ///  Nomenclature: this[key] = value
    ///  If value != 0, _nftsOfOwnerWithSubstitutions[owner][value - 1] = nftId
    ///  If value == 0, _nftsOfOwnerWithSubstitutions[owner][key - 1] = nftId
    ///  assert(2**256-1 is not a valid NFT)
    ///  See commented out code in constructor, saves hella gas
    mapping (uint256 => uint256) private _indexOfNFTOfOwnerWithSubstitutions;

    // Due to implementation choices (no mint, no burn, contiguous NFT ids), it
    // is not necessary to keep an array of NFT ids nor where each NFT id is
    // located in that array.
    // address[] private nftIds;
    // mapping (uint256 => uint256) private nftIndexOfId;

    function SuNFT() internal {
        // Publish interfaces with ERC-165
        supportedInterfaces[0x6466353c] = true; // ERC721
        supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
        supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable

        // The effect of substitution makes storing address(this), address(this)
        // ..., address(this) for a total of TOTAL_SUPPLY times unnecessary at
        // deployment time
        // for (uint256 i = 1; i <= TOTAL_SUPPLY; i++) {
        //     _ownerOfNFTWithSubstitutions[i] = address(this);
        // }

        // The effect of substitution makes storing 1, 2, ..., TOTAL_SUPPLY
        // unnecessary at deployment time
        _nftsOfOwnerWithSubstitutions[address(this)].length = TOTAL_SUPPLY;
        // for (uint256 i = 0; i < TOTAL_SUPPLY; i++) {
        //     _nftsOfOwnerWithSubstitutions[address(this)][i] = i + 1;
        // }
        // for (uint256 i = 1; i <= TOTAL_SUPPLY; i++) {
        //     _indexOfNFTOfOwnerWithSubstitutions[i] = i - 1;
        // }
    }

    /// @dev Actually perform the safeTransferFrom
    function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data)
        private
        mustBeValidNFT(_tokenId)
        canSend(_tokenId)
    {
        address owner = _ownerOfNFTWithSubstitutions[_tokenId];
        // Handle substitutions
        if (owner == address(0)) {
            owner = address(this);
        }
        require(owner == _from);
        require(_to != address(0));
        _transfer(_tokenId, _to);

        // Do the callback after everything is done to avoid reentrancy attack
        uint256 codeSize;
        assembly { codeSize := extcodesize(_to) }
        if (codeSize == 0) {
            return;
        }
        bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
        require(retval == MAGIC_ONERC721RECEIVED);
    }
}
