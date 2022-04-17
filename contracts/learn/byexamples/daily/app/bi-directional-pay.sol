// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
pragma experimental ABIEncoderV2;

/**@dev
 * ECDSA 实现步骤
 * 第一步：初始化化秘钥组，生成ECDSA算法的公钥和私钥
 * 第二步：执行私钥签名， 使用私钥签名，生成私钥签名
 * 第三步：执行公钥签名，生成公钥签名
 * 第四步：使用公钥验证私钥签名
 * 备注：所谓的公钥与私钥匙成对出现。 遵从的原则就是“私钥签名、公钥验证”
 */

/*
Opening a channel
1. Alice and Bob fund a multi-sig wallet
2. Precompute payment channel address
3. Alice and Bob exchanges signatures of initial balances
4. Alice and Bob creates a transaction that can deploy a payment channel from
   the multi-sig wallet

Update channel balances
1. Repeat steps 1 - 3 from opening a channel
2. From multi-sig wallet create a transaction that will
   - delete the transaction that would have deployed the old payment channel
   - and then create a transaction that can deploy a payment channel with the
     new balances

Closing a channel when Alice and Bob agree on the final balance
1. From multi-sig wallet create a transaction that will
   - send payments to Alice and Bob
   - and then delete the transaction that would have created the payment channel

Closing a channel when Alice and Bob do not agree on the final balances
1. Deploy payment channel from multi-sig
2. call challengeExit() to start the process of closing a channel
3. Alice and Bob can withdraw funds once the channel is expired
*/

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract BiDirectionalPaymentChannel {
    using SafeMath for uint;
    using ECDSA for bytes32;

    event ChallengeExit(address indexed sender, uint nonce);
    event Withdraw(address indexed to, uint amount);

    address payable[2] public users;
    mapping(address => bool) public isUser;

    mapping(address => uint) public balances;

    uint public challengePeriod;
    uint public expiresAt;
    uint public nonce;

    modifier checkBalances(uint[2] memory _balances) {
        require(
            address(this).balance >= _balances[0].add(_balances[1]),
            "balance of contract must be >= to the total balance of users"
        );
        _;
    }

    // NOTE: deposit from multi-sig wallet
    constructor(
        address payable[2] memory _users,
        uint[2] memory _balances,
        uint _expiresAt,
        uint _challengePeriod
    ) payable checkBalances(_balances) {
        require(_expiresAt > block.timestamp, "Expiration must be > now");
        require(_challengePeriod > 0, "Challenge period must be > 0");

        for (uint i = 0; i < _users.length; i++) {
            address payable user = _users[i];

            require(!isUser[user], "user must be unique");
            users[i] = user;
            isUser[user] = true;

            balances[user] = _balances[i];
        }

        expiresAt = _expiresAt;
        challengePeriod = _challengePeriod;
    }

    function verify(
        bytes[2] memory _signatures,
        address _contract,
        address[2] memory _signers,
        uint[2] memory _balances,
        uint _nonce
    ) public pure returns (bool) {
        for (uint i = 0; i < _signatures.length; i++) {
            /*
            NOTE: sign with address of this contract to protect
                  agains replay attack on other contracts
            */
            bool valid = _signers[i] ==
                keccak256(abi.encodePacked(_contract, _balances, _nonce))
                    .toEthSignedMessageHash()
                    .recover(_signatures[i]);

            if (!valid) {
                return false;
            }
        }

        return true;
    }

    modifier checkSignatures(
        bytes[2] memory _signatures,
        uint[2] memory _balances,
        uint _nonce
    ) {
        // Note: copy storage array to memory
        address[2] memory signers;
        for (uint i = 0; i < users.length; i++) {
            signers[i] = users[i];
        }

        require(
            verify(_signatures, address(this), signers, _balances, _nonce),
            "Invalid signature"
        );

        _;
    }

    modifier onlyUser() {
        require(isUser[msg.sender], "Not user");
        _;
    }

    function challengeExit(
        uint[2] memory _balances,
        uint _nonce,
        bytes[2] memory _signatures
    )
        public
        onlyUser
        checkSignatures(_signatures, _balances, _nonce)
        checkBalances(_balances)
    {
        require(block.timestamp < expiresAt, "Expired challenge period");
        require(_nonce > nonce, "Nonce must be greater than the current nonce");

        for (uint i = 0; i < _balances.length; i++) {
            balances[users[i]] = _balances[i];
        }

        nonce = _nonce;
        expiresAt = block.timestamp.add(challengePeriod);

        emit ChallengeExit(msg.sender, nonce);
    }

    function withdraw() public onlyUser {
        require(block.timestamp >= expiresAt, "Challenge period has not expired yet");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        emit Withdraw(msg.sender, amount);
    }

    
}

contract ECDSAd{
    using SafeMath for uint;
    using ECDSA for bytes32;
    
    function testSign() public {

        address alice = address(0x9BEF5148fD530244a14830f4984f2B76BCa0dC58); //alice的公钥
        address bob = address(0x8Aa8b0D84cf523923A459a6974C9499581d1F93D); //bob的公钥
        bytes32 hash = keccak256("Signed by Alice"); //信息hash值
        (uint8 v, bytes32 r, bytes32 s) = sign(
            0x18ef5d5e78aa58a63503bcb48a563de61ffe7665d73ee22b4ab66ef15248be5a,
            hash
        ); //使用的alice的私钥、hash进行签名
        bytes memory sig = abi.encodePacked(r, s, v); //打包成测试需要的格式
        address signer = hash.recover(sig); //使用的ECDSA recover 函数得到签名地址
        (uint8 v2, bytes32 r2, bytes32 s2) = sign(
            0x4e1518672e45fb2746ec5a217330ed24d815d44537da647e973c06d0b0069053,
            hash
        ); //bob的私钥
        bytes memory sig2 = abi.encodePacked(r2, s2, v2);
        address signer2 = hash.recover(sig2);
    }

    function sign(uint256 pri, bytes32 msg)
        public
        returns (
            uint8,
            bytes32,
            bytes32
        )
    {
        // return vm_std_cheats.sign(pri, msg);
    }
}