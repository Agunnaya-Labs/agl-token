const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  const AGL = await hre.ethers.getContractFactory("AGLToken");
  const token = await AGL.deploy(deployer.address);

  await token.waitForDeployment();

  console.log("AGL deployed at:", await token.getAddress());
}

main().catch(console.error);
