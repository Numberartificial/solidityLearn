## repo

Uniswap v3 在代码层面的架构和 v2 基本保持一致，将合约分成了两个仓库：
 * [uniswap-v3-core](https://github.com/Uniswap/v3-core)
 * [uniswap-v3-periphery](https://github.com/Uniswap/v3-periphery)

 1. core 仓库的功能主要包含在以下 2 个合约中：

UniswapV3Factory: 提供创建 pool 的接口，并且追踪所有的 pool
UniswapV3Pool: 实现代币交易，流动性管理，交易手续费的收取，oracle 数据管理。
 *note* 接口的实现粒度比较低，不适合普通用户使用，错误的调用其中的接口可能会造成经济上的损失。

 2. periphery 仓库的功能主要包含在以下 2 个合约：

SwapRouter: 提供代币交易的接口，它是对 UniswapV3Pool 合约中交易相关接口的进一步封装，前端界面主要与这个合约来进行对接。
NonfungiblePositionManager: 用来增加/移除/修改 Pool 的流动性，并且通过 NFT token 将流动性代币化。
  *note* 使用 ERC721 token（v2 使用的是 ERC20）的原因是同一个池的多个流动性并不能等价替换（v3 的集中流性动功能）。

### 调用