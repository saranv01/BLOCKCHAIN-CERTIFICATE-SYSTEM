// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/utils/Counters.sol


// OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)

pragma solidity ^0.8.0;



import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 */
library Counters {
    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}

contract UniversityCertificate is ERC721URIStorage  {

    address owner;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("SomeNFT", "CoolNFT") {
        owner = msg.sender;
    }

    mapping(address => string) public personToDegree;

    function claimDegree(string memory tokenURI)
        public
        returns (uint256)
    {
        require(issuedDegrees[msg.sender], "Degree is not issued");

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        personToDegree[msg.sender] = tokenURI;
        issuedDegrees[msg.sender] = false;

        return newItemId;
    }

    function checkDegreeOfPerson(address person) external view returns (string memory) {
        return personToDegree[person];
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    mapping(address => bool) public issuedDegrees;

    function issueDegree(address to) onlyOwner external {
        issuedDegrees[to] = true;
    }
}