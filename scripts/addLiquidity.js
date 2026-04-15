const hre = require("hardhat");
require("dotenv").config();

/**
 * Adds AGL liquidity to Uniswap-style router (Base)
 */

async function main() {
  const routerAddress = process.env.ROUTER;
  const tokenAddress = process.env.AGL;
  const wallet = process.env.WALLET;

  const router = await hre.ethers.getContractAt(
    "IUniswapV2Router",
    routerAddress
  );

  const token = await hre.ethers.getContractAt(
    "AGLToken",
    tokenAddress
  );

  const tokenAmount = hre.ethers.parseUnits("200000000", 18);
  const ethAmount = hre.ethers.parseEther("2");

  console.log("Approving router...");

  await token.approve(routerAddress, tokenAmount);

  console.log("Adding liquidity...");

  const deadline = Math.floor(Date.now() / 1000) + 600;

  const tx = await router.addLiquidityETH(
    tokenAddress,
    tokenAmount,
    0,
    0,
    wallet,
    deadline,
    { value: ethAmount }
  );

  await tx.wait();

  console.log("Liquidity added successfully 🚀");
}

main().catch(console.error);
