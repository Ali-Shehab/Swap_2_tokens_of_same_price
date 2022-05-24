// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


interface IERC20  {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract MyContract {

    //tokens of stable coins
    address public token1;
    address public token2;


    constructor (
        address _token1,
        address _token2
    ) public{
        token1 = _token1;
        token2 = _token2;

    }

    mapping(address => uint256) used; 
    mapping(address => uint256) amountSwapped;

    //swap between 2 stablecoins of same price
    function swap(address token,uint256 amount) public {
        require(amount>0,"Deposit my be greater than 0");
        require(token == token1 || token == token2,"Not supported token");
        if(token == token1)
        {
            IERC20 tokenA = IERC20(token1);
            IERC20 tokenB = IERC20(token2);
            require(tokenA.allowance(msg.sender, address(this)) >=amount,"increase allowance");
            _safeTransferFrom(tokenA, msg.sender, address(this), amount);
            tokenB.approve(address(this),amount);
            _safeTransferFrom(tokenB, address(this), msg.sender, amount);
            used[msg.sender]+=1;
            amountSwapped[msg.sender]+=amount;
            if(used[msg.sender]>=15 && amountSwapped[msg.sender] >= 2000 ){
                setReward(msg.sender);
            }
        }
        else if(token == token2){
            IERC20 tokenA = IERC20(token2);
            IERC20 tokenB = IERC20(token1);
            require(tokenA.allowance(msg.sender, address(this)) >=amount,"increase allowance");
            _safeTransferFrom(tokenA, msg.sender, address(this), amount);
            tokenB.approve(address(this),amount);
            _safeTransferFrom(tokenB, address(this), msg.sender, amount);
            used[msg.sender]+=1;
            amountSwapped[msg.sender]+=amount;
            if(used[msg.sender]>=15 && amountSwapped[msg.sender] >= 2000 ){
                setReward(msg.sender);
            }
        }
    }

    
    //if the user reached 15 swaps in our smart contract then reward him with 50 usdc
    function setReward(address user) internal
    {
        require(used[user]>=15 && amountSwapped[user] >=2000,"You have not reached 15 swap");
        IERC20 tokenA =IERC20(token1);
        used[user]=0;
        tokenA.approve(address(this),2);
        _safeTransferFrom(tokenA,address(this),user,2);
    }

    function _safeTransferFrom(IERC20 token, address sender,address reciever,uint256 amount) internal {
        bool sent = token.transferFrom(sender,reciever, amount);
        require(sent,"The transaction failed");
    }

    

}
