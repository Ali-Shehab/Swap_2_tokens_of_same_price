from brownie import MyContract,network,config,Token1,Token2,interface
from scripts.used_functions import get_account

def deploy_swap():
    
    account = get_account()
    usdc = Token1.deploy(1000,{"from":account})
    usdt = Token2.deploy(1000,{"from":account})
    myContract = MyContract.deploy(usdc.address,usdt.address,{"from":account})


    usdc.transfer(myContract.address,500,{"from":account})
    usdt.transfer(myContract.address,500,{"from":account})

    print(usdc.balanceOf(myContract.address))
    print(usdt.balanceOf(myContract.address))
    
    usdc.approve(myContract.address,300,{"from":account})
    usdt.approve(myContract.address,300,{"from":account})


    for i in range(0,15):
        myContract.swap(usdc.address,15,{"from":account})
    print(usdc.balanceOf(myContract.address))
    print(usdt.balanceOf(myContract.address))

    print("************For User************")
    print(usdc.balanceOf(account.address))
    print(usdt.balanceOf(account.address))
    

def main():
    deploy_swap()