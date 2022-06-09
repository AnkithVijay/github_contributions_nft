//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract GithubContribution is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    constructor() ERC721("Github Contribution NFT", "GCB") {}

    struct NFTDetails {
        string nftImageUrl;
        string profileName;
        address userAddress;
        uint256 tokenId;
    }

    mapping(uint256 => NFTDetails) private data;
    mapping(address => uint256) private userData;

    function mintNft(string calldata imageUrl, string calldata profileName)
        public
    {
        uint256 tokenId = _tokenIds.current();
        _tokenIds.increment();
        data[tokenId] = NFTDetails(imageUrl, profileName, msg.sender, tokenId);
        userData[msg.sender] = tokenId;
        _safeMint(msg.sender, tokenId);
    }

    function getTokenUri(uint256 tokenId)
        public
        view
        returns (string memory tokenUri)
    {
        return data[tokenId].nftImageUrl;
    }

    function withdraw() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }
}
