// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title FractionalVault
 * @dev Turns a single NFT into N fractional ERC20 tokens.
 */
contract FractionalVault is ERC20, Ownable, ReentrancyGuard {
    IERC721 public immutable collection;
    uint256 public immutable tokenId;
    
    bool public forSale = false;
    uint256 public reservePrice;
    bool public canRedeem = false;

    event Fractionalized(address indexed owner, uint256 shares);
    event SaleStarted(uint256 price);
    event VaultSold(address indexed buyer, uint256 price);
    event Redeemed(address indexed user, uint256 ethAmount);

    constructor(
        address _collection,
        uint256 _tokenId,
        uint256 _totalSupply,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) Ownable(msg.sender) {
        collection = IERC721(_collection);
        tokenId = _tokenId;
        _mint(msg.sender, _totalSupply);
    }

    /**
     * @dev Initial setup: Owner must transfer NFT to this contract first.
     */
    function initialize(uint256 _reservePrice) external onlyOwner {
        require(collection.ownerOf(tokenId) == address(this), "NFT not in vault");
        reservePrice = _reservePrice;
        forSale = true;
        emit SaleStarted(_reservePrice);
    }

    /**
     * @dev Purchase the entire NFT by paying the reserve price.
     */
    function purchase() external payable nonReentrant {
        require(forSale, "Not for sale");
        require(msg.value >= reservePrice, "Insufficient ETH");

        forSale = false;
        canRedeem = true;
        
        collection.transferFrom(address(this), msg.sender, tokenId);
        emit VaultSold(msg.sender, msg.value);
    }

    /**
     * @dev Share holders burn shares to receive their portion of the ETH.
     */
    function redeem() external nonReentrant {
        require(canRedeem, "Redemption not active");
        uint256 totalEth = address(this).balance;
        uint256 userShares = balanceOf(msg.sender);
        require(userShares > 0, "No shares to redeem");

        uint256 ethToRedeem = (userShares * totalEth) / totalSupply();
        
        _burn(msg.sender, userShares);
        (bool success, ) = payable(msg.sender).call{value: ethToRedeem}("");
        require(success, "Transfer failed");

        emit Redeemed(msg.sender, ethToRedeem);
    }
}
