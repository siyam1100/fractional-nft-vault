# Fractional NFT Vault

This repository provides a high-quality, flat-structure solution for NFT fractionalization. By locking an NFT into this vault, the owner can mint a fixed supply of ERC20 "fractional shares," enabling liquid trading of illiquid assets.

## Core Features
* **Vault Creation**: Lock an ERC721 token and specify the total supply of shares.
* **Fractionalization**: Mints ERC20 tokens representing ownership of the locked NFT.
* **Buyout Logic**: Implements a "Reserve Price" mechanism where users can trigger an auction to buy out the entire NFT.
* **Claiming**: If a buyout is successful, share holders can burn their ERC20 tokens to claim their proportional share of the ETH used for the purchase.



## How it Works
1. **Deposit**: The owner transfers the NFT to the `FractionalVault`.
2. **Minting**: The contract mints $N$ shares to the owner's address.
3. **Trading**: Shares can be traded on any DEX (like Uniswap).
4. **Exit**: A buyer deposits ETH to trigger a buyout; if successful, the NFT is transferred to the buyer and the vault is closed.

## Tech Stack
* Solidity ^0.8.20
* OpenZeppelin ERC20 & ERC721
