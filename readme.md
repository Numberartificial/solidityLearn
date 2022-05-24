This is a new world!
welcome to ethureum environment!

### hardhat

* project main architecture
```
>$PROJECT_DIR
> ->contracts {-#main solidity code-}
> ->test {-#hardhat test case code-}
> ->scripts {-#hardhat deploy code-}
> ->[auto]artifacts {-# npx hardhat compile automatic generations}
> ->[dependencies]node_modules {-# node env will be gitignore`npm install --save-dev @nomiclabs/hardhat-ethers ethers @nomiclabs/hardhat-waffle ethereum-waffle chai`}
```

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

npx hardhat node
npx hardhat run scripts/hello-deploy.ts --network localhost
```

```
yarn init -y
yarn add -D hardhat
npx hardhad
yarn add -D @nomiclabs/hardhat-ethers ethers @nomiclabs/hardhat-waffle ethereum-waffle chai
yarn add --save-dev ts-node typescript
```

### remix

[docs](https://remix-ide.readthedocs.io/en/latest/remixd.html)

```
npm install -g @remix-project/remixd
remixd -s <absolute-path-to-the-shared-folder> --remix-ide <your-remix-ide-URL-instance>
remixd -s /home/numberartificial/now --remix-ide https://remix.ethereum.org
```


### tools

```
python3 -m http.server 6969
```

```
npx webpack
```