const hre = require("hardhat");

async function main() {
  const NFT_ADDRESS = "0x..."; // Target NFT Collection
  const TOKEN_ID = 1;
  const TOTAL_SHARES = ethers.parseEther("10000");

  const Vault = await hre.ethers.getContractFactory("FractionalVault");
  const vault = await Vault.deploy(
    NFT_ADDRESS, 
    TOKEN_ID, 
    TOTAL_SHARES, 
    "Bored Ape Fraction", 
    "fBAYC"
  );

  await vault.waitForDeployment();
  console.log("Fractional Vault deployed to:", await vault.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
