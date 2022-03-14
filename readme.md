This is a new world!
welcome to ethureum environment!

### hardhat

* project main architecture
>$PROJECT_DIR
> ->contracts {-#main solidity code-}
> ->test {-#hardhat test case code-}
> ->scripts {-#hardhat deploy code-}
> ->[auto]artifacts {-# npx hardhat compile automatic generations}
> ->[dependencies]node_modules {-# node env will be gitignore`npm install --save-dev @nomiclabs/hardhat-ethers ethers @nomiclabs/hardhat-waffle ethereum-waffle chai`}

* command

```shell
pwd = $PROJECT_DIR

#any question find a man
npx hardhat help {command}

#编译solidity
npx hardhat compile

#hardhat network test
npx hardhat test

#hardhat deploy
npx hardhat run scripts/deploy.js --network <network-name>
```